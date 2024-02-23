//
//  MovieSearchViewController.swift
//  MovieApp
//
//  Created by Nurşah Ari on 17.02.2024.
//

import UIKit
import Combine

class MovieSearchViewController: UIViewController {
    
    private lazy var tableView = UITableView()
    private lazy var searchController = UISearchController()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var coordinator: MainCoordinator?
    private  var viewModel = MovieSearchViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupActivityIndicator()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Search Movie"
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        // SearchController Setup
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a movie"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.returnKeyType = .done
        navigationItem.searchController = searchController
        
        // TableView Setup
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$movies
            .receive(on: RunLoop.main)
            .sink { [weak self] movies in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.tableView.refreshControl?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.errorMessage = { errorMessage in
            if let error = errorMessage {
                self.showErrorMessage(error)
            }
        }
    }
    
    private func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshMovieList), for: .valueChanged)
    }
    
    @objc private func refreshMovieList() {
        viewModel.searchMovies(for: viewModel.searchTerm)
    }
}

extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? UITableViewCell else {
            fatalError("Unable to dequeue UITableViewCell.")
        }
        cell.textLabel?.text = viewModel.movies[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = viewModel.movies[indexPath.row].imdbID else { return }
        coordinator?.showMovieDetail(id)
    }
}

extension MovieSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            viewModel.emptyList()
            return
        }
        activityIndicator.startAnimating()
        viewModel.searchTerm = searchText
    }
}
