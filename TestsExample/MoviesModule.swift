import ExampleFramework
import UIKit

final class MoviesModule {
    private init() {}

    static func setupModule() -> MoviesViewController {
        let repository = MoviesInMemoryRepository()
        let viewModel = MoviesDefaultViewModel(repository: repository)

        let moviesViewController = MoviesViewController(viewModel: viewModel)

        return moviesViewController
    }
}
