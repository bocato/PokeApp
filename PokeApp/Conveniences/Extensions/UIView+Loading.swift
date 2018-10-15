//
//  UIView+Loading.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

// MARK: Constants
fileprivate let loadingViewTag = 11111

extension UIView {
    
    // MARK: Enum
    enum LoadingContext {
        case fullScreen
        case component
    }
    
    // MARK: - Loading View Components
    private func createBlurView(_ style: UIBlurEffect.Style = .light, alpha: CGFloat = 0.85)  -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = alpha
        return blurEffectView
    }
    
    private func createActivityIndicator(_ style: UIActivityIndicatorView.Style = .whiteLarge, color: UIColor = UIColor.lightGray) -> UIActivityIndicatorView  {
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        activityIndicatorView.color = color
        return activityIndicatorView
    }
    
    // MARK: - Loading Methods
    func startLoading(in context: LoadingContext = .component, blur: Bool = false, backgroundColor: UIColor = UIColor.clear, activityIndicatorViewStyle: UIActivityIndicatorView.Style? = nil, activityIndicatorColor: UIColor = UIColor.lightGray) {
        
        DispatchQueue.main.async {
            guard let parentView = context == .fullScreen ? (UIApplication.shared.delegate)!.window! : self else { return }
            
            // Create Loading view
            let loadingView = UIView(frame: parentView.frame)
            loadingView.backgroundColor = backgroundColor
            loadingView.tag = loadingViewTag
            loadingView.center = parentView.center
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.layer.zPosition = 1
            parentView.addSubview(loadingView)
            // Configure loadingView autolayout
            loadingView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
            loadingView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
            
            // Create blurView if needed
            if blur {
                let blurView = self.createBlurView()
                blurView.frame = loadingView.frame
                blurView.center = loadingView.center
                blurView.translatesAutoresizingMaskIntoConstraints = false
                loadingView.addSubview(blurView)
            }
            
            // Create activityIndicatorView
            var activityIndicatorStyle: UIActivityIndicatorView.Style = context == .fullScreen ? .whiteLarge : .white
            if let activityIndicatorViewStyle = activityIndicatorViewStyle {
                activityIndicatorStyle = activityIndicatorViewStyle
            }
            let activityIndicator = self.createActivityIndicator(activityIndicatorStyle, color: activityIndicatorColor)
            activityIndicator.frame = loadingView.frame
            activityIndicator.startAnimating()
            loadingView.addSubview(activityIndicator)
            // Configure activityIndicator autolayout
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        }
        
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            let loadingView = self.viewWithTag(loadingViewTag)
            UIView.animate(withDuration: 0.2, animations: {
                loadingView?.alpha = 0
            }, completion: { (completed) in
                loadingView?.removeFromSuperview()
            })
        }
    }
    
}

