//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 02/05/22.
//

import Foundation

struct AlbumDetailsResponse : Codable{
    let album_type : String
    let artists : [Artist]
    let available_markets : [String]
    let external_urls : [String : String]
    let id : String
    let images : [APIImage]
    let label : String
    let name : String
    let tracks : TrackResponse
}

struct APIImage : Codable{
    let url : String
}

struct TrackResponse : Codable{
    let items : [AudioTrack]
}

