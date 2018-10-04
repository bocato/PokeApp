//
//  RxControllable.swift
//  PokeApp
//
//  Created by Eduardo Bocato on 04/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift


protocol Bindable {
    
    
    
}

protocol RxControllable {
    
    // MARK: Types
    associatedtype ViewModelType
    
    // MARK: Properties
    var disposeBag: DisposeBag { get }
    var viewModel: ViewModelType! { get set }
    
    // MARK: Instantiation
//    static func newInstance(fromStoryboardNamed: String, viewModel: ViewModelType) -> Self
    
    // MARK: Binding
    func bindViewModel()
    
}
extension RxControllable {
    
    static func newInstance(fromStoryboard storyboard: Storyboards, viewModel: ViewModelType) -> Self {
        var viewController = UIViewController.instantiate(viewControllerOfType: self, storyboardName: storyboard.name) 
        viewController.viewModel = viewModel
        return viewController
    }
    
}
