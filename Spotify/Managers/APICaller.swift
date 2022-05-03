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
    
    
    
    //Create Request Used in API calls
    enum HTTPMethod : String{
        case GET
        case POST
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
