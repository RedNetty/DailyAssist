import Foundation
import SwiftUI

class AssignmentViewModel: ObservableObject, Observable {
    @Published var assignments: [AssignmentItem] = []

    private let saveKey = "SavedAssignments"

    init() {
        loadAssignments()
    }

    func addAssignment(_ assignment: AssignmentItem) {
        DispatchQueue.main.async {
            self.assignments.append(assignment)
            self.saveAssignments()
        }
    }

    func deleteAssignment(at offsets: IndexSet) {
        DispatchQueue.main.async {
            self.assignments.remove(atOffsets: offsets)
            self.saveAssignments()
        }
    }

    func toggleCompletion(for assignmentId: UUID) {
        if let index = self.assignments.firstIndex(where: { $0.id == assignmentId }) {
            DispatchQueue.main.async {
                self.assignments[index].isCompleted.toggle()
                self.saveAssignments()
            }
        }
    }
    
    private func loadAssignments() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        do {
            self.assignments = try JSONDecoder().decode([AssignmentItem].self, from: data)
        } catch {
            print("Unable to load assignments: \(error)")
        }
    }

    private func saveAssignments() {
        do {
            let data = try JSONEncoder().encode(self.assignments)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Unable to save assignments: \(error)")
        }
    }
}
