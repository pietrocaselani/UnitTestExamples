import ExampleFramework
import RxSwift

final class MoviesMocks {
    private init() {}

    final class SuccessRespository: MoviesRepository {
        private let subject: BehaviorSubject<[String]>
//        private let titles: [String]

        init(titles: [String] = ["Deadpool 2", "Tomb Raider", "Game Night"]) {
            subject = BehaviorSubject(value: titles)
//            self.titles = titles
        }

        func fetchMovies() -> Observable<[String]> {
            return subject
        }

        func emit(new movies: [String]) {
            subject.onNext(movies)
        }
    }

    final class FailureRepository: MoviesRepository {
        private let error: Error

        init(error: Error) {
            self.error = error
        }

        func fetchMovies() -> Observable<[String]> {
            return Observable.error(error)
        }
    }
}
