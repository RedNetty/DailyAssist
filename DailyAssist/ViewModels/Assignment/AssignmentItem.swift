    //
    //  File.swift
    //  DailyAssist
    //
    //  Created by Jack Coon on 2/1/24.
    //

    import Foundation

    enum AssignmentCategory: String, Codable, CaseIterable, Hashable {
        case calc = "Calculus"
        case compsci = "Computer Science"
        case mythology = "Mythology"
        case biology = "Biology"
        case macroecon = "Macro-economics"
    }

    struct AssignmentItem: Identifiable, Codable {
        let id: UUID
        var title: String
        var summary: String
        var link: URL
        var dueDate: Date
        var category: AssignmentCategory
        var isCompleted: Bool
    }

