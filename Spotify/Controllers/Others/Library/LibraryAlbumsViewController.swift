//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 10/05/22.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    var albums = [Album]()
    
    //public var selectionHandler : ((Playlist) -> Void)?
    
    private let noAlbumsView = ActionLabelView()
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()

}


// MARK: - LifeCycle Methods
extension LibraryAlbumsViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemPink
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpNoAlbumsView()
        fetchUserSavedAlbums()
        
        //Add a close button (when this VC is opened through a LongPress)
//        if selectionHandler != nil{
//            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseVC))
//        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
        //noAlbumsView.center = view.center
        tableView.frame = view.bounds
    }
}


// MARK: - Private Methods
private extension LibraryAlbumsViewController{
    
    @objc func didTapCloseVC(){
        dismiss(animated: true)
    }
    
    func fetchUserSavedAlbums(){
        APICaller.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func setUpNoAlbumsView(){
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.configure(
            with: ActionLabelViewModel(
                text: "You don't have any Saved Albums yet",
                actionTitle: "Browse"
            )
        )
    }
    
    func updateUI(){
        if albums.isEmpty{
            //Show Label
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        }else{
            //Show Tabel
            tableView.reloadData()
            tableView.isHidden = false
            noAlbumsView.isHidden = true
        }
    }
}


// MARK: - Public Methods
extension LibraryAlbumsViewController {
    
}

// MARK: - ActionLabelViewDelegate Methods
extension LibraryAlbumsViewController : ActionLabelViewDelegate{
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }

}


// MARK: - UITableViewDelegate, UITableViewDataSource Methods
extension LibraryAlbumsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else{
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
            title: album.name,
            subtitle: album.artists.first?.name ?? "-",
            imageURL: URL(string: album.images.first?.url ?? "")))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album = albums[indexPath.row]
        
        //To check is the touch was a LongPress or a Simple tap
//        guard selectionHandler == nil else{
//            selectionHandler?(playlist)
//            dismiss(animated: true)
//            return
//        }
        
        let vc = AlbumViewController(album: album)
        //vc.ownedByUser = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

