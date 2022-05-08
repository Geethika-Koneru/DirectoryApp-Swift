//
//  ImageHandler.swift
//  DirectoryApp
//
//  Created by Geethika on 07/05/22.
//

import Foundation
//import UIKit

enum Result<T> {
    case success(T), failure(Error)
    /// - Returns: success value
    /// - Throws: error
    func getValue() throws -> T {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}

final class NetworkHandler: NSObject {
    
    // MARK: - Private functions
    /// data task to get data from API
    /// - Parameters:
    ///   - url: url for the data task
    ///   - completion: completion handler for the data task response
    static func getData(url: URL,
                                completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // MARK: - downloadImage function
    
    /// download the images
    /// - Parameters:
    ///   - url: url to download images
    ///   - completion: returns completion handler Result<Data>
    static func downloadImage(url: URL,
                                     completion: @escaping (Result<Data>) -> Void) {
        NetworkHandler.getData(url: url) { data, _, error in
            DispatchQueue.main.async() {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }
    }
    
    static func readData(from filePath: String, fileExtension: String) throws -> Data? {
        guard let jsonPathURL = Bundle.main.url(forResource: filePath, withExtension: fileExtension) else { return nil }
        do {
            let jsonData = try Data(contentsOf: jsonPathURL)
            return jsonData
        }
    }
}



