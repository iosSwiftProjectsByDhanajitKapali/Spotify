//
//  PlaylistDetailsResponse.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 02/05/22.
//

import Foundation

struct PlaylistDetailsResponse : Codable{
    let description : String
    let external_urls : [String : String]
    let id : String
    let images : [APIImage]
    let name : String
    let tracks : PlayListTrackResponse
}

struct PlayListTrackResponse : Codable{
    let items : [PlaylistItem]
}

struct PlaylistItem : Codable{
    let track : AudioTrack
}
