//
//  ViewController.swift
//  WalmartProject
//
//  Created by Arpit Mallick on 3/14/25.
//

import UIKit

class CountryListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let viewModel = CountryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchCountries()
    }

    private func setupUI() {
        title = "Countries"
        view.backgroundColor = .white
        
        searchBar.delegate = self
        searchBar.placeholder = "Search by country or capital"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        tableView.register(CountryListCell.self, forCellReuseIdentifier: CountryListCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension CountryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.numberOfRows()
        return count == 0 ? 1 : count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.filteredCountries.isEmpty {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No such country found"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .gray
            cell.selectionStyle = .none
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryListCell.identifier, for: indexPath) as? CountryListCell,
              let country = viewModel.country(at: indexPath.row) else {
            return UITableViewCell()
        }

        cell.configure(with: country)
        return cell
    }
}

extension CountryListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCountries(query: searchText)
    }
}





