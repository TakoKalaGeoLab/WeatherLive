//
//  HomeViewController.swift
//  WeatherLive
//
//  Created by Marika Kalandia on 06.02.26.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var citiesList: [String] = ["", ""]
    
    private lazy var width: CGFloat = view.frame.size.width - 40
    private lazy var height: CGFloat = view.frame.size.height
    private let identifier = "WeatherDetailsCollectionViewCell"
    private let scrollThreshold = 50.0
    private var beforeOffset: Double = 0
    private var afterOffset: Double = 0
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(
            WeatherDetailsCollectionViewCell.self,
            forCellWithReuseIdentifier: identifier
        )
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = .fast
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    private var pageIndex = 0 {
        didSet {
            onPageDidChange?(oldValue, pageIndex)
        }
    }
    
    var onPageDidChange: ((Int, Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCollectionViewCell()
        checkCurrentLocationStatus()
        setupLocationManager()
    }
    
    private func setupUI() {
        view.backgroundColor = .gray
    }
    
    private func setupCollectionViewCell() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func checkCurrentLocationStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocation = locationManager.location
            getCurrentLocationWeather()
        default:
            return
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func getCurrentLocationWeather() {
        let lat = currentLocation?.coordinate.latitude ?? 37.3230
        let lng = currentLocation?.coordinate.longitude ?? 122.0322
        NetworkManager.fetchWeatherDetails(lat: lat, lng: lng) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    print(model)
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocation = locationManager.location
            getCurrentLocationWeather()
        default:
            return
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        citiesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? WeatherDetailsCollectionViewCell
        else { fatalError() }
        let model = WeatherDetailsCollectionViewCellModel(temperature: 17)
        cell.configure(with: model)
        return  cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: height)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beforeOffset = scrollView.contentOffset.x
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        targetContentOffset.pointee = scrollView.contentOffset
        afterOffset = scrollView.contentOffset.x
        
        let diff = afterOffset - beforeOffset
        
        if diff >= scrollThreshold {
            pageIndex += 1
            if pageIndex >= citiesList.count {
                pageIndex = citiesList.count - 1
            }
        } else if diff <= -scrollThreshold {
            pageIndex -= 1
            if pageIndex < 0 {
                pageIndex = 0
                beforeOffset = 0
                afterOffset = 0
            }
        }
        
        collectionView.scrollToItem(
            at: IndexPath(item: pageIndex, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }

}
