//
//  SceneDelegate.swift
//  Pokedex
//
//  Created by Pedro Henrique Calado on 14/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigation: UINavigationController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let client = AlamofireHTTPClient()
        let listLoader = RemotePokemonListLoader(client: client)
        let detailsLoader = RemotePokemonDetailsLoader(client: client)
        let viewModel = PokemonListViewModel(coordinator: self, listLoader: listLoader, detailsLoader: detailsLoader)
        let vc = PokemonListViewController(viewModel: viewModel)
        navigation = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate: RootCoordinator {
    func navigateToDetails(with pokemon: PokemonListItem) {
        let client = AlamofireHTTPClient()
        let detailsLoader = RemotePokemonDetailsLoader(client: client)
        let speciesLoader = RemotePokemonSpeciesLoader(client: client)
        let viewModel = PokemonDetailsViewModel(pokemonListItem: pokemon, coordinator: self, detailsLoader: detailsLoader, speciesLoader: speciesLoader)
        let viewController = PokemonDetailsViewController(viewModel: viewModel)
        navigation?.pushViewController(viewController, animated: false)
    }
    
    func navigateToEquivalentPokemons(with type: PokemonDetailsType) {
        let client = AlamofireHTTPClient()
        let loader = RemoteEquivalentPokemonsLoader(client: client)
        let viewModel = EquivalentPokemonsViewModel(type: type, listLoader: loader)
        let viewController = EquivalentPokemonViewController(viewModel: viewModel)
        navigation?.pushViewController(viewController, animated: false)
    }
    
    func showAbilityDescription(_ id: Int) {
        let client = AlamofireHTTPClient()
        let loader = RemoteAbilitiesLoader(client: client)
        let viewModel = AbilityDescriptionViewModel(id: id, abilitiesLoader: loader)
        let abilityDescriptionVC = AbilityDescriptionViewController(abilityId: id, viewModel: viewModel)
        if let sheet = abilityDescriptionVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        guard let vc = navigation?.viewControllers.last else { return }
        
        vc.present(abilityDescriptionVC, animated: true)
    }
}
