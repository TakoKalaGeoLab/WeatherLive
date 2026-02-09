//
//  WeatherDetailsCollectionViewCell.swift
//  WeatherLive
//
//  Created by Marika Kalandia on 09.02.26.
//

import UIKit

class WeatherDetailsCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeatherDetailsCollectionViewCell"
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        return label
    }()
    
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .green
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(detailsStackView)
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            detailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        detailsStackView.addArrangedSubview(temperatureLabel)
    }
    
    func configure(with model: WeatherDetailsCollectionViewCellModel) {
        temperatureLabel.text = "\(model.temperature ?? 0)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
