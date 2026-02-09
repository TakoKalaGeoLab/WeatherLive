//
//  SearchViewcontroller.swift
//  WeatherLive
//
//  Created by Marika Kalandia on 06.02.26.
//

import UIKit

class SearchViewcontroller: UIViewController {
    let searchBar = UISearchBar()
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var countriesList: [Country] = []
    var filteredCountries: [Country] = []
    var searcText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        setupSearchBar()
        setupTableView()
        fetchCountries()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Countries"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchBar.becomeFirstResponder()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
    }
    
    private func fetchCountries() {
        NetworkManager.fetchCountries { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let countries):
                DispatchQueue.main.async {
                    self.countriesList = countries
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch countries: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITableView DataSource

extension SearchViewcontroller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredCountries[indexPath.row].name?.common
        return cell
    }
}

// MARK: - UITableView Delegate

extension SearchViewcontroller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCountry = filteredCountries[indexPath.row]
//        let mapViewVC = CountryMapViewController()
//        mapViewVC.countryName = currentCountry.capital?.first ?? "Unknown"
//        mapViewVC.latLong = currentCountry.capitalInfo?.latlng
//        navigationController?.pushViewController(mapViewVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UISearchBar Delegate

extension SearchViewcontroller: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searcText = searchText
        if searchText.isEmpty {
            filteredCountries = []
        } else {
            filteredCountries = countriesList.filter { country in
                country.name?.common?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        tableView.reloadData()
    }
}
