import RxSwift
import RxTest
import XCTest

@testable import ExampleFramework

final class MoviesDefaultViewModelTests: XCTestCase {
    private var scheduler: TestScheduler!
    private var observer: TestableObserver<MovieViewState>!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        scheduler = TestScheduler(initialClock: 0)
        observer = scheduler.createObserver(MovieViewState.self)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        observer = nil
        scheduler = nil

        super.tearDown()
    }

    func testMoviesDefaultViewModel_viewState_shouldAlwaysStartsWithLoading() {
        let repository = MoviesMocks.SuccessRespository()
        let viewModel = MoviesDefaultViewModel(repository: repository)

        viewModel.observeViewState().subscribe(observer).disposed(by: disposeBag)

        viewModel.viewDidLoad()

        scheduler.start()

        let expectedViewState = Recorded.next(0, MovieViewState.loading)

        guard let firstViewState = observer.events.first else {
            XCTFail("Should contain at least one result")
            return
        }

        XCTAssertEqual([firstViewState], [expectedViewState])
    }

    func testMoviesDefaultViewModel_cantEmitSameViewState() {
        let emptyMovies = [String]()

        let repository = MoviesMocks.SuccessRespository(titles: emptyMovies)
        let viewModel = MoviesDefaultViewModel(repository: repository)

        viewModel.observeViewState().subscribe(observer).disposed(by: disposeBag)

        viewModel.viewDidLoad()

        scheduler.start()

        repository.emit(new: emptyMovies)

        let expectedEvents = [Recorded.next(0, MovieViewState.loading),
                              Recorded.next(0, MovieViewState.empty)]

        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testMoviesDefaultViewModel_viewStateShouldBeErrorWhenRepositoryEmitsError() {
        let errorMessage = "There is no internet connection"
        let error = NSError(domain: "example", code: 100, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        let repository = MoviesMocks.FailureRepository(error: error)
        let viewModel = MoviesDefaultViewModel(repository: repository)

        viewModel.observeViewState().subscribe(observer).disposed(by: disposeBag)

        viewModel.viewDidLoad()

        scheduler.start()

        let expectedEvents = [Recorded.next(0, MovieViewState.loading),
                              Recorded.next(0, MovieViewState.error(error: error))]

        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testMoviesDefaultViewModel_viewStateShouldBeShowingMoviesWhenRepositoryEmitsMovies() {
        let titles = ["Deadpool 2", "Tomb Raider"]
        let repository = MoviesMocks.SuccessRespository(titles: titles)
        let viewModel = MoviesDefaultViewModel(repository: repository)

        viewModel.observeViewState().subscribe(observer).disposed(by: disposeBag)

        viewModel.viewDidLoad()

        scheduler.start()

        let expectedEvents = [Recorded.next(0, MovieViewState.loading),
                              Recorded.next(0, MovieViewState.showingMovies(titles: titles))]
        XCTAssertEqual(observer.events, expectedEvents)
    }
}
