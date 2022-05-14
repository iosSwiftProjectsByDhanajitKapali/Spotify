//
//  APICaller.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    private init() {}
    
    enum APIError :Error{
        case failedToGetData
    }
    
    ///Get Current LoggedIn user details
    public func getCurrentUserProfile(completion: @escaping(Result<UserProfile, Error>) -> Void){
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/me"),
                      type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    //print(result)
                    completion(.success(result))
                } catch  {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    ///Get NewReleases (Songs) list
    public func getNewReleases(completion: @escaping(Result<NewReleaseResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/browse/new-releases?.limit=50"),
                      type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleaseResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                } catch  {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    ///Get the Featured Playlists  list as Per the logged in User
    public func getFeturedPlaylists(completion: @escaping(Result<FeaturedPlaylistsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/browse/featured-playlists?.limit=50"),
                      type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print(result)
                    completion(.success(result))
                } catch  {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    ///Get list of recommended songs (based of logged in user)
    public func getRecommendations(genres : Set<String>, completion: @escaping(Result<RecommendationsResponse, Error>) -> Void){
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/recommendations?limit=40&seed_genres=\(seeds)"),
                      type: .GET) { baseRequest in
            //print(baseRequest.url?.absoluteString)
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print("The result ->", result)
                    completion(.success(result))
                } catch  {
                    print("Error ->", error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    ///Get list of recommended genres (acc. to logged in user)
    public func getRecommendedGenres(completion: @escaping(Result<RecommendedGenresReponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/recommendations/available-genre-seeds"),
                      type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresReponse.self, from: data)
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print(result)
                    completion(.success(result))
                } catch  {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    ///Get the Album Details (you need to pass Album ID)
    public func getAlbumDetials(for album : Album, completion : @escaping(Result<AlbumDetailsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/albums/" + (album.id)), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("No data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                }catch{
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    ///Get Playlist detials (you need to pass the PlayList ID)
    public func getPlaylistDetials(for playlist : Playlist, completion : @escaping(Result<PlaylistDetailsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/playlists/" + (playlist.id)), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("No data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(result)
                }catch{
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    ///Get Current Users Playlists
    public func getCurrentUserPlaylists(completion : @escaping (Result<[Playlist], Error>) -> Void){
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/me/playlists/?limit=50") , type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("No data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: data)
                    //print(result)
                    completion(.success(result.items))
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(result)
                }catch{
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    ///Create a New Playlist (You need to Provide "UserID" and "PlayListName")
    public func createPlaylist(with name : String, completion : @escaping (Bool) -> Void){
        getCurrentUserProfile { [weak self] result in
            switch result{
            case .success(let profile):
                let urlString = Constants.URLs.baseApiUrl + "/users/\(profile.id)/playlists"
                self?.createRequest(with: URL(string: urlString), type: .POST, completion: { baseRequest in
                    var request = baseRequest
                    let json = [
                        "name" : name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data , error == nil else {
                            completion(false)
                            return
                        }
                        
                        do{
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            //print(result)
                            if let response = result as? [String : Any], response["id"] as? String != nil{
                                print("PlayList Created")
                                completion(true)
                            }else{
                                print("Failed to Creat Playlist")
                                completion(false)
                            }
                            
                            //let result = try JSONDecoder().decode(Playlist.self, from: data)
                            
                        }catch{
                            print(error.localizedDescription)
                            completion(false)
                        }

                    }
                    task.resume()
                })
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func addTrackToPlaylist(track : AudioTrack, playlist: Playlist, completion : @escaping (Bool) -> Void){
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/playlists/\(playlist.id)/tracks"), type: .POST) { baseRequest in
            var request = baseRequest
            let json = [
                "uris" : ["spotify:track:\(track.id)"]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("No data")
                    completion(false)
                    return
                }
                
                do {
                    //let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    //print(result.categories.items)
                    
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print(result)
                    
                    if let response = result as? [String : Any], response["snapshot_id"] as? String != nil{
                        print("Track added in PlayList")
                        completion(true)
                    }else{
                        print("Failed to Add Track to the Playlist")
                        completion(false)
                    }
                    
                    
                }catch{
                    print(error)
                    completion(false)
                }

            }
            task.resume()
        }
    }
    
    public func removeTrackFromPlaylist(track : AudioTrack, playlist : Playlist, completion : @escaping (Bool) -> Void){
        createRequest(
            with: URL(string: Constants.URLs.baseApiUrl + "/playlists/\(playlist.id)/tracks"),
            type: .DELETE
        )
        { baseRequest in
            var request = baseRequest
            let json : [String : Any] = [
                "tracks" : [
                    [
                        "uri" : "spotify:track:\(track.id)"
                    ]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("No data")
                    completion(false)
                    return
                }
                
                do {
                    //let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    //print(result.categories.items)
                    
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print(result)
                    
                    if let response = result as? [String : Any], response["snapshot_id"] as? String != nil{
                        print("Track added in PlayList")
                        completion(true)
                    }else{
                        print("Failed to Add Track to the Playlist")
                        completion(false)
                    }
                    
                    
                }catch{
                    print(error)
                    completion(false)
                }

            }
            task.resume()
        }
    }
    
    ///Get the Categories
    public func getCategories(completion : @escaping(Result<[Category], Error>) -> Void){
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/browse/categories?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("No data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    //print(result.categories.items)
                    completion(.success(result.categories.items))
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(result)
                }catch{
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    ///Get a PlayList according to the Category ID
    public func getCategoryPlaylist(category : Category , completion : @escaping(Result<[Playlist], Error>) -> Void){
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/browse/categories/\(category.id)/playlists"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("No data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    //print(result)
                    completion(.success(result.playlists.items))
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(result)
                }catch{
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    ///Get SearchResult according to the query passed
    public func search(with query : String , completion : @escaping(Result<[SearchResult], Error>) -> Void){
        createRequest(with: URL(string: Constants.URLs.baseApiUrl + "/search?limit=10&type=album,playlist,artist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("No data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    //print(result)
                    var searchResults : [SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0)}))
                    searchResults.append(contentsOf: result.albums.items.compactMap({ .album(model: $0)}))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0)}))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0)}))
                    completion(.success(searchResults))
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(result)
                }catch{
                    print(error)
                    completion(.failure(error))
                }

            }
            task.resume()
        }
    }
    
    //Create Request Used in API calls
    enum HTTPMethod : String{
        case GET
        case POST
        case DELETE
    }
    private func createRequest(with url : URL? , type: HTTPMethod, completion: @escaping(URLRequest) -> Void){
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else{
                print("Error While Creating the Request")
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
