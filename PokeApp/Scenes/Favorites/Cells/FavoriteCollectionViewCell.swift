//
//  FavoriteCollectionViewCell.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import RxSwift

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var pokemonNumberLabel: UILabel!
    @IBOutlet private weak var pokemonNameLabel: UILabel!
    
    // MARK: - Properties
    private(set) var disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Configuration
    func configure(with cellModel: FavoriteCollectionViewCellModel) {
        pokemonNumberLabel.text = cellModel.pokemonName
        pokemonNameLabel.text = cellModel.pokemonNumberString
        bindImageView(to: cellModel)
    }
    
    func bindImageView(to cellModel: FavoriteCollectionViewCellModel) {
        
        cellModel.state
            .asObservable()
            .subscribe(onNext: { (state) in
                switch state {
                case .loading(let isLoading):
                    self.showImageViewLoader(isLoading)
                default: return
                }
            }).disposed(by: disposeBag)
        
        cellModel.pokemonImage
            .asObservable()
            .subscribe(onNext: { (image) in
                self.pokemonImageView.image = image
            }).disposed(by: disposeBag)
        
    }
    
    // MARK: - Helpers
    private func showImageViewLoader(_ show: Bool) {
        if show {
            pokemonImageView.startLoading(backgroundColor: UIColor.white, activityIndicatorColor: UIColor.lightGray)
        } else {
            pokemonImageView.stopLoading()
        }
    }
    
}

