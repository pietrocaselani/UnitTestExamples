import ExampleFramework
import RxSwift
import UIKit

final class MoviesViewController: UIViewController, MoviesView {
    private let disposeBag = DisposeBag()
    var viewModel: MoviesViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = self.viewModel else {
            Swift.fatalError("View loaded without viewModel")
        }

        viewModel.observeViewState()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewState in
                self?.handle(viewState)
            }).disposed(by: disposeBag)

        viewModel.viewDidLoad()
    }

    private func handle(_ viewState: MovieViewState) {
        switch viewState {
        case .empty:
            print("No movies to show")
        case .error(let error):
            print("Ops... \(error.localizedDescription)")
        case .loading:
            print("Please wait...")
        case .showingMovies(let titles):
            let titlesText = titles.joined(separator: "\n")
            print("Movies: \(titlesText)")
        }
    }
}
