//
//  StorageManager.swift
//  FileManagerExample
//
//  Created by Viktor Golubenkov on 14.09.2021.
//

import SwiftUI

class StorageManager: ObservableObject {
    
    static let shared: StorageManager = StorageManager()
    
    @Published var someData = [SomeData]()

    private let dataSourceURL: URL
    private let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private let cloudDocsPath = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents").appendingPathComponent("data.json")
    
    init() {
        let internalPath = docsPath.appendingPathComponent("data").appendingPathExtension("json")
        dataSourceURL = internalPath
        _someData = Published(wrappedValue: getData())
    }
    
    func create(data: SomeData) {
        someData.insert(data, at: 0)
        saveData()
        copyToCloud()
    }
    
    func update(data: SomeData) {
        someData.removeAll()
        someData.append(data)
        saveData()
        copyToCloud()
    }
    
    func delete() {
        someData.removeAll()
        saveData()
        copyToCloud()
    }
    
    // firstly check file from iCloud (if 'false', trying to get data from 'internal container')
    private func getData() -> [SomeData] {
        if !checkCloudDirectory() {
            do {
                let decoder = PropertyListDecoder()
                let data = try Data(contentsOf: dataSourceURL)
                let decodedData = try! decoder.decode([SomeData].self, from: data)
                print("Requested data from internal file: ", decodedData)
                return decodedData
            } catch {
                print("Internal file is empty")
                return []
            }
        } else {
            let decoder = PropertyListDecoder()
            let data = try? Data(contentsOf: cloudDocsPath!)
            let decodedData = try! decoder.decode([SomeData].self, from: data!)
            print("Decoded data from iCloud: ", decodedData)
            return decodedData
        }
    }
    // copy data to iCloud
    private func copyToCloud() {
        guard let cloudDirectory = cloudDocsPath else { return }
        
        if FileManager.default.fileExists(atPath: cloudDirectory.path) {
            do {
                try FileManager.default.removeItem(at: cloudDirectory)
            } catch {
                print("Error. Removing data from iCloud!")
            }
        }
        do {
            try FileManager.default.copyItem(at: docsPath, to: cloudDirectory)
        } catch {
            print("Error. Copy file to iCloud!")
        }
    }
    
    private func checkCloudDirectory() -> Bool {
        guard let cloudDirectory = cloudDocsPath else { return false }
        if FileManager.default.fileExists(atPath: cloudDirectory.path) {
            print("File exists in iCloud!", cloudDirectory)
            return true
        }
        print("File not exists in iCloud!")
        return false
    }
    
    private func saveData() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(someData)
            try data.write(to: dataSourceURL)
            print("Data: ", data, "saved to file: ", dataSourceURL)
        } catch {
            print("Could not save data", error.localizedDescription)
        }
    }
    
}

