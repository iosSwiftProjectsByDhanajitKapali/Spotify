//
//  SettingsModels.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 18/04/22.
//

import Foundation

struct Section {
    let title : String
    let options : [Option]
}

struct Option {
    let title : String
    let handler : () -> Void
}
