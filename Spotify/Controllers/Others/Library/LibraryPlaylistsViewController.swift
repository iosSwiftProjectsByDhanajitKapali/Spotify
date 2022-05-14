//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 10/05/22.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {

    var playlists = [Playlist]()
    
    public var selectionHandler : ((Playlist) -> Void)?
    
    private let noPlayListView = ActionLabelView()
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()

}


// MARK: - LifeCycle Methods
extension LibraryPlaylistsViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemPink
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpNoPlayListsView()
        fetchUserCreatedPlaylists()
        
        //Add a close button (when this VC is opened through a LongPress)
        if selectionHandler != nil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseVC))
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlayListView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlayListView.center = view.center
        tableView.frame = view.bounds
    }
}


// MARK: - Private Methods
private extension LibraryPlaylistsViewController{
    
    @objc func didTapCloseVC(){
        dismiss(animated: true)
    }
    
    func fetchUserCreatedPlaylists(){
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func setUpNoPlayListsView(){
        view.addSubview(noPlayListView)
        noPlayListView.delegate = self
        noPlayListView.configure(
            with: ActionLabelViewModel(
                text: "You don't have any playlist yet",
                actionTitle: "Create"
            )
        )
    }
    
    func updateUI(){
        if playlists.isEmpty{
            //Show Label
            noPlayListView.isHidden = false
            tableView.isHidden = true
        }else{
            //Show Tabel
            tableView.reloadData()
            tableView.isHidden = false
            noPlayListView.isHidden = true
        }
    }
}


// MARK: - Public Methods
extension LibraryPlaylistsViewController {
    func showCreatePlayListAlert(){
        let alert = UIAlertController(title: "Create New Playlist", message: "Enter playlist name", preferredStyle: .alert)
        alert.addTextField{
            textField in
            textField.placeholder = "Playlist Name..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty
            else{ return }
            
            //Make API call to create the PlayList
            APICaller.shared.createPlaylist(with: text) {[weak self] sucess in
                if sucess{
                    //Refresh the List of PlayList
                    self?.fetchUserCreatedPlaylists()
                }else{
                    print("Failed to create playlist")
                }
            }
            
        }))
        present(alert, animated: true, completion: nil)

    }
}

// MARK: - ActionLabelViewDelegate Methods
extension LibraryPlaylistsViewController : ActionLabelViewDelegate{
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        //Show an Alert, and ask USER to input the PlayList Name
        showCreatePlayListAlert()
    }
    
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource Methods
extension LibraryPlaylistsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else{
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
            title: playlist.name,
            subtitle: playlist.owner.display_name,
            imageURL: URL(string: playlist.images.first?.url ?? "")))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        
        //To check is the touch was a LongPress or a Simple tap
        guard selectionHandler == nil else{
            selectionHandler?(playlist)
            dismiss(animated: true)
            return
        }
        
        let vc = PlaylistViewController(playlist: playlist)
        vc.ownedByUser = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
