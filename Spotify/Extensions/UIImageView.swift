//
//  UIImageView+Extensions.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 20/04/22.
//

import UIKit
extension UIImageView {
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
