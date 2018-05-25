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

class FavoriteCollectionViewCellModel {
    
    // MARK: - Model State
    enum PokemonTableViewCellModelState {
        case loading(Bool)
    }
    
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
    var pokemonImage = Variable<UIImage?>(nil)
    var state = Variable<PokemonTableViewCellModelState>(.loading(true))
    
    // MARK: - Initializers
    init(data: Pokemon) {
        pokemonData = data
        downloadImage(from: pokemonData.imageURL)
    }
    
    // MARK: - Configuration
    private func downloadImage(from itemURL: String?) {
        guard let urlString = itemURL, let imageURL = URL(string: urlString) else {
            pokemonImage.value = UIImage.fromResource(withName: .openPokeball)
            self.state.value = .loading(false)
            return
        }
        DispatchQueue.main.async {
            let pokemonImageViewHolder = UIImageView()
            pokemonImageViewHolder.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil) { (image, error, cache, url) in
                guard error != nil else {
                    self.pokemonImage.value = image
                    self.state.value = .loading(false)
                    return
                }
            }
        }
    }
    
}
