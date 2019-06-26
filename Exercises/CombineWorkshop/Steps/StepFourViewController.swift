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
    private var repositoriesSubscriber: AnyCancellable?

    private let decoder = JSONDecoder()

    @Published private var repos: [Repo] = []
    @Published private var searchQuery: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        setupSearchSubscriber()

        // Step 1: Make sure that the table view reloads its data when $repos changes
        _ = $repos
    }

    private func githubAPISearchURL(for query: String) -> URL {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(query)+language:swift")
            else { preconditionFailure("Can't create url for query: \(query)") }
        return url
    }

    private func setupSearchSubscriber() {
        // Step 2: Set up a subscriber to the changing search query
//        searchSubscriber = $searchQuery
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
