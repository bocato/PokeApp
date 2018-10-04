//
//  RxControllable.swift
//  PokeApp
//
//  Created by Eduardo Bocato on 04/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift

protocol RxControllable {
    
    // MARK: Types
    associatedtype ViewModelType
    
    // MARK: Properties
    var disposeBag: DisposeBag { get }
    var viewModel: ViewModelType! { get set }
    
    // MARK: Binding
    func bindAll()
    
}
extension RxControllable {
    
    // MARK: Instantiation
    static func newInstance(fromStoryboard storyboard: Storyboards, viewModel: ViewModelType) -> Self {
        var viewController = UIViewController.instantiate(viewControllerOfType: self, storyboardName: storyboard.name) 
        viewController.viewModel = viewModel
        return viewController
    }
    
}
