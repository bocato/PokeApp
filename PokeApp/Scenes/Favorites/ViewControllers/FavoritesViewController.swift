//
//  FavoritesViewController.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritesViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Dependencies
    let viewModel = FavoritesViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAll()
    }

    // MARK: -

}

// MARK: - Binding
private extension FavoritesViewController {
    
    
    func bindAll() {
        bindViewModel()
        bindCollectionView()
    }
    
    func bindViewModel() {
        
    }
    
    func bindCollectionView() {
        
        
        
    }
    
}
