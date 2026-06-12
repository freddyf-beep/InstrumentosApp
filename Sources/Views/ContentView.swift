import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            InstrumentListView()
                .tabItem {
                    Label("Instrumentos", systemImage: "music.note.house.fill")
                }
                .tag(0)
            
            StudentListView()
                .tabItem {
                    Label("Estudiantes", systemImage: "person.3.sequence.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Configuración", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
        .accentColor(.indigo) // High premium default accent color
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
