//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 14/05/22.
//

import Foundation

struct LibraryAlbumsResponse : Codable {
    let items : [SavedAlbum]
}

struct SavedAlbum : Codable {
    let added_at : String
    let album : Album
}
