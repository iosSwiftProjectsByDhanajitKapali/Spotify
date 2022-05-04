//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 04/05/22.
//

import Foundation
import UIKit

final class PlayBackPresenter {
    
    static func startPlayback(
        from viewController : UIViewController,
        track : AudioTrack){
            
            let vc = PlayerViewController()
            vc.title = track.name
            viewController.present(UINavigationController(rootViewController: vc), animated: true)
        }
    
    
    static func startPlayback(
        from viewController : UIViewController,
        tracks : [AudioTrack]){
            let vc = PlayerViewController()
            viewController.present(UINavigationController(rootViewController: vc), animated: true)
        }
    
    
    
}
