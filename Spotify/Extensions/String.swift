//
//  String.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 03/05/22.
//

import Foundation

extension String {
    static func formattedDate(string : String) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: string) else{
            return string
        }
        
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}
