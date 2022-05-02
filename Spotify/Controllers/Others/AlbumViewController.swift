//
//  AlbumViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 02/05/22.
//

import UIKit

class AlbumViewController: UIViewController {

    private let album : Album
    
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
        
        APICaller.shared.getAlbumDetials(for: album) { result in
            switch result{
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
}
