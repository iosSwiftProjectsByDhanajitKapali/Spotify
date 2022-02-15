//
//  Constants.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 09/02/22.
//

import Foundation

struct Constants {
    static let clientID = "44042f0aea5348a9911f1ab17204e6b0"
    static let clientSecret = "ee40798f806941fc871f8cb168fb7b22"
    static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    
    struct URLs{
        static let tokenApiUrl = "https://accounts.spotify.com/api/token"
    }
}
