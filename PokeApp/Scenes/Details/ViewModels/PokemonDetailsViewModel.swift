//
//  PokemonDetailsViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 22/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Actions
protocol PokemonDetailsViewControllerActionsDelegate : class {
    func didAddFavorite(pokemon: Pokemon) // configure didremove
    func didRemoveFavorite(pokemon: Pokemon)
}

// MARK: - ViewState
enum PokemonDetailsViewState {
    case loading(Bool)
    case error(SerializedNetworkError?)
}

class PokemonDetailsViewModel {
    
    // MARK: - Constants
    private struct Constants {
        static let addToFavoritesButtonText = "Add to Favorites"
        static let removeFromFavoritesButtonText = "Remove from Favorites"
    }
    
    // MARK: - Dependencies
    private var services: PokemonServiceProtocol
    weak var actionsDelegate: PokemonDetailsViewControllerActionsDelegate?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    private var pokemonId: Int
    private(set) var pokemonData: Pokemon?
    private var isThisPokemonAFavorite: Bool {
        guard let pokemonData = pokemonData else {
            return false
        }
        return FavoritesManager.shared.isFavorite(pokemon: pokemonData)
    }
    
    // MARK: - Rx Properties
    private(set) var isLoadingPokemonImage = BehaviorRelay<Bool>(value: true)
    private(set) var viewState = BehaviorRelay<PokemonDetailsViewState>(value: .loading(true))
    private(set) var favoriteButtonText = BehaviorRelay<String>(value: "Add to Favorites")
    private(set) var pokemonImage = BehaviorRelay<UIImage?>(value: nil)
    private(set) var pokemonNumber = BehaviorRelay<String?>(value: nil)
    private(set) var pokemonName = BehaviorRelay<String?>(value: nil)
    private(set) var pokemonAbilities = BehaviorRelay<[String]>(value: [])
    private(set) var pokemonStats = BehaviorRelay<[String]>(value: [])
    private(set) var pokemonMoves = BehaviorRelay<[String]>(value: [])
    
    // MARK: - Action Closures
    var favoriteButtonTouchUpInsideActionClosure: (()->())? // TODO: Change to get only? Can i do this?

    // MARK: - Initialization
    required init(pokemonId: Int, services: PokemonServiceProtocol, actionsDelegate: PokemonDetailsViewControllerActionsDelegate) {
        self.pokemonId = pokemonId
        self.services = services
        self.actionsDelegate = actionsDelegate
        setupActionClosures()
    }
    
    // MARK: - API Calls
    func loadPokemonData() {
        viewState.accept(.loading(true))
        services.getDetailsForPokemon(withId: pokemonId)
            .subscribe(onNext: { pokemonData in
                
                guard let pokemonData = pokemonData,
                    let imageURL = pokemonData.imageURL,
                    let number = pokemonData.id,
                    let name = pokemonData.name,
                    let abilities = pokemonData.abilities,
                    let stats = pokemonData.stats,
                    let moves = pokemonData.moves else {
                        let error = ErrorFactory.buildNetworkError(with: .unexpected)
                        self.viewState.accept(.error(error))
                    return
                }
                
                self.pokemonData = pokemonData
                
                self.favoriteButtonText.accept(self.getfavoritesButtonText())
                self.downloadImage(from: imageURL)
                self.pokemonNumber.accept("#\(number)")
                self.pokemonName.accept(name.capitalizingFirstLetter())
                self.pokemonAbilities.accept(self.extractAbilityNames(from: abilities))
                self.pokemonStats.accept(self.extractStatStrings(from: stats))
                self.pokemonMoves.accept(self.extractMoveStrings(from: moves))
                
            }, onError: { (error) in
                let networkError = error as! NetworkError
                self.viewState.accept(.error(networkError.requestError))
            }, onCompleted: {
                self.viewState.accept(.loading(false))
            })
            .disposed(by: disposeBag)
    }
    
    private func getfavoritesButtonText() -> String { // TODO: Review when CoreData is implemented
        return isThisPokemonAFavorite ? Constants.removeFromFavoritesButtonText : Constants.addToFavoritesButtonText
    }
    
    private func downloadImage(from itemURL: String?) {
        guard let urlString = itemURL, let imageURL = URL(string: urlString) else {
            pokemonImage.accept(UIImage.fromResource(withName: .openPokeball))
            self.isLoadingPokemonImage.accept(false)
            return
        }
        DispatchQueue.main.async {
            let pokemonImageViewHolder = UIImageView()
            pokemonImageViewHolder.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil) { (image, error, cache, url) in
                guard error != nil else {
                    self.pokemonImage.accept(image)
                    self.isLoadingPokemonImage.accept(false)
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
        
        self.favoriteButtonTouchUpInsideActionClosure = {
            guard let pokemonData = self.pokemonData else { return }
            if self.isThisPokemonAFavorite {
                self.actionsDelegate?.didRemoveFavorite(pokemon: pokemonData)
            } else {
                self.actionsDelegate?.didAddFavorite(pokemon: pokemonData)
            }
            self.favoriteButtonText.accept(self.getfavoritesButtonText())
        }
        
    }
}
