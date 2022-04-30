//
//  Playlist.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import Foundation

struct Playlist : Codable{
    let description : String
    let external_urls : [String : String]
    let id : String
    let images : [PlaylistImage]
    let name : String
    let owner : User
}
