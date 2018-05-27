//
//  HomeViewController.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 20/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeViewController: UIViewController {
    
    // MARK: - Constants
    private struct ViewConstants {
        static let defaultTableviewCellHeight: CGFloat = 100.0
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: HomeViewModel!
    let disposeBag = DisposeBag()
    
    // MARK: - ViewElements
    fileprivate var refreshControl: UIRefreshControl = ({
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.lightGray
        // refreshControl.addTarget(self, action: #selector(SearchViewController.reloadViewData), for: .valueChanged) // TODO: Implement on viewModel
        return refreshControl
    })()
    
    // MARK: - Instantiation
//    private(set) var viewModel: HomeViewModel // i can do this only if i use xibs
//    init(viewModel: HomeViewModel) { // i can do this only if i use xibs
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    let viewController = HomeViewController(viewModel: HomeViewModel()) // i can do this only if i use xibs
  
    class func newInstanceFromStoryboard(viewModel: HomeViewModel) ->  HomeViewController {
        let controller = HomeViewController.instantiate(viewControllerOfType: HomeViewController.self, storyboardName: "Home")
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    deinit {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
    
}

// MARK: - Binding
private extension HomeViewController {
    
    func bindAll() {
        bindViewModel()
        bindTableView()
        bindRefreshControl()
    }
    
    func bindViewModel() {
        
        viewModel.loadPokemons()
        
        viewModel.viewState
            .asObservable()
            .subscribe(onNext: { state in
                switch state {
                case .loading(let isLoading):
                    if isLoading {
                        self.tableView.startLoading(backgroundColor: UIColor.white, activityIndicatorViewStyle: .whiteLarge, activityIndicatorColor: UIColor.lightGray)
                    } else {
                        self.tableView.stopLoading()
                    }
                case .error(let networkError):
                    let errorMessage = networkError.message ?? NetworkErrorMessage.unexpected.rawValue
                    AlertHelper.showAlert(in: self, withTitle: "Error", message: errorMessage, preferredStyle: .actionSheet)
                case .empty:
                    self.tableView.isHidden = true
//                    self.
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindTableView()  {
        
        viewModel.pokemonCellModels
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: PokemonTableViewCell.identifier, cellType: PokemonTableViewCell.self)) { (rowIndex, pokemonCellModel, cell) in
                cell.configure(with: pokemonCellModel)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(PokemonTableViewCellModel.self)
            .subscribe(onNext: { selectedPokemonCellModel in
                debugPrint("selectedPokemonCellModel = \(selectedPokemonCellModel)")
                
//                // TODO: Do this with Coordinator/Router/Viewmodel... remove logic from here
//                if let id = selectedPokemonCellModel.pokemonListItem.id {
//                    let pokemonDetailsViewController = PokemonDetailsViewController.instantiateNew(withPokemonId: id)
//                    self.navigationController?.pushViewController(pokemonDetailsViewController, animated: true)
//                }
                
                // calling on coordinator
                if let id = selectedPokemonCellModel.pokemonListItem.id {
                    self.viewModel.coordinator.showItemDetailsForPokemonId(pokemonId: id)
                }
                
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindRefreshControl() {
        self.refreshControl.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { _ in
                self.viewModel.loadPokemons()
            })
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewConstants.defaultTableviewCellHeight
    }
    
}
