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
    var viewModel: FavoritesViewModel!
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    // MARK: - Initialization
    class func newInstanceFromStoryboard(viewModel: FavoritesViewModel) ->  FavoritesViewController {
        let controller = FavoritesViewController.instantiate(viewControllerOfType: FavoritesViewController.self, storyboardName: "Favorites")
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites() // TODO: Remove this when persistence is done...
    }
    
}

// MARK: - Binding
private extension FavoritesViewController {
    
    func bindAll() {
        bindViewModel()
        bindCollectionView()
    }
    
    func bindViewModel() {
        
        viewModel.loadFavorites()
        
        viewModel.viewState
            .asObservable()
            .subscribe(onNext: { state in
                switch state {
                case .loading(let isLoading):
                    if isLoading {
                        self.collectionView.startLoading(backgroundColor: UIColor.white, activityIndicatorViewStyle: .whiteLarge, activityIndicatorColor: UIColor.lightGray)
                    } else {
                        self.collectionView.stopLoading()
                    }
                case .error(let networkError): // TODO: CHANGE TO PERSISTENCE ERROR
                    let errorMessage = networkError.message ?? NetworkErrorMessage.unexpected.rawValue
                    AlertHelper.showAlert(in: self, withTitle: "Error", message: errorMessage, preferredStyle: .actionSheet)
                case .empty:
//                    self.collectionView.isHidden = true
                    debugPrint("empty")
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindCollectionView() {
        
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
