//
//  AddAssignmentView.swift
//  DailyAssist
//
//  Created by Jack Coon on 2/1/24.
//

import Foundation
import SwiftUI


struct AddAssignmentView: View {
    @EnvironmentObject var viewModel: AssignmentViewModel // Make sure to use @EnvironmentObject here
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var summary: String = ""
    @State private var linkString: String = ""
    @State private var dueDate: Date = Date()
    @State private var category: AssignmentCategory = .compsci
    @State private var isCompleted: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    TextField("Summary", text: $summary)
                    TextField("Link", text: $linkString)
                }
                
                Section(header: Text("Category & Date")) {
                    Picker("Category", selection: $category) {
                        ForEach(AssignmentCategory.allCases, id: \.self) { category in
                            Text(category.rawValue)
                        }
                    }
                    DatePicker("Due Date", selection: $dueDate)
                }
                
                Toggle("Completed", isOn: $isCompleted)
            }
            .padding()
            
            HStack {
                Button("Cancel", action: { dismiss() })
                Button("Add", action: addNewAssignment)
            }
            .padding()
        }
        .padding()
        .frame(width: 400, height: 500)
        .navigationTitle("Add New Assignment")
    }

    private func addNewAssignment() {
        guard let url = URL(string: linkString), !title.isEmpty, !summary.isEmpty else { return }
        let newAssignment = AssignmentItem(id: UUID(), title: title, summary: summary, link: url, dueDate: dueDate, category: category, isCompleted: isCompleted)
        viewModel.addAssignment(newAssignment)
        dismiss()
    }
}
