import SwiftUI

struct InstrumentListView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedInstrumentNumber: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Summary Progress Card
                VStack(spacing: 12) {
                    let totalAssigned = appState.assignments.count
                    let totalInstruments = 13
                    let ratio = Double(totalAssigned) / Double(totalInstruments)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Progreso de Entrega")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.8))
                            Text("\(totalAssigned) de \(totalInstruments) Entregados")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        Text(String(format: "%.0f%%", ratio * 100))
                            .font(.system(.title, design: .rounded))
                            .bold()
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                    }
                    
                    // Custom Progress Bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 8)
                            Capsule()
                                .fill(Color.white)
                                .frame(width: geo.size.width * CGFloat(ratio), height: 8)
                                .animation(.spring(), value: ratio)
                        }
                    }
                    .frame(height: 8)
                }
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .padding()
                .shadow(color: Color.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                
                // Instruments List
                List {
                    ForEach(1...13, id: \.self) { num in
                        Button {
                            selectedInstrumentNumber = num
                        } label: {
                            InstrumentRow(
                                number: num,
                                student: appState.studentForInstrument(num),
                                date: appState.assignmentForInstrument(num)?.date
                            )
                        }
                        .foregroundColor(.primary)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Instrumentos (1-13)")
            .sheet(item: Binding(
                get: { selectedInstrumentNumber.map { IdentifiableInt(val: $0) } },
                set: { selectedInstrumentNumber = $0?.val }
            )) { wrapper in
                AssignInstrumentView(instrumentNumber: wrapper.val)
                    .environmentObject(appState)
            }
        }
    }
}

// Helper struct to allow Binding(item:) on standard Int
struct IdentifiableInt: Identifiable {
    let id = UUID()
    let val: Int
}
