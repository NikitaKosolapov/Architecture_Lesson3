//
//  NewsViewController.swift
//  KosolapovNikita
//
//  Created by Nikita on 12/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var news: [NewsItem] = [] // Define news
    private let viewModelFactory = NewsViewModelFactory()
    private var viewModels: [NewsViewModel] = []
    
    // "Pull to refresh"
    var refreshControl = UIRefreshControl()
    var nextFrom = ""
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        tableView.prefetchDataSource = self // "Pull to refresh"
        //        tableView.delegate = self
        
        setupRefreshControl() // "Pull to refresh" add refresh control
        
        MakeRequest.shared.getNews() { [weak self] (news,nextFrom)  in
            self?.news = news
            self?.viewModels = (self?.viewModelFactory.constructViewModels(from: news))!
            self?.nextFrom = nextFrom ?? "" // "Infinite scrolling"
            self?.tableView.reloadData()
        }
    }
    
    // "Pull to refresh" refresh control
    func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(self.refreshNews), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refreshNews() {
        self.refreshControl.beginRefreshing() // begin updating
        let mostFreshNewsDate = self.news.first?.date ?? Date()  // define most fresh news or take current time
        MakeRequest.shared.getNews(startTime: mostFreshNewsDate + 1) { [weak self] (news,nextFrom) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing() // turn off refreshControl
            guard news.count > 0 else { return }
            self.news = news + self.news
            let indexSet = IndexSet(integersIn: 0..<news.count)
            self.tableView.insertSections(indexSet, with: .automatic)
        }
    }
}

extension NewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({$0.row}).max()else { return }
        print(maxRow)
        if maxRow > self.news.count - 3,
            !isLoading {
            isLoading = true
            MakeRequest.shared.getNews(startFrom: nextFrom) { [weak self] (news, nextFrom) in
                guard let self = self,
                    let nextFrom = nextFrom else { return }
                self.nextFrom = nextFrom
                let indexSet = IndexSet(integersIn: self.news.count..<self.news.count + news.count)
                let indexPaths = indexSet.map{IndexPath(row:$0, section:0)}
                self.news.append(contentsOf: news)
                self.tableView.insertRows(at: indexPaths, with: .automatic)
                self.isLoading = false
            }
        }
    }
}
