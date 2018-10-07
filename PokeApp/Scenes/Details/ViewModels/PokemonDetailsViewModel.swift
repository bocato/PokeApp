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
@objc protocol PokemonDetailsViewControllerActionsDelegate : AnyObject {
    func didAddFavorite()
    func didRemoveFavorite()
}

class PokemonDetailsViewModel {
    
    // MARK: - Constants
    private struct Constants {
        static let addToFavoritesButtonText = "Add to Favorites"
        static let removeFromFavoritesButtonText = "Remove from Favorites"
    }
    
    // MARK: - Dependencies
    struct DataSources {
        let pokemonService: PokemonServiceProtocol
        let favoritesManager: FavoritesManager
    }
    
    private(set) var disposeBag = DisposeBag()
    private let dataSources: DataSources
    weak var actionsDelegate: PokemonDetailsViewControllerActionsDelegate?
    
    // MARK: - Properties
    private var pokemonId: Int
    private(set) var pokemonData: Pokemon?
    private var isThisPokemonAFavorite: Bool {
        guard let pokemonData = pokemonData else {
            return false
        }
        return dataSources.favoritesManager.isFavorite(pokemon: pokemonData)
    }
    
    // MARK: - Rx Properties
    private(set) var isLoadingPokemonImage = BehaviorRelay<Bool>(value: true)
    private(set) var isLoadingPokemonData = PublishSubject<Bool>()
    private(set) var viewState = PublishSubject<CommonViewModelState>()
    private(set) var favoriteButtonText = BehaviorRelay<String>(value: "Add to Favorites")
    private(set) var pokemonImage = BehaviorRelay<UIImage?>(value: nil)
    private(set) var pokemonNumber = BehaviorRelay<String?>(value: nil)
    private(set) var pokemonName = BehaviorRelay<String?>(value: nil)
    private(set) var pokemonAbilities = BehaviorRelay<[String]>(value: [])
    private(set) var pokemonStats = BehaviorRelay<[String]>(value: [])
    private(set) var pokemonMoves = BehaviorRelay<[String]>(value: [])

    // MARK: - Initialization
    required init(pokemonId: Int, dataSources: DataSources, actionsDelegate: PokemonDetailsViewControllerActionsDelegate) {
        self.pokemonId = pokemonId
        self.dataSources = dataSources
        self.actionsDelegate = actionsDelegate
    }
    
    convenience init(pokemonData: Pokemon, dataSources: DataSources, actionsDelegate: PokemonDetailsViewControllerActionsDelegate) {
        self.init(pokemonId: pokemonData.id!, dataSources: dataSources, actionsDelegate: actionsDelegate)
        self.pokemonData = pokemonData
    }
    
    // MARK: - API Calls
    func loadPokemonData() {
        
        isLoadingPokemonData.onNext(true)
        
        dataSources.pokemonService.getDetailsForPokemon(withId: pokemonId).single()
            .subscribe(onNext: { [weak self] (pokemonData) in
                
                guard let `self` = self else { return }
                
                guard let pokemonData = pokemonData,
                    let imageURL = pokemonData.imageURL,
                    let number = pokemonData.id,
                    let name = pokemonData.name,
                    let abilities = pokemonData.abilities,
                    let stats = pokemonData.stats,
                    let moves = pokemonData.moves else {
                        
                        self.isLoadingPokemonData.onNext(false)
                        
                        let error = ErrorFactory.buildNetworkError(with: .unexpected)
                        self.viewState.onNext(.error(error))
                        
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
                
                self.isLoadingPokemonData.onNext(false)
                
            }, onError: { [weak self] (error) in
                    
                    let networkError = error as! NetworkError
                    self?.viewState.onNext(.error(networkError.requestError))
                    self?.isLoadingPokemonData.onNext(false)
                    
            })
            .disposed(by: disposeBag)
    }
    
    private func getfavoritesButtonText() -> String {
        return isThisPokemonAFavorite ? Constants.removeFromFavoritesButtonText : Constants.addToFavoritesButtonText
    }
    
    private func downloadImage(from itemURL: String?) {
        guard let urlString = itemURL, let imageURL = URL(string: urlString) else {
            pokemonImage.accept(UIImage(named: "open_pokeball")!)
            isLoadingPokemonImage.accept(false)
            return
        }
        DispatchQueue.main.async {
            let pokemonImageViewHolder = UIImageView()
            pokemonImageViewHolder.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil) { [weak self] (image, error, cache, url) in
                guard let `self` = self else { return }
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
    
    // MARK: - Actions
    func actOnFavoritesButtonTouch() {
        guard let pokemonData = self.pokemonData else { return }
        if isThisPokemonAFavorite {
            dataSources.favoritesManager.remove(pokemon: pokemonData)
            actionsDelegate?.didRemoveFavorite()
        } else {
            dataSources.favoritesManager.add(pokemon: pokemonData)
            actionsDelegate?.didAddFavorite()
        }
        favoriteButtonText.accept(getfavoritesButtonText())
    }
    
}
