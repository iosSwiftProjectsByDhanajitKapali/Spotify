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
        return accessToken != nil
    }
    
    private var accessToken : String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken : String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate : Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken : Bool{
        guard let tokenExpirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes : TimeInterval = 300
        
        //if token expired 5 minutes ago
        return currentDate.addingTimeInterval(fiveMinutes) >= tokenExpirationDate
    }
    
    public func exchangeCodeForToken(
    code : String,
    completion: @escaping ((Bool) -> Void)){
        //Get token
        guard let url = URL(string: Constants.URLs.tokenApiUrl) else {return}

        //create the URL query components
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: "\(code)"),
            URLQueryItem(name: "redirect_uri", value: "https://linktr.ee/dhanajitkapali")
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64Token = data?.base64EncodedString() else{
            print("Failed to encode to base64 Token")
            completion(false)
            return
        }
        request.setValue("Basic \(base64Token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data , error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from : data)
                self?.cacheToken(result : result)
                completion(true)
            } catch  {
                print(error.localizedDescription)
                completion(false)
            }

        }
        task.resume()
    }
    
    
    public func refreshAccessTokenIfNeeded(completion : @escaping((Bool) -> Void)){
//        guard shouldRefreshToken else{
//            completion(true)
//            return
//        }
        
        guard let refreshToken = refreshToken else {
            return
        }
        
        //refresh the token
        guard let url = URL(string: Constants.URLs.tokenApiUrl) else {return}

        //create the URL query components
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64Token = data?.base64EncodedString() else{
            print("Failed to encode to base64 Token")
            completion(false)
            return
        }
        request.setValue("Basic \(base64Token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data , error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from : data)
                self?.cacheToken(result : result)
                completion(true)
            } catch  {
                print(error.localizedDescription)
                completion(false)
            }

        }
        task.resume()

    }
    
    private func cacheToken(result : AuthResponse){
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token{
            UserDefaults.standard.set(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
