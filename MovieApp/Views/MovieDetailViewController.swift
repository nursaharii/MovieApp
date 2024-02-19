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

class MovieDetailViewController: UIViewController, UITextViewDelegate {
    
    private lazy var insideView = UIView()
    private lazy var scrollView = UIScrollView()
    private lazy var imageView = UIImageView()
    private lazy var infoView = UIView()
    private var collectionView : UICollectionView!
    private lazy var plotTextView = UITextView()
    
    private  var viewModel = MovieDetailViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
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
        insideView.showAnimatedSkeleton()
        configureViewController()
        configureScrollView()
        configureInsideView()
        configureImageView()
        configureInfoView()
        configureCollectionView()
        configurePlotTextView()
        
    }
    
    func updateUI() {
        guard let movie = viewModel.movie else { return}
        imageView.kf.setImage(with: URL(string: movie.poster ?? ""))
        title = movie.title
        plotTextView.text = movie.plot
        self.insideView.stopSkeletonAnimation()
        self.collectionView.reloadData()
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
        navigationItem.backBarButtonItem?.image = UIImage(systemName: "chevron.backward")
        navigationItem.backBarButtonItem?.title = ""
    }
    
    func configureScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + padding)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
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
        insideView.addSubview(infoView)
        
        NSLayoutConstraint.activate([
            infoView.widthAnchor.constraint(equalToConstant: view.frame.width),
            infoView.leadingAnchor.constraint(equalTo: insideView.leadingAnchor),
            infoView.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.topAnchor, constant: 300),
            infoView.trailingAnchor.constraint(equalTo: insideView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: insideView.bottomAnchor)
        ])
    }
    
    func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        collectionView = UICollectionView(frame: infoView.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isSkeletonable = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topRadius = 30
        collectionView.register(MovieDetailCell.self,forCellWithReuseIdentifier: MovieDetailCell.identifier)
        infoView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 300),
            collectionView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
        ])
    }
    
    func configurePlotTextView() {
        plotTextView.translatesAutoresizingMaskIntoConstraints = false
        plotTextView.sizeToFit()
        plotTextView.isScrollEnabled = false
        plotTextView.isSkeletonable = true
        plotTextView.cornerRadius = 8
        plotTextView.addShadow(opacity: 0.6)
        plotTextView.isUserInteractionEnabled = false
        plotTextView.delegate = self
        plotTextView.font = .systemFont(ofSize: 14)
        infoView.addSubview(plotTextView)
        
        NSLayoutConstraint.activate([
            plotTextView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: padding),
            plotTextView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: padding),
            plotTextView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -padding)
        ])
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.movie == nil {
            return 0
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCell.identifier, for: indexPath) as? MovieDetailCell {
            guard let movie = viewModel.movie else { return UICollectionViewCell() }
            switch indexPath.row {
            case 0:
                cell.setLabel(movie.title ?? "")
            case 1:
                cell.setLabel(movie.type ?? "")
            case 2:
                cell.setLabel(movie.imdbRating ?? "")
            case 3:
                cell.setLabel(movie.language ?? "")
            default:
                cell.setLabel(movie.type ?? "")
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width , height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
