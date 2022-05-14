//
//  ViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import UIKit

enum BrowseSectionType {
    case newRelease(viewModels :[NewReleaseCellViewModel])
    case featuredPlaylists(viewModels :[FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModels :[RecommendedTrackCellViewModel])
    
    var title : String {
        switch self{
        case .newRelease:
            return "New Released Albums"
        case .featuredPlaylists:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recommended Songs"
        }
    }
}

class HomeViewController: UIViewController {
    
    // MARK: - Private Data Members
    private var collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout{
        sectionIndex , _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSecionLayout(section : sectionIndex)
        }
    )

    private let spinner : UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    //
    private var sections = [BrowseSectionType]()
    private var newAlbums : [Album] = []
    private var playlists : [Playlist] = []
    private var tracks : [AudioTrack] = []
}

// MARK: - LifeCycle Methods
extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        
        configureCollectionVIew()
        view.addSubview(spinner)
        fetchData()
        
        addLongTapGesture()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - Private Methods
private extension HomeViewController{
    
    func addLongTapGesture(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress(_ gesture : UILongPressGestureRecognizer){
        guard gesture.state == .began else{
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint), indexPath.section == 2 else{
            return
        }
        
        //Get the track selected
        let model = tracks[indexPath.row]
        let actionSheet = UIAlertController(
            title: model.name,
            message: "Would you like to add this track in a playlist",
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Add to a playlist", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistsViewController()
                vc.selectionHandler = { playlist in
                    //Make the API call to add the track into the selected Playlist
                    APICaller.shared.addTrackToPlaylist(
                        track: model,
                        playlist: playlist) { result in
                            print("Added to Playlist \(result)")
                        }
                }
                vc.title = "Select A Playlist"
                self?.present(UINavigationController(rootViewController: vc), animated: true)
            }
        }))
        present(actionSheet, animated: true, completion: nil)
        
                
    }
    
    func configureCollectionVIew(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTracksCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    static func createSecionLayout(section : Int) -> NSCollectionLayoutSection{
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        switch section{
        case 0 :
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Vertical Group in Horizontal Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem : item,
                count : 3
            )
            
            //Group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)
                ),
                subitem : verticalGroup,
                count : 1
            )
            
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case   1 :
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Vertical Group in Horizontal Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem : item,
                count : 2
            )
            
            //Group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem : verticalGroup,
                count : 1
            )
            
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 2:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Vertical Group in Horizontal Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(80)
                ),
                subitem : item,
                count : 1
            )
            
            //Section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            //section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        default :
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem : item,
                count : 1
            )
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    func fetchData(){
        //DispatchGroup for concurrenlty make the API calls
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        //New Releases
        var newReleases : NewReleaseResponse?
        APICaller.shared.getNewReleases { result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model) :
                newReleases = model
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
        
        //Fetured Playlist
        var featuredPlaylist : FeaturedPlaylistsResponse?
        APICaller.shared.getFeturedPlaylists { result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model) :
                featuredPlaylist = model
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
        
        //Recommended Tracks
        var recommendation : RecommendationsResponse?
        APICaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5{
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds) { recommendationsResult in
                    defer{
                        group.leave()
                    }
                    switch recommendationsResult{
                    case .success(let model) :
                        recommendation = model
                    case .failure(let error) :
                        print(error.localizedDescription)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main){
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recommendation?.tracks else{
                return
            }
            self.configureModels(newAlbums: newAlbums, playlists: playlists, tracks: tracks)
        }
        
        //Configure Models
        
    }
    
    func configureModels(newAlbums : [Album], playlists : [Playlist], tracks : [AudioTrack]){
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        sections.append(.newRelease(viewModels: newAlbums.compactMap({ return
            NewReleaseCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "-")
        })))
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({ return
            FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name)
        })))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({ return
            RecommendedTrackCellViewModel(name: $0.name, artistName: $0.artists.first?.name ?? "-", artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
        })))
        collectionView.reloadData()
    }
    
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        //vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Collection View Delegate DataSource
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section{
        case .newRelease:
            let album = newAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .featuredPlaylists:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks:
            let track = tracks[indexPath.row]
            PlayBackPresenter.shared.startPlayback(from: self, track: track)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type{
        case .newRelease(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            //cell.backgroundColor = .red
            return cell

        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            //cell.backgroundColor = .green
            return cell
        
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier, for: indexPath) as? RecommendedTracksCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
//            cell.backgroundColor = .blue
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type{
        case .newRelease(let viewModels):
            return viewModels.count

        case .featuredPlaylists(let viewModels):
            return viewModels.count
        
        case .recommendedTracks(let viewModels):
            return viewModels.count 
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
                
    }
    
}
