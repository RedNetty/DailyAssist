//
//  NewsItem.swift
//  DailyAssist
//
//  Created by Jack Coon on 1/31/24.
//

import Foundation
import SwiftUI


struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let feedTitle: String
    let summary: String
    let source: String
    let link: URL
    let date: Date
    let category: String // New property for category
}

