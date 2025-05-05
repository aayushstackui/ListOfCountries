//
//  CountriesListViewController.swift
//  ListOfCountries
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation
import Combine
import UIKit

class CountriesListViewController: UIViewController {
    private let viewModel = CountriesListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CountriesListTableViewCell.self, forCellReuseIdentifier: CountriesListTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CountriesListCollectionViewCell.self, forCellWithReuseIdentifier: CountriesListCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search nations by name or capital"
        controller.searchBar.accessibilityLabel = "Search nations by name or capital"
        controller.searchBar.accessibilityHint = "Enter a nation's name or capital to filter the list"
        controller.searchBar.barTintColor = UIColor.systemBackground.withAlphaComponent(0.9)
        controller.searchBar.tintColor = .systemIndigo
        controller.searchBar.searchTextField.backgroundColor = .systemBackground
        controller.searchBar.searchTextField.textColor = .label
        return controller
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "List of Countries"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAccessibility()
        setupDropdownMenu()
        bindViewModel()
        viewModel.fetchCountries()
    }
    
    private func setupUI() {
        // Gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemGray6.withAlphaComponent(0.8).cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Customize navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground.withAlphaComponent(0.9)
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(tableView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        updateViewVisibility()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    private func setupAccessibility() {
        tableView.accessibilityLabel = "List of countries"
        tableView.accessibilityHint = "Scroll to explore countries in list view or use the search bar to filter"
        collectionView.accessibilityLabel = "Grid of countries"
        collectionView.accessibilityHint = "Scroll to explore countries in grid view or use the search bar to filter"
        navigationItem.accessibilityLabel = "Countries List"
    }
    
    private func setupDropdownMenu() {
        let listAction = UIAction(title: "List", image: UIImage(systemName: "list.bullet")) { [weak self] _ in
            self?.viewModel.viewMode = .list
            self?.updateViewVisibility()
            UIAccessibility.post(notification: .announcement, argument: "Switched to list view")
        }
        let gridAction = UIAction(title: "Grid", image: UIImage(systemName: "square.grid.2x2")) { [weak self] _ in
            self?.viewModel.viewMode = .grid
            self?.updateViewVisibility()
            UIAccessibility.post(notification: .announcement, argument: "Switched to grid view")
        }
        let menu = UIMenu(title: "View Mode", children: [listAction, gridAction])
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        menuButton.accessibilityLabel = "View mode selector"
        menuButton.accessibilityHint = "Tap to choose between list and grid view"
        menuButton.tintColor = .systemIndigo
        navigationItem.rightBarButtonItem = menuButton
    }
    
    private func updateViewVisibility() {
        tableView.isHidden = viewModel.viewMode != .list
        collectionView.isHidden = viewModel.viewMode != .grid
        if viewModel.viewMode == .grid {
            collectionView.reloadData()
        } else {
            tableView.reloadData()
        }
    }
    
    private func bindViewModel() {
        viewModel.$filteredCountries
            .receive(on: DispatchQueue.main)
            .sink { [weak self] countries in
                self?.updateViewVisibility()
                let announcement = "\(countries.count) countries found"
                UIAccessibility.post(notification: .announcement, argument: announcement)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$viewMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateViewVisibility()
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.view.accessibilityLabel = "Error alert: \(message)"
        alert.view.accessibilityHint = "Tap OK to release"
        present(alert, animated: true)
        UIAccessibility.post(notification: .screenChanged, argument: alert.view)
    }
}

extension CountriesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountriesListTableViewCell.identifier, for: indexPath) as? CountriesListTableViewCell else {
            return UITableViewCell()
        }
        let country = viewModel.filteredCountries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CountriesListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountriesListCollectionViewCell.identifier, for: indexPath) as? CountriesListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let country = viewModel.filteredCountries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 48) / 2
        return CGSize(width: width, height: 100)
    }
}

extension CountriesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        viewModel.filterCountries(with: searchText)
    }
}
