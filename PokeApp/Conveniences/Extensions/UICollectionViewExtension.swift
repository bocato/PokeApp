//
//  UICollectionViewExtension.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    var centerCellIndexPath: IndexPath? {
        
        if visibleCells.count == 0 {
            return nil
        }
        
        var closestCellFromCenter = visibleCells[0]
        for cell in visibleCells {
            let closestCellDelta = fabs(closestCellFromCenter.center.x - self.bounds.size.width/2 - self.contentOffset.x)
            let cellDelta = fabs(cell.center.x - self.bounds.size.width/2 - self.contentOffset.x)
            if cellDelta < closestCellDelta {
                closestCellFromCenter = cell
            }
        }
        
        return indexPath(for: closestCellFromCenter)
    }
    
    var scrollDidReachRightEdge: Bool {
        return self.contentOffset.x >= (self.contentSize.width - self.frame.size.width)
    }
    
}
