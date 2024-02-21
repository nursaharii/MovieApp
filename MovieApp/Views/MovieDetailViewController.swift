//
//  MovieDetailViewController.swift
//  MVVM-C_BoilerPlate
//
//  Created by Nurşah Ari on 17.02.2024.
//

import UIKit
import SkeletonView
import Kingfisher
import Combine
import Cosmos

class MovieDetailViewController: UIViewController, UITextViewDelegate {
    
    private lazy var insideView = UIView()
    private lazy var scrollView = UIScrollView()
    private lazy var imageView = UIImageView()
    private lazy var infoView = UIView()
    private lazy var plotTextView = UITextView()
    private lazy var cosmosView = CosmosView()
    private lazy var cosmosOutsideView = UIView()
    private lazy var viewModel = MovieDetailViewModel()
    private lazy var stackView = UIStackView()
    private lazy var titleLabel = UILabel()
    private lazy var yearLabel = UILabel()
    private lazy var languageLabel = UILabel()
    private lazy var genreLabel = UILabel()
    private lazy var goToImdbButton = UIButton()
    
    
    
    private var cancellables: Set<AnyCancellable> = []
    private var movieGenre = [String]()
    private var movieLanguage = [String]()
    
    var movieId : String = "" {
        didSet {
            viewModel.getMovieDetail(for: movieId)
        }
    }
    
    private var padding: CGFloat = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        prepareUI()
    }
    
    func prepareUI() {
        infoView.showAnimatedSkeleton()
        configureViewController()
        configureScrollView()
        configureInsideView()
        configureImageView()
        configureInfoView()
        configureTitleLabel()
        configureCosmosOutsideView()
        configureCosmosView()
        configureStackView()
        configureYearLabel()
        configureLanguageLabel()
        configureGenreLabel()
        configurePlotTextView()
        configureGoToImdbButton()
    }
    
    func updateUI() {
        guard let movie = viewModel.movie else { return}
        imageView.kf.setImage(with: URL(string: movie.poster ?? ""))
        title = movie.title
        plotTextView.text = movie.plot
        infoView.stopSkeletonAnimation()
        if let raiting = movie.imdbRating, let doubleRating = Double(raiting) {
            cosmosView.rating = doubleRating/2
        }
        
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        if let genre = movie.genre?.components(separatedBy: ",").first as? String {
            genreLabel.text = genre
        }
        languageLabel.text = movie.language
    }
    
    private func bindViewModel() {
        viewModel.$movie
            .receive(on: RunLoop.main)
            .sink { [weak self] movie in
                guard let self = self else { return }
                self.updateUI()
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
    
}

//MARK: Configure UI
extension MovieDetailViewController {
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backItem?.title = ""
        navigationItem.largeTitleDisplayMode = .never
        view.isSkeletonable = true
    }
    
    func configureScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + padding)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isSkeletonable = true
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    func configureInsideView() {
        insideView.frame.size = CGSize(width: view.frame.width, height: view.frame.height + padding)
        insideView.isSkeletonable = true
        scrollView.addSubview(insideView)
    }
    
    func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        imageView.isSkeletonable = true
        imageView.topRadius = 30
        insideView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: insideView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: insideView.safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: insideView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    func configureInfoView() {
        infoView.backgroundColor = .white
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.topRadius = 30
        infoView.isSkeletonable = true
        insideView.addSubview(infoView)
        
        NSLayoutConstraint.activate([
            infoView.widthAnchor.constraint(equalToConstant: view.frame.width),
            infoView.leadingAnchor.constraint(equalTo: insideView.leadingAnchor),
            infoView.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.topAnchor, constant: 300),
            infoView.trailingAnchor.constraint(equalTo: insideView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: insideView.bottomAnchor)
        ])
    }
    
    func configureTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 32)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isSkeletonable = true
        titleLabel.text = "title"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        infoView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -padding),
        ])
    }
    
    func configureCosmosOutsideView() {
        cosmosOutsideView.backgroundColor = .white
        cosmosOutsideView.translatesAutoresizingMaskIntoConstraints = false
        cosmosOutsideView.isSkeletonable = true
        infoView.addSubview(cosmosOutsideView)
        
        NSLayoutConstraint.activate([
            cosmosOutsideView.heightAnchor.constraint(equalToConstant: 30),
            cosmosOutsideView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            cosmosOutsideView.widthAnchor.constraint(equalToConstant: infoView.frame.width),
            cosmosOutsideView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            cosmosOutsideView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
        ])
    }
    
    func configureCosmosView() {
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.totalStars = 5
        cosmosView.settings.filledColor = .orange
        cosmosView.settings.emptyBorderColor = .orange
        cosmosView.settings.filledBorderColor = .orange
        cosmosView.settings.starMargin = 5
        cosmosView.settings.starSize = 20
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.disablePanGestures = true
        cosmosView.isSkeletonable = true
        
        cosmosOutsideView.addSubview(cosmosView)
        
        NSLayoutConstraint.activate([
            cosmosView.centerXAnchor.constraint(equalTo: cosmosOutsideView.centerXAnchor),
            cosmosView.centerYAnchor.constraint(equalTo: cosmosOutsideView.centerYAnchor)
        ])
    }
    
    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isSkeletonable = true
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        infoView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: cosmosOutsideView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor,constant: 50),
            stackView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor,constant: -50),
        ])
    }
    
    func configureYearLabel() {
        yearLabel.font = .systemFont(ofSize: 12)
        yearLabel.textColor = .label
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.isSkeletonable = true
        yearLabel.text = "year"
        stackView.addArrangedSubview(yearLabel)
        NSLayoutConstraint.activate([
            yearLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configureLanguageLabel() {
        languageLabel.font = .systemFont(ofSize: 12)
        languageLabel.textColor = .label
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.isSkeletonable = true
        languageLabel.numberOfLines = 0
        languageLabel.textAlignment = .center
        languageLabel.text = "language"
        stackView.addArrangedSubview(languageLabel)
        
        NSLayoutConstraint.activate([
            languageLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configureGenreLabel() {
        genreLabel.font = .systemFont(ofSize: 12)
        genreLabel.textColor = .label
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.isSkeletonable = true
        genreLabel.textAlignment = .right
        genreLabel.text = "genre"
        stackView.addArrangedSubview(genreLabel)
        
        NSLayoutConstraint.activate([
            genreLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configurePlotTextView() {
        plotTextView.translatesAutoresizingMaskIntoConstraints = false
        plotTextView.sizeToFit()
        plotTextView.isScrollEnabled = true
        plotTextView.isSkeletonable = true
        plotTextView.isUserInteractionEnabled = false
        plotTextView.delegate = self
        plotTextView.font = .systemFont(ofSize: 14)
        plotTextView.textAlignment = .center
        infoView.addSubview(plotTextView)
        
        NSLayoutConstraint.activate([
            plotTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 150),
            plotTextView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            plotTextView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: padding),
            plotTextView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -padding)
        ])
    }
    
    func configureGoToImdbButton() {
        goToImdbButton.translatesAutoresizingMaskIntoConstraints = false
        goToImdbButton.setTitleColor(.systemYellow, for: .normal)
        goToImdbButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        goToImdbButton.backgroundColor = .black
        goToImdbButton.configuration?.titlePadding = 10
        goToImdbButton.cornerRadius = 5
        goToImdbButton.setTitle("Go To IMDB Page", for: .normal)
        goToImdbButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        infoView.addSubview(goToImdbButton)
        
        NSLayoutConstraint.activate([
            goToImdbButton.heightAnchor.constraint(equalToConstant: 50),
            goToImdbButton.topAnchor.constraint(equalTo: plotTextView.bottomAnchor,constant: padding),
            goToImdbButton.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            goToImdbButton.leftAnchor.constraint(equalTo: infoView.leftAnchor,constant: padding),
            goToImdbButton.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -padding)
        ])
    }
    
    @objc func buttonAction(_ sender:UIButton!) {
        viewModel.goToiMDBPage(movieId)
    }
}
