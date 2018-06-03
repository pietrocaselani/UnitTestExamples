import RxSwift

public final class MoviesInMemoryRepository: MoviesRepository {
    public init() {}

    public func fetchMovies() -> Observable<[String]> {
        let movies = ["Deadpool 2", "Game Night", "Tomb Raider"]
        return Observable.just(movies)
    }
}
