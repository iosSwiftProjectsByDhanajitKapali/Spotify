//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 29/04/22.
//

import Foundation

struct FeaturedPlaylistsReeponse : Codable{
    let playlists : PlaylistResponse
}

struct PlaylistResponse : Codable{
    let items : [Playlist]
}

struct PlaylistImage : Codable{
    let url : String
}

struct User : Codable{
    let display_name : String
    let external_urls : [String : String]
    let id : String
}


