//
//  PokemonTableViewCellModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 21/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

// MARK: - PokemonTableViewCellModel Implementation
class PokemonTableViewCellModel {
    
    // MARK: - Properties
    var pokemonListItem: PokemonListResult!
    var pokemonName: String {
        guard let name = pokemonListItem.name else {
            return ""
        }
        return name.capitalizingFirstLetter()
    }
    var pokemonNumberString: String {
        guard let id = pokemonListItem.id else {
            return ""
        }
        return "#\(id): "
    }
    var pokemonImage = BehaviorRelay<UIImage?>(value: nil)
    var state = BehaviorRelay<CommonViewModelState>(value: .loading(true))
    
    // MARK: - Initializers
    init(listItem: PokemonListResult) {
        pokemonListItem = listItem
        downloadImage(from: listItem.imageURL)
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
