//
//  FavoriteCollectionViewCellModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FavoriteCollectionViewCellModel {
    
    // MARK: - Properties
    var pokemonData: Pokemon!
    var pokemonName: String {
        guard let name = pokemonData.name else {
            return ""
        }
        return name.capitalizingFirstLetter()
    }
    var pokemonNumberString: String {
        guard let id = pokemonData.id else {
            return ""
        }
        return "#\(id): "
    }
    var pokemonImage = BehaviorRelay<UIImage?>(value: nil)
    var state = BehaviorRelay<CommonViewModelState>(value: .loading(true))
    
    // MARK: - Initializers
    init(data: Pokemon) {
        pokemonData = data
        downloadImage(from: pokemonData.imageURL)
    }
    
    // MARK: - Configuration
    private func downloadImage(from itemURL: String?) {
        guard let urlString = itemURL, let imageURL = URL(string: urlString) else {
            pokemonImage.accept(UIImage.fromResource(withName: .openPokeball))
            self.state.accept(.loading(false))
            return
        }
        DispatchQueue.main.async {
            let pokemonImageViewHolder = UIImageView()
            pokemonImageViewHolder.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil) { (image, error, cache, url) in
                guard error != nil else {
                    self.pokemonImage.accept(image)
                    self.state.accept(.loading(false))
                    return
                }
            }
        }
    }
    
}
