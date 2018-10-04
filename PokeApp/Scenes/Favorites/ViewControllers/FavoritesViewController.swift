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
    internal(set) var viewModel: FavoritesViewModel!
    internal(set) var disposeBag = DisposeBag()
    
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
            .bind(to: collectionView.rx.items(cellIdentifier: FavoriteCollectionViewCell.identifier, cellType: FavoriteCollectionViewCell.self)) { (rowIndex, favoriteCellModel, cell) in
                cell.configure(with: favoriteCellModel)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(FavoriteCollectionViewCellModel.self)
            .bind(onNext: { selectedFavoriteCellModel in
                self.viewModel.showItemDetailsForSelectedFavoriteCellModel(favoriteCellModel: selectedFavoriteCellModel)
            })
            .disposed(by: disposeBag)
    }
    
}

extension FavoritesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = width * 0.9
        let cellHeight = width
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
