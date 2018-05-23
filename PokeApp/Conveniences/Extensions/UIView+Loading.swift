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
    private func createBlurView(_ style: UIBlurEffectStyle = .light, alpha: CGFloat = 0.85)  -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = alpha
        return blurEffectView
    }
    
    private func createActivityIndicator(_ style: UIActivityIndicatorViewStyle = .whiteLarge, color: UIColor = UIColor.lightGray) -> UIActivityIndicatorView  {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: style)
        activityIndicatorView.color = color
        return activityIndicatorView
    }
    
    // MARK: - Loading Methods
    func startLoading(in context: LoadingContext = .component, blur: Bool = false, backgroundColor: UIColor = UIColor.clear, activityIndicatorViewStyle: UIActivityIndicatorViewStyle? = nil, activityIndicatorColor: UIColor = UIColor.lightGray) {
        
        guard let parentView = context == .fullScreen ? (UIApplication.shared.delegate)!.window! : self else { return }
        
        // Create Loading view
        let loadingView = UIView(frame: parentView.frame)
        loadingView.backgroundColor = backgroundColor
        loadingView.tag = loadingViewTag
        loadingView.center = parentView.center
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(loadingView)
        // Configure loadingView autolayout
        loadingView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        
        // Create blurView if needed
        if blur {
            let blurView = createBlurView()
            blurView.frame = loadingView.frame
            blurView.center = loadingView.center
            blurView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.addSubview(blurView)
        }
        
        // Create activityIndicatorView
        var activityIndicatorStyle: UIActivityIndicatorViewStyle = context == .fullScreen ? .whiteLarge : .white
        if let activityIndicatorViewStyle = activityIndicatorViewStyle {
            activityIndicatorStyle = activityIndicatorViewStyle
        }
        let activityIndicator = createActivityIndicator(activityIndicatorStyle, color: activityIndicatorColor)
        activityIndicator.frame = loadingView.frame
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        // Configure activityIndicator autolayout
        activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        
    }
    
    func stopLoading() {
        let loadingView = viewWithTag(loadingViewTag)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                loadingView?.alpha = 0
            }, completion: { (completed) in
                loadingView?.removeFromSuperview()
            })
        }
    }
    
}
