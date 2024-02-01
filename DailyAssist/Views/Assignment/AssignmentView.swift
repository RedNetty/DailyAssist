import SwiftUI

struct AssignmentView: View {
    @EnvironmentObject var viewModel: AssignmentViewModel
    @State private var showingAddAssignment = false
    @State private var selectedCategory: AssignmentCategory? = nil

    var body: some View {
        NavigationView {
            Sidebar(selectedCategory: $selectedCategory)
                .frame(minWidth: 200, idealWidth: 250, maxWidth: 300, maxHeight: .infinity)
                .padding(.vertical, 10)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .leading, endPoint: .trailing))
            
            List(filteredAssignments) { assignment in
                NavigationLink(destination: AssignmentDetailView(assignment: assignment)) {
                    AssignmentRow(assignment: assignment)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(NSColor.textBackgroundColor).opacity(0.1))
        }
        .frame(minWidth: 800, minHeight: 600)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showingAddAssignment = true
                }) {
                    Image(systemName: "plus")
                }
                .help("Add New Assignment")
            }
        }
        .sheet(isPresented: $showingAddAssignment) {
            AddAssignmentView(viewModel: _viewModel)
        }
    }

    private var filteredAssignments: [AssignmentItem] {
        guard let selectedCategory = selectedCategory else {
            return viewModel.assignments.sorted { $0.dueDate < $1.dueDate }
        }
        return viewModel.assignments.filter { $0.category == selectedCategory }
            .sorted { $0.dueDate < $1.dueDate }
    }
}

struct Sidebar: View {
    @Binding var selectedCategory: AssignmentCategory?
    @EnvironmentObject var viewModel: AssignmentViewModel

    var body: some View {
        List {
            ForEach(AssignmentCategory.allCases, id: \.self) { category in
                Button(action: {
                    if selectedCategory == category {
                        selectedCategory = nil
                    } else {
                        selectedCategory = category
                    }
                }) {
                    Text(category.rawValue)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(selectedCategory == category ? Color.purple : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .listStyle(SidebarListStyle())
        .background(Color.blue.opacity(0.1))
    }
}

struct AssignmentDetailView: View {
    let assignment: AssignmentItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(assignment.title)
                .font(.title)
            Text(assignment.summary)
                .font(.body)
            Link("Open Link", destination: assignment.link)
                .font(.headline)
            Text("Due Date: \(assignment.dueDate, style: .date)")
                .font(.subheadline)
            Spacer()
        }
        .padding()
        .navigationTitle(assignment.title)
    }
}
struct AssignmentRow: View {
    @EnvironmentObject var viewModel: AssignmentViewModel
    @State private var isHovering = false

    var assignment: AssignmentItem

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(assignment.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Text("Summary: \(assignment.summary)")
                        .font(.caption)
                        .lineLimit(2)
                        .truncationMode(.tail)
                    
                    Text("Class: \(assignment.category.rawValue)")
                        .font(.subheadline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .foregroundColor(.primary)

                Spacer()

                VStack {
                    Text("Due: \(assignment.dueDate, style: .date)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)

            Button(action: {
                viewModel.toggleCompletion(for: assignment.id)
            }) {
                Text(assignment.isCompleted ? "Completed" : "Mark as Completed")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isHovering ?
                        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]), startPoint: .leading, endPoint: .trailing) :
                        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.25), Color.purple.opacity(0.25)]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .onHover { hovering in
                isHovering = hovering
            }
        }
        .frame(minHeight: 120)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
