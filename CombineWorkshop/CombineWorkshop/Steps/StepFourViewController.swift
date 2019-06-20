//
//  StepFourViewController.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 20/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//

import UIKit
import Combine

final class StepFourViewController: UIViewController {

    private var searchSubscriber: AnyCancellable?

    private let searchURL = URL(string: "https://www.mygreatAPI.com/search")!
    private let decoder = JSONDecoder()

    @Published private var repos: [Repo] = []
    @Published private var searchQuery: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearch()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search for repository"
        navigationItem.searchController = search

        $repos.sink { (repos) in
            print(repos)
        }
    }

    private func setupSearch() {
        searchSubscriber = $searchQuery
            .filter { $0.count > 2 }
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { (query) -> URL in
                guard let url = URL(string: "https://api.github.com/search/repositories?q=\(query)+language:swift")
                    else { preconditionFailure("Can't create url for query: \(query)") }
                return url
            }
            .flatMap { url -> AnyPublisher<Data, Never> in
                return URLSession.shared.dataTaskPublisher(for: url)
                    .assertNoFailure()
                    .map { $0.data }
                    .eraseToAnyPublisher()
            }.flatMap { data in
                return Publishers.Just(data)
                    .decode(type: SearchResponse.self, decoder: self.decoder)
                    .map { $0.items }
                    .assertNoFailure()
            }.assign(to: \.repos, on: self)
    }
}

extension StepFourViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchQuery = searchController.searchBar.text ?? ""
    }
}
