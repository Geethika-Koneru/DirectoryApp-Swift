//
//  ObservableData.swift
//  DirectoryApp
//
//  Created by Geethika on 08/05/22.
//

import Foundation

// MARK: - Observable

class Observable<T> {
    var value: T? {
        didSet {
            listners.forEach { $0(value) }
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listners: [((T?) -> Void)] = []
    
    func bind(_ listner: @escaping (T?) -> Void) {
        listner(value)
        self.listners.append(listner)
    }
}
