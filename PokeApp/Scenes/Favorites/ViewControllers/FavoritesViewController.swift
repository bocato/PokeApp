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

class FavoritesViewController: UIViewController, RxControllable {
    
    // MARK: - Aliases
    typealias ViewModelType = FavoritesViewModel
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Dependencies
    internal var viewModel: FavoritesViewModel!
    internal var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAll()
        viewModel.loadFavorites()
    }
    
}

// MARK: - Binding
extension FavoritesViewController {
    
    internal func bindAll() {
        
        viewModel.favoritesCellModels
            .asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: FavoriteCollectionViewCell.identifier, cellType: FavoriteCollectionViewCell.self)) { (_, favoriteCellModel, cell) in
                cell.configure(with: favoriteCellModel)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(FavoriteCollectionViewCellModel.self)
            .bind(onNext: { selectedFavoriteCellModel in
                self.viewModel.showItemDetailsForSelectedFavoriteCellModel(favoriteCellModel: selectedFavoriteCellModel)
            })
            .disposed(by: disposeBag)
        
        viewModel.viewState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (state) in
                switch state {
                case .empty:
                    self?.collectionView.isHidden = true
                case .loaded:
                    self?.collectionView.isHidden = false
                default: return
                }
            }).disposed(by: disposeBag)
        
    }
    
}

extension FavoritesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        var side = width / 2
        if viewModel.numberFavorites > 1 {
            side = width/2 * 0.95
        }
        return CGSize(width: side, height: side)
    }
    
}
