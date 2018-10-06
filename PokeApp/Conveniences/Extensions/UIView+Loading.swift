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
    
    func startLoading(shadow: Bool = false) {
        let loadingView = UIView()
        loadingView.frame = self.bounds
        loadingView.tag = loadingViewTag
        
        let activityIndicator = LoadingConvenience.activityIndicator
        activityIndicator.frame = self.bounds
        activityIndicator.startAnimating()
        
        if shadow {
            let shadowView = LoadingConvenience.shadowView
            shadowView.frame = self.bounds
            loadingView.addSubview(shadowView)
        }
        
        loadingView.addSubview(activityIndicator)
        
        DispatchQueue.main.async {
            self.addSubview(loadingView)
        }
    }
    
    func stopLoading() {
        let holderView = self.viewWithTag(loadingViewTag)
        DispatchQueue.main.async {
            holderView?.removeFromSuperview()
        }
    }
    
}

class LoadingConvenience {
    
    static let shared = LoadingConvenience()
    
    private var loadingView: UIView!
    private var window = (UIApplication.shared.delegate as! AppDelegate).window!
    
    static var blurView: UIVisualEffectView {
        
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.alpha = 0.85
        
        return view
    }
    
    static var shadowView: UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0.55
        return view
    }
    
    static var activityIndicator: UIActivityIndicatorView {
        let loading = UIActivityIndicatorView(style: .white)
        loading.color = UIColor.lightGray
        return loading
    }
    
    // MARK: - Life Cycle
    init() {
        setupLoadingView()
    }
    
    // MARK: - Misc
    func enableFullScreenLoading() {
        window.addSubview(loadingView)
    }
    
    func disableFullScreenLoading() {
        loadingView.removeFromSuperview()
    }
    
    private func setupLoadingView() {
        loadingView = UIView(frame: window.bounds)
        loadingView.startLoading()
    }
    
}

