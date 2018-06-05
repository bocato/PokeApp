//
//  PokemonDetailsViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 22/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift

class PokemonDetailsViewModel {
    
    // MARK: - Constants
    private struct Constants {
        static let addToFavoritesButtonText = "Add to Favorites"
        static let removeFromFavoritesButtonText = "Remove from Favorites"
    }
    
    // MARK: - ViewState
    enum PokemonDetailsViewState {
        case loading(Bool)
        case error(NetworkError)
        case noData
    }
    
    // MARK: - Dependencies
    private(set) var services: PokemonServiceProtocol
    var coordinator: Coordinator
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    private var pokemonId: Int
    private var pokemonData: Pokemon?
    private var isThisPokemonAFavorite: Bool {
        guard let pokemonData = pokemonData else {
            return false
        }
        return FavoritesManager.shared.isFavorite(pokemon: pokemonData)
    }
    
    // MARK: - Rx Properties
    var isLoadingPokemonImage = Variable<Bool>(true)
    var viewState = Variable<PokemonDetailsViewState>(.loading(true))
    var favoriteButtonText = Variable<String>("Add to Favorites")
    var pokemonImage = Variable<UIImage?>(nil)
    var pokemonNumber = Variable<String?>(nil)
    var pokemonName = Variable<String?>(nil)
    var pokemonAbilities = Variable<[String]>([])
    var pokemonStats = Variable<[String]>([])
    var pokemonMoves = Variable<[String]>([])
    
    // MARK: - Action Closures
    var favoriteButtonTouchUpInsideActionClosure: (()->())? // TODO: Change to get only? Can i do this?

    // MARK: - Initialization
    required init(pokemonId: Int, services: PokemonServiceProtocol, coordinator: Coordinator) {
        self.pokemonId = pokemonId
        self.services = services
        self.coordinator = coordinator
        setupActionClosures()
    }
    
    // MARK: - API Calls
    func loadPokemonData() {
        viewState.value = .loading(true)
        services.getDetailsForPokemon(withId: pokemonId)
            .subscribe(onNext: { pokemonData in
                
                guard let pokemonData = pokemonData,
                    let imageURL = pokemonData.imageURL,
                    let number = pokemonData.id,
                    let name = pokemonData.name,
                    let abilities = pokemonData.abilities,
                    let stats = pokemonData.stats,
                    let moves = pokemonData.moves else {
                        self.viewState.value = .noData
                    return
                }
                
                self.pokemonData = pokemonData
                
                self.favoriteButtonText.value = self.getfavoritesButtonText()
                self.downloadImage(from: imageURL)
                self.pokemonNumber.value = "#\(number)"
                self.pokemonName.value = name.capitalizingFirstLetter()
                self.pokemonAbilities.value = self.extractAbilityNames(from: abilities)
                self.pokemonStats.value = self.extractStatStrings(from: stats)
                self.pokemonMoves.value = self.extractMoveStrings(from: moves)
                
            }, onError: { (error) in
                let networkError = error as! NetworkError
                self.viewState.value = .error(networkError)
            }, onCompleted: {
                self.viewState.value = .loading(false)
            })
            .disposed(by: disposeBag)
    }
    
    func getfavoritesButtonText() -> String { // TODO: Review when CoreData is implemented
        return isThisPokemonAFavorite ? Constants.removeFromFavoritesButtonText : Constants.addToFavoritesButtonText
    }
    
    private func downloadImage(from itemURL: String?) {
        guard let urlString = itemURL, let imageURL = URL(string: urlString) else {
            pokemonImage.value = UIImage.fromResource(withName: .openPokeball)
            self.isLoadingPokemonImage.value = false
            return
        }
        DispatchQueue.main.async {
            let pokemonImageViewHolder = UIImageView()
            pokemonImageViewHolder.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil) { (image, error, cache, url) in
                guard error != nil else {
                    self.pokemonImage.value = image
                    self.isLoadingPokemonImage.value = false
                    return
                }
            }
        }
    }
    
    private func extractAbilityNames(from abilities: [Ability]) -> [String] {
        var abilityNames = [String]()
        for ability in abilities {
            if let abilityName = ability.ability?.name?.capitalizingFirstLetter() {
                abilityNames.append(abilityName)
            }
        }
        return abilityNames
    }
    
    private func extractStatStrings(from stats: [Stat]) -> [String] {
        var statStrings = [String]()
        for stat in stats {
            if let statName = stat.stat?.name?.capitalizingFirstLetter(), let baseStat = stat.baseStat {
                let statString = "\(statName) (\(baseStat))"
                statStrings.append(statString)
            }
        }
        return statStrings
    }
    
    private func extractMoveStrings(from moves: [Move]) -> [String] {
        var moveStrings = [String]()
        for move in moves {
            if let moveName = move.move?.name?.capitalizingFirstLetter(), let learnedAtLevel = move.versionGroupDetails?.first?.levelLearnedAt {
                let moveString = "\(moveName) - Learned at LVL: \(learnedAtLevel)"
                moveStrings.append(moveString)
            }
        }
        return moveStrings
    }
    
    // MARK: - Action Closures
    func setupActionClosures() {
        
//        self.favoriteButtonTouchUpInsideActionClosure = {
//            guard let pokemonData = self.pokemonData else { return }
//            if self.isThisPokemonAFavorite {
//                FavoritesManager.shared.remove(pokemon: pokemonData)
//            } else {
//                FavoritesManager.shared.add(pokemon: pokemonData)
//            }
//            self.favoriteButtonText.value = self.getfavoritesButtonText()
//        }

        self.favoriteButtonTouchUpInsideActionClosure = {
            guard let pokemonData = self.pokemonData, let pokemonImage = self.pokemonImage.value else { return }
            if self.isThisPokemonAFavorite {
                FavoritesManager.shared.remove(pokemon: pokemonData)
            } else {
                
//                let favoritesService = FavoritesService() // NOT WORKING... need to change some stuff on core Data manager...
//                favoritesService.save(pokemonData, with: pokemonImage)
//                    .asObservable()
//                    .subscribe(onNext: { _ in
//                        debugPrint("Deu bão...")
//                    }, onError: { (error) in
//                        debugPrint("onError: \(error)")
//                    }, onCompleted: {
//                        debugPrint("onCompleted")
//                    })
//                    .disposed(by: self.disposeBag)
                
                FavoritesManager.shared.add(pokemon: pokemonData)
            }
            self.favoriteButtonText.value = self.getfavoritesButtonText()
        }
        
    }
}
