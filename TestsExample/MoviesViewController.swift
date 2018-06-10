import ExampleFramework
import RxSwift
import UIKit

final class MoviesViewController: UIViewController, MoviesView {
    private let disposeBag = DisposeBag()
    private let viewModel: MoviesViewModel

    @IBOutlet weak var label: UILabel!

    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
            label.text = "No movies to show"
        case .error(let error):
            label.text = "Ops... \(error.localizedDescription)"
        case .loading:
            label.text = "Please wait..."
        case .showingMovies(let titles):
            let titlesText = titles.joined(separator: "\n")
            label.text = "Movies: \(titlesText)"
        }
    }
}
