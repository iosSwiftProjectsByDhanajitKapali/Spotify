//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 29/04/22.
//

import Foundation

struct NewReleaseResponse : Codable{
    let albums : AlbumsResponse
}

struct AlbumsResponse : Codable{
    let items : [Album]
}

struct Album : Codable {
    let album_type : String
    let available_markets : [String]
    let id : String
    let images : [AlbumImage]
    let name : String
    let release_date : String
    let total_tracks : Int
    let artists : [Artist]
}

struct AlbumImage : Codable{
    let url : String
}

