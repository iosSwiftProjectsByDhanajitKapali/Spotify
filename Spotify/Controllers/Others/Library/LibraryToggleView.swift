//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 10/05/22.
//

import UIKit

protocol LibraryToggleViewDelegate : AnyObject {
    func libraryToggleViewDidTapPlaylists(_ toggleView : LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView : LibraryToggleView)
}

class LibraryToggleView: UIView {

    weak var delegate : LibraryToggleViewDelegate?
    
    enum ToggleViewState {
        case playlist
        case album
    }
    var state : ToggleViewState = .playlist
    
    // MARK: - Private Data Members
    private let playlistsButton : UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumsButton : UIButton = {
       let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    // MARK: - LifeCylce Methods
    override init(frame : CGRect){
        super.init(frame: frame)
        //backgroundColor = .red
        addSubview(playlistsButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        
        playlistsButton.addTarget(self, action: #selector(didTapPlaylistsButton), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbumsButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistsButton.frame = CGRect(x: 0, y: 0, width: 100, height: 45)
        albumsButton.frame = CGRect(x: 110, y: 0, width: 100, height: 45)
        layoutIndicatorView()
        
    }

}


// MARK: - Private Methods
private extension LibraryToggleView{
    
    @objc func didTapPlaylistsButton(){
        state = .playlist
        UIView.animate(withDuration: 0.2){
            self.layoutSubviews()
        }
        delegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc func didTapAlbumsButton(){
        state = .album
        UIView.animate(withDuration: 0.2){
            self.layoutSubviews()
        }
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
    func layoutIndicatorView(){
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: 0, y: playlistsButton.bottom - 5, width: 100, height: 2)
        case .album:
            indicatorView.frame = CGRect(x: 100, y: playlistsButton.bottom - 5, width: 100, height: 2)
        }
    }
}


// MARK: - Public Methods
extension LibraryToggleView {
    
    func updateView(for state : ToggleViewState){
        self.state = state
        UIView.animate(withDuration: 0.2){
            self.layoutIndicatorView()
        }
    }
}
