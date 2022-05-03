//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 03/05/22.
//

import Foundation

struct SearchResultResponse : Codable {
    let albums : SearchAlbumResponse
    let artists : SearchArtistResponse
    let playlists : SearchPlaylistResponse
    let tracks : SearchTrackResponse
}

struct SearchAlbumResponse : Codable {
    let items : [Album]
}

struct SearchArtistResponse : Codable {
    let items : [Artist]
}

struct SearchPlaylistResponse : Codable {
    let items : [Playlist]
}

struct SearchTrackResponse : Codable {
    let items : [AudioTrack]
}
