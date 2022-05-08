//
//  ColleagueListViewModel.swift
//  DirectoryApp
//
//  Created by Geethika on 08/05/22.
//

import Foundation
// MARK: - ViewModels
struct ColleagueListViewModel {
    
    private enum ColleagueConstants {
        static let peopleURL = "https://61e947967bc0550017bc61bf.mockapi.io/api/v1/people"
        static let peopleJson = "ColleagueData"
        static let jsonExtension = "json"
        static let length = 0
    }
    
    var colleagues: Observable<[ColleagueTableViewCellViewModel]> = Observable([])
    
    var imageCache: Observable<NSCache<AnyObject, AnyObject>> = Observable(NSCache<AnyObject, AnyObject>())
    
    /// Fetch people data from url
    private func parseColleagueData(_ data: Data) throws {
        do {
            let colleagueModels = try JSONDecoder().decode(ColleagueList.self, from: data)
            self.colleagues.value = colleagueModels.compactMap({ ColleagueTableViewCellViewModel(model: $0)
            })
        }
    }
    /// Get the colleague list data from url
    /// - Parameter urlString: API url string
    private func fetchColleagues(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        NetworkHandler.getData(url: url) { data, _, error in
            guard let data = data else { return }
            do {
                try parseColleagueData(data)
            } catch {
                debugPrint("Colleague data parsing failed")
            }
        }
    }
    
    /// Read the colleague list data from JSON filePath
    /// - Parameters:
    ///   - filePath: json file path in the bundle
    ///   - fileExtension: file extension
    private func fetchColleagues(data: Data) throws {
        guard let colleagueModels = try? JSONDecoder().decode(ColleagueList.self, from: data) else {
            return
        }
        self.colleagues.value = colleagueModels.compactMap({ ColleagueTableViewCellViewModel(model: $0)
        })
    }
    
    /// Fetch data from either API or JSON based on the temp variable offline
    func fetchData() throws {
        if offline {
            do {
                if let jsonData = try NetworkHandler.readData(from: ColleagueConstants.peopleJson, fileExtension: ColleagueConstants.jsonExtension) {
                    try fetchColleagues(data: jsonData)
                }
            }
        } else {
            fetchColleagues(from: ColleagueConstants.peopleURL)
        }
    }
    
    func fetchImage(urlString: String, completion: @escaping (Result<Data>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        NetworkHandler.downloadImage(url: url) { result in
            completion(result)
        }
    }
}
