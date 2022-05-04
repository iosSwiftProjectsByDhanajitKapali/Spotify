//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 04/05/22.
//

import Foundation
import UIKit

protocol PlayerDataSource : AnyObject{
    var songName : String? {get}
    var subtitle : String? {get}
    var imageURL : URL? {get}
}
    
final class PlayBackPresenter {
    
    static let shared = PlayBackPresenter()
    private var track : AudioTrack?
    private var tracks = [AudioTrack]()
    
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
            
            self.track = track
            self.tracks = []
            let vc = PlayerViewController()
            vc.title = track.name
            vc.dataSource = self
            viewController.present(UINavigationController(rootViewController: vc), animated: true)
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