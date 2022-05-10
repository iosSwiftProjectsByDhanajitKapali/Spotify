//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 04/05/22.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource : AnyObject{
    var songName : String? {get}
    var subtitle : String? {get}
    var imageURL : URL? {get}
}
    
final class PlayBackPresenter {
    
    static let shared = PlayBackPresenter()
    private var track : AudioTrack?
    private var tracks = [AudioTrack]()
    var player : AVPlayer?
    
    var currentTrack : AudioTrack? {
        if let track = track , tracks.isEmpty{
            return track
        }else if !tracks.isEmpty{
            return tracks.first
        }
        
        return nil
    }
    
    func startPlayback(
        from viewController : UIViewController,
        track : AudioTrack){
            
            guard let songPreviewURL = URL(string: track.preview_url ?? "") else {return}
            player = AVPlayer(url: songPreviewURL)
            player?.volume = 0.5
            
            self.track = track
            self.tracks = []
            let vc = PlayerViewController()
            vc.title = track.name
            vc.dataSource = self
            vc.delegate = self
            viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
                self?.player?.play()
            }
        }
    
    
    func startPlayback(
        from viewController : UIViewController,
        tracks : [AudioTrack]){
            self.tracks = tracks
            self.track = nil
            let vc = PlayerViewController()
            viewController.present(UINavigationController(rootViewController: vc), animated: true)
        }
    
}


extension PlayBackPresenter : PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
        
}


extension PlayBackPresenter : PlayerViewControllerDelegate{
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player{
            if player.timeControlStatus == .playing{
                player.pause()
            }else{
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty{  //Not a playlist or album
            player?.pause()
        }
        else{
            
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty{  //Not a playlist or album
            player?.pause()
            player?.play()
        }
        else{
            
        }
    }
    
    
}
