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

class PokemonTableViewCellModel {
    
    // MARK: - Dependencies
    private let imageDownloader: ImageDownloaderProtocol
    
    // MARK: - Properties
    private(set) var pokemonListItem: PokemonListResult!
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
    let pokemonImage = BehaviorRelay<UIImage?>(value: nil)
    let state = BehaviorRelay<CommonViewModelState>(value: .loading(true))
    
    // MARK: - Initializers
    init(listItem: PokemonListResult, imageDownloader: ImageDownloaderProtocol) {
        pokemonListItem = listItem
        self.imageDownloader = imageDownloader
        downloadImage(from: listItem.imageURL)
    }
    
    // MARK: - Configuration
    private func downloadImage(from itemURL: String?) {
        guard let urlString = itemURL, let imageURL = URL(string: urlString) else {
            pokemonImage.accept(UIImage(named: "open_pokeball")!)
            state.accept(.loading(false))
            return
        }
        DispatchQueue.main.async {
            self.imageDownloader.download(with: imageURL, completionHandler: { (image, error) in
                guard error != nil else {
                    self.pokemonImage.accept(image)
                    self.state.accept(.loading(false))
                    return
                }
            })
        }
    }
    
}
