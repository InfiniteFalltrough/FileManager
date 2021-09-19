//
//  ContentView.swift
//  FileManagerExample
//
//  Created by Viktor Golubenkov on 11.09.2021.
//

import SwiftUI

let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height

struct ContentView: View {
    
    @StateObject var storeManager: StorageManager = StorageManager()
    
    @State private var savedText: String = ""
    @State private var oldText: String?
    @State private var oldDate: Date?
    @State private var savedDate: Date = Date()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient( colors: [Color.red, Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing).opacity(0.75)
            VStack(spacing: 15) {
                VStack(spacing: 2.5) {
                    if oldText != nil {
                        Text(oldText!)
                            .font(.system(size: 18))
                            .foregroundColor(Color.white)
                            .frame(width: width, alignment: .center)
                    }
                    if oldDate != nil {
                        Text("\(oldDate ?? Date())")
                            .font(.system(size: 18))
                            .foregroundColor(Color.white)
                            .frame(width: width, alignment: .center)
                    }
                }.frame(width: width, height: 200, alignment: .center)
                
                Text(savedText)
                    .font(.system(size: 18))
                    .foregroundColor(Color.black)
                    .frame(width: width, alignment: .center)
                
                TextField("", text: $savedText)
                    .padding(.horizontal, 5)
                    .font(.system(size: 18))
                    .foregroundColor(Color.black)
                    .frame(width: width / 1.25, height: 40, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(8)
                
                Group {
                    createButton
                    readButton
                    updateButton
                    deleteButton
                }
            }
        }.frame(width: width, height: height, alignment: .center)
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            oldText = StorageManager.shared.someData.first?.text
            oldDate = StorageManager.shared.someData.first?.date
        }
    }
    
    // 1. save data to internal file
    // 2. copy to iCloud
    var createButton: some View {
        Button(action: {
            if savedText != "" {
                StorageManager.shared.create(data: SomeData(text: savedText, date: Date()))
            }
        }, label: {
            Text("Create")
                .frame(width: 200, height: 40, alignment: .center)
                .background(Color.white)
                .cornerRadius(8)
        })
    }
    // read data from StoreManager
    var readButton: some View {
        Button(action: {
            if !StorageManager.shared.someData.isEmpty {
                oldText = StorageManager.shared.someData.first?.text
                oldDate = StorageManager.shared.someData.first?.date
            }
        }, label: {
            Text("Read")
                .frame(width: 200, height: 40, alignment: .center)
                .background(Color.white)
                .cornerRadius(8)
        })
    }
    // 1. update data from internal file
    // 2. copy new data to iCloud
    var updateButton: some View {
        Button(action: {
            StorageManager.shared.update(data: SomeData(text: savedText, date: Date()))
        }, label: {
            Text("Update")
                .frame(width: 200, height: 40, alignment: .center)
                .background(Color.white)
                .cornerRadius(8)
        })
    }
    // 1. delete data from local file
    // 2. copy new data to iCloud (!delete only data, not a file!)
    var deleteButton: some View {
        Button(action: {
            StorageManager.shared.delete()
        }, label: {
            Text("Delete")
                .frame(width: 200, height: 40, alignment: .center)
                .background(Color.white)
                .cornerRadius(8)
        })
    }
    
}

