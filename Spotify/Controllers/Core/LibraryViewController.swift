//
//  LibraryViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import UIKit

class LibraryViewController: UIViewController {

    // MARK: - Private Data Members
    private let playlistsVC = LibraryPlaylistsViewController()
    private let albumsVC = LibraryAlbumsViewController()
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        
        return scrollView
    }()
    
    private let toggleView = LibraryToggleView()
    
}


// MARK: - LifeCycle Methods
extension LibraryViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(toggleView)
        toggleView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height)
        
        addChildren()
        updateBarButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top+55,
            width: view.width,
            height: view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55
        )
        toggleView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: 210,
            height: 60)
    }
}


// MARK: - Private Methods
private extension LibraryViewController{
    
    func updateBarButtons(){
        switch toggleView.state  {
        case .playlist :
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddPlaylist))
        case .album :
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func didTapAddPlaylist(){
        playlistsVC.showCreatePlayListAlert()
    }
    
    func addChildren(){
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistsVC.didMove(toParent: self)
        
        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumsVC.didMove(toParent: self)
    }
}


// MARK: - ScrollView Delegate Methods
extension LibraryViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width-100){
            toggleView.updateView(for: .album)
            updateBarButtons()
        }else{
            toggleView.updateView(for: .playlist)
            updateBarButtons()
        }
    }
    
}


// MARK: - LibraryToggleViewDelegate Methods
extension LibraryViewController : LibraryToggleViewDelegate{
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
        updateBarButtons()
    }
    
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButtons()
    }
    
}
