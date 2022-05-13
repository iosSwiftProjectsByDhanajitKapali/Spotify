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
        
        view.addSubview(noPlayListView)
        noPlayListView.configure(with: ActionLabelViewModel(text: "You don't have any playlist yet", actionTitle: "Create"))
        
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlayListView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlayListView.center = view.center
    }
}


// MARK: - Private Methods
private extension LibraryPlaylistsViewController{
    func updateUI(){
        if playlist.isEmpty{
            //Show Label
            noPlayListView.isHidden = false
        }else{
            //Show Tabel
        }
    }
}
