//
//  AuthManager.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import Foundation

final class AuthManager{
    static let shared = AuthManager()
    
    private init(){}
    
    public var signInUrl : URL? {
        let scopes = "user-read-private"
        let redirectUri = "https://linktr.ee/dhanajitkapali"
        let base = "https://accounts.spotify.com/authorize"
        let urlString = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectUri)&show_dialog=TRUE"
        
        return URL(string: urlString)
    }
    
    var isSignedIn : Bool{
        return false
    }
    
    private var accessToken : String?{
        return nil
    }
    
    private var refreshToken : String?{
        return nil
    }
    
    private var tokenExpirationDate : Date?{
        return nil
    }
    
    private var shouldRefreshToken : Bool?{
        return nil
    }
    
}
