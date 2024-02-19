//
//  MovieDetailViewController.swift
//  MVVM-C_BoilerPlate
//
//  Created by Nurşah Ari on 17.02.2024.
//

import UIKit
import SkeletonView

class MovieDetailViewController: UIViewController, UITextViewDelegate {
    
    private lazy var insideView = UIView()
    private lazy var infoView = UIView()
    private lazy var scrollView = UIScrollView()
    private lazy var imageView = UIImageView()
    private lazy var plotTextView = UITextView()
    private lazy var collectionView = UICollectionView()
    
    var movie : Movie?
    var name = String()
    private var padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        prepareUI()
        insideView.showAnimatedSkeleton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func prepareUI() {
        configureViewController()
        configureScrollView()
        configureInsideView()
        configureImageView()
        configureInfoView()
        configureCollectionView()
        configurePlotTextView()
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem?.image = UIImage(systemName: "chevron.backward")
        title = name
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
            infoView.heightAnchor.constraint(equalToConstant: 400),
            infoView.widthAnchor.constraint(equalToConstant: view.frame.width),
            infoView.leadingAnchor.constraint(equalTo: insideView.leadingAnchor),
            infoView.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.topAnchor, constant: 300),
            infoView.trailingAnchor.constraint(equalTo: insideView.trailingAnchor)
        ])
    }
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray6
        collectionView.isSkeletonable = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topRadius = 30
        infoView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.topAnchor,constant: 30),
            imageView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 500)
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
            plotTextView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: padding),
            plotTextView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -padding),
            plotTextView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: padding),
        ])
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCell.identifier, for: indexPath) as? MovieDetailCell {
            guard let movie = self.movie else { return }
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
    
    
}
