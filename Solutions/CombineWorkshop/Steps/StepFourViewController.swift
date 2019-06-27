//
//  StepFourViewController.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 20/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//

import UIKit
import Combine

/*
 STEP 4:
 Searching!

 Search for Swift repositories on Github, but make sure:
 - Only start searching when there's more than 2 characters of input
 - Debounce for at least 0.3 seconds to not trigger unneeded requests
 - Remove any duplicate inputs which might happen because of the debounce
 - Just show an empty list when an error occurs
 - Decode to `SearchResponse` to get the array of `Repo` instances
 */

final class StepFourViewController: UITableViewController {

    private var searchSubscriber: AnyCancellable?
    private var repositoriesSubscriberCancellable: AnyCancellable?

    private let decoder = JSONDecoder()

    @Published private var repos: [Repo] = []
    @Published private var searchQuery: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        setupSearchSubscriber()

        let repositoriesSubscriber = $repos
            .receive(on: DispatchQueue.main)
            .sink { (repos) in
                self.tableView.reloadData()
            }
        repositoriesSubscriberCancellable = AnyCancellable(repositoriesSubscriber)

    }

    private func githubAPISearchURL(for query: String) -> URL {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(query)+language:swift")
            else { preconditionFailure("Can't create url for query: \(query)") }
        return url
    }

    private func setupSearchSubscriber() {
        searchSubscriber = $searchQuery
            .filter { $0.count > 2 }
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { (query) -> URL in
                return self.githubAPISearchURL(for: query)
            }
            .flatMap { url in
                return URLSession.shared.dataTaskPublisher(for: url)
                    .map { $0.data }
                    .decode(type: SearchResponse.self, decoder: self.decoder)
                    .map { $0.items }
                    .catch { error -> Publishers.Just<[Repo]> in
                        print("Decoding failed with error: \(error)")
                        return Publishers.Just([])
                    }
            }.assign(to: \.repos, on: self)
    }
}

extension StepFourViewController {
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        let searchTextField: UITextField? = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.attributedPlaceholder = NSAttributedString(string: "Search for repository", attributes: [.foregroundColor: UIColor.white])
        searchTextField?.textColor = .white

        navigationItem.searchController = searchController
    }
}

extension StepFourViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchQuery = searchController.searchBar.text ?? ""
    }
}

extension StepFourViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath)
        cell.textLabel?.text = repos[indexPath.row].name
        return cell
    }
}
