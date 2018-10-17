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
protocol PokemonDetailsViewControllerActionsDelegate : AnyObject {
    func didAddFavorite(_ pokemon: Pokemon)
    func didRemoveFavorite(_ pokemon: Pokemon)
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
        let imageDownloader: ImageDownloaderProtocol
    }
    
    private let disposeBag = DisposeBag()
    private let dataSources: DataSources
    weak var actionsDelegate: PokemonDetailsViewControllerActionsDelegate?
    
    // MARK: - Properties
    private(set) var pokemonId: Int
    private(set) var pokemonData: Pokemon?
    let placeholderImage = UIImage(named: "open_pokeball")!
    
    // MARK: - Rx Properties
    let isLoadingPokemonImage = PublishSubject<Bool>()
    let isLoadingPokemonData = PublishSubject<Bool>()
    let viewState = PublishSubject<CommonViewModelState>()
    let favoriteButtonText = BehaviorRelay<String>(value: "Add to Favorites")
    let pokemonImage = BehaviorRelay<UIImage?>(value: nil)
    let pokemonNumber = BehaviorRelay<String?>(value: nil)
    let pokemonName = BehaviorRelay<String?>(value: nil)
    let pokemonAbilities = BehaviorRelay<[String]>(value: [])
    let pokemonStats = BehaviorRelay<[String]>(value: [])
    let pokemonMoves = BehaviorRelay<[String]>(value: [])

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
                
                guard let self = self else { return }
                
                guard let pokemonData = pokemonData,
                    let imageURLString = pokemonData.imageURL,
                    let imageURL = URL(string: imageURLString),
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
                
                let isFavorite = self.dataSources.favoritesManager.isFavorite(pokemon: pokemonData)
                self.favoriteButtonText.accept(self.getfavoritesButtonText(isFavorite: isFavorite))
                self.downloadImage(from: imageURL)
                self.pokemonNumber.accept("#\(number)")
                self.pokemonName.accept(name.capitalizingFirstLetter())
                self.pokemonAbilities.accept(self.extractAbilityNames(from: abilities))
                self.pokemonStats.accept(self.extractStatStrings(from: stats))
                self.pokemonMoves.accept(self.extractMoveStrings(from: moves))
                
                self.isLoadingPokemonData.onNext(false)
                
            }, onError: { [weak self] (error) in
                    
                    guard let networkError = error as? NetworkError else { return }
                    self?.viewState.onNext(.error(networkError.requestError))
                    self?.isLoadingPokemonData.onNext(false)
                    
            })
            .disposed(by: disposeBag)
    }
    
    private func getfavoritesButtonText(isFavorite: Bool) -> String {
        return isFavorite ? Constants.removeFromFavoritesButtonText : Constants.addToFavoritesButtonText
    }
    
    private func downloadImage(from url: URL) {
        
        isLoadingPokemonImage.onNext(true)
        
        self.dataSources.imageDownloader.download(with: url)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](image) in
                self?.pokemonImage.accept(image)
            }, onError: { [weak self] _ in
                self?.pokemonImage.accept(self?.placeholderImage)
            }, onCompleted: {
                self.isLoadingPokemonImage.onNext(false)
            }).disposed(by: disposeBag)
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
        let isThisPokemonAFavorite = self.dataSources.favoritesManager.isFavorite(pokemon: pokemonData)
        if isThisPokemonAFavorite {
            dataSources.favoritesManager.remove(pokemon: pokemonData)
            actionsDelegate?.didRemoveFavorite(pokemonData)
        } else {
            dataSources.favoritesManager.add(pokemon: pokemonData)
            actionsDelegate?.didAddFavorite(pokemonData)
        }
        favoriteButtonText.accept(getfavoritesButtonText(isFavorite: isThisPokemonAFavorite))
    }
    
}
