//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 10/05/22.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {

    var playlist = [Playlist]()
    private let noPlayListView = ActionLabelView()
            

}


// MARK: - LifeCycle Methods
extension LibraryPlaylistsViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemPink
        
        setUpNoPlayListsView()
        fetchUserCreatedPlaylists()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlayListView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlayListView.center = view.center
    }
}


// MARK: - Private Methods
private extension LibraryPlaylistsViewController{
    
    func fetchUserCreatedPlaylists(){
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlist = playlists
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
        if playlist.isEmpty{
            //Show Label
            noPlayListView.isHidden = false
        }else{
            //Show Tabel
        }
    }
}


// MARK: - ActionLabelViewDelegate Methods
extension LibraryPlaylistsViewController : ActionLabelViewDelegate{
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        //Show an Alert, and ask USER to input the PlayList Name
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
            APICaller.shared.createPlaylist(with: text) { sucess in
                if sucess{
                    //Refresh the List of PlayList
                }else{
                    print("Failed to create playlist")
                }
            }
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
}
