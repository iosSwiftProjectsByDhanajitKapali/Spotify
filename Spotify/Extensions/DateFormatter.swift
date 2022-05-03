//
//  DateFormatter.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 03/05/22.
//

import Foundation

extension DateFormatter{
    static let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYY-MM-dd"
        return dateFormatter
    }()
    
    static let displayDateFormatter  : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}
