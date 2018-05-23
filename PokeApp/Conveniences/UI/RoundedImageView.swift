//
//  RoundedImageView.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 22/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {
    
    // MARK: - Properties
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            updateUI()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Lifecycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateUI()
    }
    
    // MARK: - UI
    private func updateUI() {
        layer.cornerRadius = bounds.size.height / 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
    
}
