//
//  UITableViewExtension.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

extension UITableView {
    
    var scrollDidReachBottom: Bool {
        return self.contentOffset.y >= (self.contentSize.height - self.frame.size.height)
    }
    
}
