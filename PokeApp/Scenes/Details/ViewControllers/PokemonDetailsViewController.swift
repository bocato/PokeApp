//
//  PokemonDetailsViewController.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 22/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import RxSwift

class PokemonDetailsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var abilitiesTableView: UITableView!
    @IBOutlet weak var statsTableView: UITableView!
    @IBOutlet weak var movesTableView: UITableView!
    @IBOutlet weak var favoritesButton: PrimaryButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: -

}
