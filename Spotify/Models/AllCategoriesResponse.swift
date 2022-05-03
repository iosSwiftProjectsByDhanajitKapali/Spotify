//
//  AllCategoriesResponse.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 03/05/22.
//

import Foundation

struct AllCategoriesResponse : Codable {
    let categories : Categories
    
}

struct Categories : Codable{
    let items : [Category]
}

struct Category : Codable{
    let id : String
    let name : String
    let icons : [APIImage]
}
