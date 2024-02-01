import SwiftUI


struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: TodaysNewsView()) {
                             Label("Today's News", systemImage: "newspaper")
                }
                NavigationLink(destination: AssignmentsView()) {
                    Label("Assignments", systemImage: "text.badge.checkmark")
                }
                NavigationLink(destination: SavedFilesView()) {
                    Label("Saved Files", systemImage: "folder")
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar) {
                        Label("Toggle Sidebar", systemImage: "sidebar.left")
                    }
                }
            }

            Text("Select an item")
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

// Placeholder Views for Navigation

struct AssignmentsView: View {
    var body: some View {
        Text("Assignments Content")
    }
}

struct SavedFilesView: View {
    var body: some View {
        Text("Saved Files Content")
    }
}
