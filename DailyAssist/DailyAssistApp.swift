//
//  DailyAssistApp.swift
//  DailyAssist
//
//  Created by Jack Coon on 1/31/24.
//

import SwiftUI

@main
struct DailyAssistApp: App {
    @StateObject private var viewModel = AssignmentViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel) // Make sure this line is present
        }
    }

}
