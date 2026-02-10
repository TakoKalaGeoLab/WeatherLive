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
        label.font = .boldSystemFont(ofSize: 36)
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.textAlignment = .center
        return label
    }()
    
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(detailsStackView)

        detailsStackView.addArrangedSubview(nameLabel)
        detailsStackView.addArrangedSubview(temperatureLabel)

        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            detailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            detailsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            detailsStackView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        temperatureLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func configure(with model: WeatherDetailsCollectionViewCellModel) {
        let city = model.city
        temperatureLabel.text = "\(city.current.temperature)"
        nameLabel.text = city.city
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
