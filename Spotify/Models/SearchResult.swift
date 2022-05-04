//
//  SearchResult.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 03/05/22.
//

import Foundation

enum SearchResult {
    case artist(model : Artist)
    case album(model : Album)
    case track(model : AudioTrack)
    case playlist(model : Playlist)
}
