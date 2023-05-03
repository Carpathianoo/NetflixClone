//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Adlan Nourindiaz on 06/04/23.
//

import UIKit

protocol HomeViewControllerDelegate {
    func moveToDetailPage(model: Item?, fromTableHeader: Bool, isPlayOnly: Bool)
    func moveToViewAllPage(section: Int)
    func moveToGenreMoviesPage(genre: Genre?)
}

enum TableSections: Int {
    case genres = 0
    case popularMovies = 1
    case topRatedMovies = 3
}

class HomeViewController: UIViewController {
    
    private let homeVM = HomeViewModel()
    private var popularMovies: [Item]?
    private var TopRatedMovies: [Item]?
    private var genres: [Genre]?
    private var headerMovie: HeroHeaderView?
    
    var sections = ["Genres", "Popular Movies", "Popular TV Shows", "Top Rated Movies", "Top Rated TV Shows"]

    private lazy var homeTable: UITableView = {
        let movieTable = UITableView(frame: .zero, style: .grouped)
        movieTable.translatesAutoresizingMaskIntoConstraints = false
        movieTable.register(SectionCellHeader.self, forHeaderFooterViewReuseIdentifier: SectionCellHeader.identifier)
        movieTable.register(UINib(nibName: "MainTableCell", bundle: nil), forCellReuseIdentifier: MainTableCell.identifier)
        movieTable.register(GenresTableCell.self, forCellReuseIdentifier: GenresTableCell.identifier)
        return movieTable
    }()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTable()
        setupTableHeader()
        callApi()
    }
    
    private func setupNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.hidesBarsOnSwipe = true
        
        let leftNavigationBarItems = LeftNavBarItems()
        leftNavigationBarItems.setupLeftNavBarItems()
        
        let rightNavigationBarItems = RightNavBarItems()
        rightNavigationBarItems.setupBarItem()
        
        navigationItem.setLeftBarButton(leftNavigationBarItems, animated: true)
        navigationItem.setRightBarButton(rightNavigationBarItems, animated: true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
           return true
       }
    
    private func setupTable() {
        view.addSubview(homeTable)
        
        homeTable.backgroundColor = .systemBackground
        homeTable.separatorStyle = .none
        homeTable.tableFooterView = UIView(frame: CGRect.zero)
        homeTable.sectionFooterHeight = 0.0
        
        NSLayoutConstraint.activate([
            homeTable.topAnchor.constraint(equalTo: view.topAnchor),
            homeTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
       
        
        homeTable.delegate = self
        homeTable.dataSource = self

    }
    
    private func setupTableHeader() {
        self.headerMovie = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))

        homeTable.tableHeaderView = self.headerMovie
        headerMovie?.homeVCDelegate = self
    }
    
    private func callApi() {
        self.homeVM.fetchPopularMoviesData(currentPage: 1)
        self.homeVM.bindItemData = { movieModel in
            if let model = movieModel {
                let selectedTitle = model.randomElement()
                guard let selectedTitle = selectedTitle else { return }
                self.headerMovie?.configure(with: selectedTitle)
                
                self.popularMovies = model
                DispatchQueue.main.async { [weak self] in
                    if self?.popularMovies != nil {
                        self?.homeTable.reloadData()
                    }
                }
            }
            
        }
        
        self.homeVM.fetchGenresData()
        self.homeVM.bindGenreData = { genreModel in
            if let model = genreModel {
                self.genres = model
                DispatchQueue.main.async { [weak self] in
                    if self?.genres != nil {
                        self?.homeTable.reloadData()
                    }
                }
            }
        }
        
        self.homeVM.fetchTopRatedMoviesData(currentPage: 1)
        self.homeVM.bindtopRatedMoviesData = { topRatedMovies in
            if let model = topRatedMovies {
                self.TopRatedMovies = model
                DispatchQueue.main.async { [weak self] in
                    if self?.TopRatedMovies != nil {
                        self?.homeTable.reloadData()
                    }
                }
            }

        }
    }
    
        
}

extension HomeViewController: HomeViewControllerDelegate {
    
    func moveToDetailPage(model: Item?, fromTableHeader: Bool, isPlayOnly: Bool) {
        let vc = MovieDetailViewController()
        vc.configure(model: model, fromTableHeader: fromTableHeader, isPlayOnly: isPlayOnly)
        
        if fromTableHeader == true {
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            self.present(vc, animated: true, completion: nil)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func moveToViewAllPage(section: Int) {
        let vc = ViewAllViewController()
        vc.configure(section: section)
        vc.homeVCDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = false

    }
    
    func moveToGenreMoviesPage(genre: Genre?) {
        let vc = GenreMoviesViewController()
        vc.configure(genre: genre)
        vc.homeVCDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = false
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sections = TableSections(rawValue: indexPath.section)
        
        switch sections {
        case .genres:
            return 150
        case .popularMovies:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = homeTable.dequeueReusableHeaderFooterView(withIdentifier: SectionCellHeader.identifier) as? SectionCellHeader
        header?.addSubviews()
        header?.configure(title: sections[section], index: section)
        header?.homeVCDelegate = self

        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sections = TableSections(rawValue: indexPath.section)
        
        switch sections {
        case .genres:
            guard let genre = homeTable.dequeueReusableCell(withIdentifier: GenresTableCell.identifier, for: indexPath) as? GenresTableCell else { return UITableViewCell() }
            genre.setupCollectionView()
            genre.configure(genreModel: genres)
            genre.homeVCDelegate = self
            return genre
        case .popularMovies:
            guard let cell = homeTable.dequeueReusableCell(withIdentifier: MainTableCell.identifier, for: indexPath) as? MainTableCell else { return UITableViewCell() }
            cell.setupCollectionView()
            cell.configure(modelData: popularMovies)
            cell.homeVCDelegate = self
            return cell
            
        case .topRatedMovies:
            guard let cell = homeTable.dequeueReusableCell(withIdentifier: MainTableCell.identifier, for: indexPath) as? MainTableCell else { return UITableViewCell() }
            cell.setupCollectionView()
            cell.configure(modelData: TopRatedMovies)
            cell.homeVCDelegate = self
            return cell
        default:
            return UITableViewCell()
        }
    
    }
}
