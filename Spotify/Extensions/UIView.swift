//
//  Extensions.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 09/02/22.
//

import UIKit

extension UIView{
    var width : CGFloat {
        return frame.size.width
    }
    
    var height : CGFloat {
        return frame.size.height
    }
    
    var left : CGFloat {
        return frame.origin.x
    }
    
    var right : CGFloat {
        return left + width
    }
    
    var top : CGFloat {
        return frame.origin.x
    }
    
    var bottom : CGFloat {
        return top + height
    }
}
