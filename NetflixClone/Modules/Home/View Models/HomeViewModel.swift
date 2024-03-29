//
//  HomeViewModel.swift
//  NetflixClone
//
//  Created by Adlan Nourindiaz on 13/04/23.
//

import Foundation

protocol HomeVMProtocol {
    var bindPopularMoviesData: (([Item]?) -> ())? { get set }
    var bindGenreData: (([Genre]?) -> ())? { get set }
    var bindtopRatedMoviesData: (([Item]?) -> ())? { get set }
    var bindPopularTvShowsData: (([Item]?) -> ())? { get set }
    var bindTopRatedTvShowsData: (([Item]?) -> ())? { get set }
    func fetchPopularMoviesData(currentPage: Int)
    func fetchAPopularMovieInAGenre(with genreId: Int, completion: @escaping (Item?) -> Void)
    func fetchGenresData()
    func fetchTopRatedMoviesData(currentPage: Int)
    func fetchPopularTvShowsData(currentPage: Int)
    func fetchTopRatedTvShowsData(currentPage: Int)
}

class HomeViewModel: HomeVMProtocol {
    
    
    private var apiServiceProtocol: APIServiceProtocol?
    
    var bindPopularMoviesData: (([Item]?) -> ())?
    var bindGenreData: (([Genre]?) -> ())?
    var bindtopRatedMoviesData: (([Item]?) -> ())?
    var bindPopularTvShowsData: (([Item]?) -> ())?
    var bindTopRatedTvShowsData: (([Item]?) -> ())?
    
    init() {
        self.apiServiceProtocol = APIService()
    }
    
    
    func fetchGenresData() {
        let genreUrl = APIConfig.baseUrl + "/genre/movie/list" + "?api_key=\(APIConfig.API_KEY)"
        
        self.apiServiceProtocol?.callApi(with: genreUrl, model: GenreApiResponse.self, completion: { result in
            switch result {
            case .success(let genreResponse):
                
                var genres = genreResponse.genres
                
                for i in 0..<genres.count {
                    let genreId = genres[i].id
                    self.fetchAPopularMovieInAGenre(with: genreId ?? 0) { firstMovie in
                        if let firstMovie = firstMovie {
                            genres[i].imagePath = firstMovie.posterPath
                            self.bindGenreData?(genres)
                        } else {
                            self.bindGenreData?(nil)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.bindGenreData?(nil)
            }
        })
    }
    
    func fetchAPopularMovieInAGenre(with genreId: Int, completion: @escaping (Item?) -> Void) {
        let popularMoviesGenre = APIConfig.baseUrl + "/movie/popular" + "?api_key=\(APIConfig.API_KEY)" + "&page=1" + "&with_genres=\(genreId)"
        
        self.apiServiceProtocol?.callApi(with: popularMoviesGenre, model: ApiResponse.self, completion: { result in
            switch result {
            case .success(let apiResponse):
                
                if apiResponse.results.count >= 5 {
                    completion(apiResponse.results[4])
                } else {
                    completion(nil)
                }
                    
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        })
    }
    
    func fetchPopularMoviesData(currentPage: Int) {
        let url = APIConfig.baseUrl + "/movie/popular" + "?api_key=\(APIConfig.API_KEY)" + "&page=\(currentPage)"

            self.apiServiceProtocol?.callApi(with: url, model: ApiResponse.self, completion: { result in
                switch result {
                case .success(let success):
                    self.bindPopularMoviesData?(success.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
    func fetchPopularTvShowsData(currentPage: Int) {
        let url = APIConfig.baseUrl + "/tv/popular" + "?api_key=\(APIConfig.API_KEY)" + "&page=\(currentPage)"
        
        self.apiServiceProtocol?.callApi(with: url, model: ApiResponse.self, completion: { result in
            switch result {
            case .success(let success):
                self.bindPopularTvShowsData?(success.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    
    
    func fetchTopRatedMoviesData(currentPage: Int) {
        let url = APIConfig.baseUrl + "/discover/movie" + "?api_key=\(APIConfig.API_KEY)" + "&language=en-US" + "&sort_by=popularity.desc" + "&page=\(currentPage)&vote_average.gte=7.4" + "&release_date.gte=2020" + "&vote_count.gte=1200" + "&release_date.lte=2023"
        
        self.apiServiceProtocol?.callApi(with: url, model: ApiResponse.self, completion: { result in
            switch result {
            case .success(let topMovies):
                self.bindtopRatedMoviesData?(topMovies.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func fetchTopRatedTvShowsData(currentPage: Int) {
        let url = APIConfig.baseUrl + "/discover/tv" + "?api_key=\(APIConfig.API_KEY)" + "&language=en-US" + "&sort_by=popularity.desc" + "&page=\(currentPage)&vote_average.gte=7.4" + "&release_date.gte=2020" + "&vote_count.gte=1200" + "&release_date.lte=2023"
        
        self.apiServiceProtocol?.callApi(with: url, model: ApiResponse.self, completion: { result in
            switch result {
            case .success(let topMovies):
                self.bindTopRatedTvShowsData?(topMovies.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    

}
