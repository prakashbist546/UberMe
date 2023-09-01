//
//  UberMeApp.swift
//  UberMe
//
//  Created by Prakash Bist on 2023/08/07.
//

import SwiftUI

@main
struct UberMeApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
