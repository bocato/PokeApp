//
//  BaseRXViewController.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 26/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import RxSwift
import UIKit

class BaseRXViewController<T>: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private(set) var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        configure(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: T) {}
    
}
