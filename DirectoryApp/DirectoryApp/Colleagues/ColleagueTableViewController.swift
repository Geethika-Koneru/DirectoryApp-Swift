//
//  ViewController.swift
//  DirectoryApp
//
//  Created by Geethika on 06/05/22.
//

import UIKit

// MARK: - Controller
class ViewController: UITableViewController {
    private var viewModel = ColleagueListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelData()
        do {
            try viewModel.fetchData()
        } catch let error {
            debugPrint("Failed to get people data with error: \(error)")
        }
    }
    
    fileprivate func bindViewModelData() {
        viewModel.colleagues.bind { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController {
    /// Table datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.colleagues.value?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ColleagueTableViewCell else {
            return UITableViewCell()
        }
        guard let cellViewModel = viewModel.colleagues.value?[indexPath.row] else {
            return cell
        }
        cell.viewModel = cellViewModel
        viewModel.imageCache.bind { imageCache in
            let url = cellViewModel.colleague.avatar
            if let imageFromCache = imageCache?.object(forKey: url as AnyObject) {
                cell.avatar.image = nil
                if let cachedImage = imageFromCache as? UIImage {
                    cell.avatar.image = cachedImage
                }
            } else {
                self.viewModel.fetchImage(urlString: url) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let data):
                        guard let imageToCache = UIImage(data: data) else { return }
                        self.viewModel.imageCache.value?.setObject(imageToCache, forKey: cellViewModel.colleague.avatar as AnyObject)
                        cell.avatar.image = imageToCache
                    case .failure(_): return
                    }
                }
            }
        }
        return cell
    }
}
