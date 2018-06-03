import RxSwift

public final class MoviesDefaultViewModel: MoviesViewModel {
    private let viewStateSubject = BehaviorSubject<MovieViewState>(value: .loading)
    private let disposeBag = DisposeBag()
    private let repository: MoviesRepository

    public init(repository: MoviesRepository) {
        self.repository = repository
    }

    public func viewDidLoad() {
        repository.fetchMovies()
            .map { titles -> MovieViewState in
                return titles.isEmpty ? MovieViewState.empty : MovieViewState.showingMovies(titles: titles)
            }.catchError { error -> Observable<MovieViewState> in
                return Observable.just(MovieViewState.error(error: error))
            }.subscribe(onNext: { [weak self] viewState in
                self?.viewStateSubject.onNext(viewState)
            }).disposed(by: disposeBag)
    }

    public func observeViewState() -> Observable<MovieViewState> {
        return viewStateSubject.distinctUntilChanged()
    }
}
