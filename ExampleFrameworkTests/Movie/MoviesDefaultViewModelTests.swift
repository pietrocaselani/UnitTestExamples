import RxSwift
import XCTest

@testable import ExampleFramework

final class MoviesDefaultViewModelTests: XCTestCase {
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil

        super.tearDown()
    }

    func testMoviesDefaultViewModel_viewState_shouldAlwaysStartsWithLoading() {
        let repository = MoviesMocks.SuccessRespository()
        let viewModel = MoviesDefaultViewModel(repository: repository)

        var viewStates = [MovieViewState]()
        viewModel.observeViewState().subscribe(onNext: { viewState in
            viewStates.append(viewState)
        }).disposed(by: disposeBag)

        viewModel.viewDidLoad()

        let expectedViewState = MovieViewState.loading

        guard let firstViewState = viewStates.first else {
            XCTFail("Should contain at least one result")
            return
        }

        XCTAssertEqual(firstViewState, expectedViewState)
    }

    func testMoviesDefaultViewModel_cantEmitSameViewState() {
        let emptyMovies = [String]()

        let repository = MoviesMocks.SuccessRespository(titles: emptyMovies)
        let viewModel = MoviesDefaultViewModel(repository: repository)

        var viewStates = [MovieViewState]()
        viewModel.observeViewState().subscribe(onNext: { viewState in
            viewStates.append(viewState)
        }).disposed(by: disposeBag)

        viewModel.viewDidLoad()

        repository.emit(new: emptyMovies)

        let expectedStates = [MovieViewState.loading, MovieViewState.empty]
        XCTAssertEqual(viewStates, expectedStates)
    }

    func testMoviesDefaultViewModel_viewStateShouldBeErrorWhenRepositoryEmitsError() {
        let errorMessage = "There is no internet connection"
        let error = NSError(domain: "example", code: 100, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        let repository = MoviesMocks.FailureRepository(error: error)
        let viewModel = MoviesDefaultViewModel(repository: repository)

        var viewStates = [MovieViewState]()
        viewModel.observeViewState().subscribe(onNext: { viewState in
            viewStates.append(viewState)
        }).disposed(by: disposeBag)

        viewModel.viewDidLoad()

        let expectedStates = [MovieViewState.loading,
                              MovieViewState.error(error: error)]

        XCTAssertEqual(viewStates, expectedStates)
    }

    func testMoviesDefaultViewModel_viewStateShouldBeShowingMoviesWhenRepositoryEmitsMovies() {
        let titles = ["Deadpool 2", "Tomb Raider"]
        let repository = MoviesMocks.SuccessRespository(titles: titles)
        let viewModel = MoviesDefaultViewModel(repository: repository)

        var viewStates = [MovieViewState]()
        viewModel.observeViewState().subscribe(onNext: { viewState in
            viewStates.append(viewState)
        }).disposed(by: disposeBag)

        viewModel.viewDidLoad()

        let expectedStates = [MovieViewState.loading, MovieViewState.showingMovies(titles: titles)]
        XCTAssertEqual(viewStates, expectedStates)
    }
}
