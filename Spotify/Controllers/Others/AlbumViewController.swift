//
//  AlbumViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 02/05/22.
//

import UIKit

class AlbumViewController: UIViewController {

    // MARK: - Private Variables
    private let album : Album
    private let collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            _,_ -> NSCollectionLayoutSection? in
            
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
                    heightDimension: .absolute(60)
                ),
                subitem : item,
                count : 1
            )
            
            //Section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(0.4)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
            ]
            return section
        })
    )
    private var viewModels = [AlbumTrackCollectionViewCellViewModel]()
    private var tracks = [AudioTrack]()
    
    init(album : Album){
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder : NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.register(AlbumTrackCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        collectionView.register(PlayListHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlayListHeaderCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchAlbums()
        
        //Share button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapSave))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - Private Methods
private extension AlbumViewController{
    
    func fetchAlbums(){
        APICaller.shared.getAlbumDetials(for: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        AlbumTrackCollectionViewCellViewModel(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "-"
                            //artworkURL: URL(string: $0.album?.images.first?.url ?? " ")
                        )
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    
    @objc func didTapSave(){
        let actionSheet = UIAlertController(title: album.name, message: "Would you like to save this album", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Save Album", style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else {return}
            //Make API call to save the playlist
            APICaller.shared.saveAlbumToLibrary(
                album: strongSelf.album) { sucess in
                    print("Saved:\(sucess)")
                }
            
        }))
        present(actionSheet, animated: true)
    }
}


// MARK: - CollectionView Delegate and Datasource Methods
extension AlbumViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, for: indexPath) as? AlbumTrackCollectionViewCell else {
            return UICollectionViewCell();
        }
        cell.configure(with: viewModels[indexPath.row])
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlayListHeaderCollectionReusableView.identifier, for: indexPath) as? PlayListHeaderCollectionReusableView , kind  == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderViewModel(
            name: album.name,
            ownerName: album.artists.first?.name,
            description: "Release Date : \(String.formattedDate(string: album.release_date))",
            artworkURL: URL(string: album.images.first?.url ?? "")
        )
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //Play Song
        var track = tracks[indexPath.row]
        track.album = self.album
        PlayBackPresenter.shared.startPlayback(from: self, track: track)
    }
}

extension AlbumViewController : PlayListHeaderCollectionReusableViewDelegate{
    func PlayListHeaderCollectionReusableViewDidTapPlayApp(_ header: PlayListHeaderCollectionReusableView) {
        print("Playing All")
        let tracksWithAlbum : [AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        PlayBackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }


}

