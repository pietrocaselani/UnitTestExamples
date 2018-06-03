import ExampleFramework
import UIKit

final class MoviesModule {
    private init() {}

    static func setupModule() -> MoviesViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let moviesViewController = storyboard.instantiateInitialViewController() as? MoviesViewController else {
            Swift.fatalError("initial view controller should be an instance of MoviesViewController")
        }

        let repository = MoviesInMemoryRepository()
        let viewModel = MoviesDefaultViewModel(repository: repository)

        moviesViewController.viewModel = viewModel

        return moviesViewController
    }
}
