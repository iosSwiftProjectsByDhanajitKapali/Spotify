//
//  Artist.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import Foundation

struct Artist : Codable{
    let id : String
    let name : String
    let type : String
    let external_urls : [String : String]
}
