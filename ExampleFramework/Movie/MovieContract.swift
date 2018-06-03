import RxSwift

public enum MovieViewState: Hashable {
    case loading
    case error(error: Error)
    case showingMovies(titles: [String])
    case empty

    public var hashValue: Int {
        switch self {
        case .loading:
            return "MovieViewState.loading".hashValue
        case .error(let error):
            return "MovieViewState.error".hashValue ^ error.localizedDescription.hashValue
        case .showingMovies(let titles):
            var hash = "MovieViewState.showingMovies".hashValue
            titles.forEach { hash ^= $0.hashValue }
            return hash
        case .empty:
            return "MovieViewState.empty".hashValue
        }
    }

    public static func == (lhs: MovieViewState, rhs: MovieViewState) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

public protocol MoviesRepository {
    func fetchMovies() -> Observable<[String]>
}

public protocol MoviesViewModel {
    func viewDidLoad()
    func observeViewState() -> Observable<MovieViewState>
}

public protocol MoviesView: class {
    var viewModel: MoviesViewModel? { get set }
}
