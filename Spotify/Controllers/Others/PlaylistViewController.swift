//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let playlist : Playlist
    
    init(playlist : Playlist){
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder : NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getPlaylistDetials(for: playlist) { result in
            switch result{
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
    

}
