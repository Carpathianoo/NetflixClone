//
//  HomeViewModel.swift
//  NetflixClone
//
//  Created by Adlan Nourindiaz on 13/04/23.
//

import Foundation

protocol HomeVMProtocol {
    var bindItemData: (([Item]?) -> ())? { get set }
    var bindGenreData: (([Genre]?) -> ())? { get set }
    func fetchPopularMoviesData()
    func fetchGenresData()
}

class HomeViewModel: HomeVMProtocol {
    
    private var apiServiceProtocol: APIServiceProtocol?
    private var callingCount = 1
    private var currentPage = 1
    
    var bindItemData: (([Item]?) -> ())?
    var bindGenreData: (([Genre]?) -> ())?
    
    init() {
        self.apiServiceProtocol = APIService()
    }
    
    
    func fetchGenresData() {
        let url = APIConfig.baseUrl + "/genre/movie/list" + "?api_key=\(APIConfig.API_KEY)"
        
        self.apiServiceProtocol?.callApi(with: url, model: GenreApiResponse.self, completion: { result in
            switch result {
                
            case .success(let success):
                self.bindGenreData?(success.genres)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func fetchPopularMoviesData() {
        let url = APIConfig.baseUrl + "/movie/popular" + "?api_key=\(APIConfig.API_KEY)" + "&page=\(currentPage)"
        
        
        self.apiServiceProtocol?.callApi(with: url, model: ApiResponse.self, completion: { result in
//            print("result data: \(result)")
            switch result {
            case .success(let success):
                self.bindItemData?(success.results)
                self.currentPage = self.currentPage + 1
                print("current page: \(self.currentPage)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    
    
    
    
}
