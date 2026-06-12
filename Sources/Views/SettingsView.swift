import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var rawImportText = ""
    @State private var showingImportAlert = false
    @State private var importedCount = 0
    
    @State private var showingExportSheet = false
    @State private var showingCopiedAlert = false
    
    @State private var showingResetAssignmentsAlert = false
    @State private var showingResetAllAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // Section 1: Import Students
                Section(
                    header: Text("Importar Estudiantes (Carga Masiva)"),
                    footer: Text("Pega una lista de nombres de alumnos (un nombre por línea) y presiona Importar para agregarlos todos juntos sin duplicar.")
                ) {
                    TextEditor(text: $rawImportText)
                        .frame(height: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(.systemGray4), lineWidth: 0.5)
                        )
                        .padding(.vertical, 4)
                    
                    Button {
                        runImport()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Importar Estudiantes", systemImage: "person.3.fill")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(rawImportText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                
                // Section 2: Export Assignments
                Section(header: Text("Compartir / Exportar Asignaciones")) {
                    Button {
                        showingExportSheet = true
                    } label: {
                        Label {
                            Text("Generar y Copiar Reporte")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                
                // Section 3: Database Reset / Clean up
                Section(header: Text("Peligro y Reinicio")) {
                    Button(role: .destructive) {
                        showingResetAssignmentsAlert = true
                    } label: {
                        Label("Liberar todos los instrumentos", systemImage: "arrow.counterclockwise.circle")
                    }
                    
                    Button(role: .destructive) {
                        showingResetAllAlert = true
                    } label: {
                        Label("Restablecer toda la base de datos", systemImage: "trash.circle")
                    }
                }
            }
            .navigationTitle("Configuración")
            // Alert for successful import
            .alert("Importación Completada", isPresented: $showingImportAlert) {
                Button("Entendido", role: .cancel) { }
            } message: {
                Text("Se han analizado los nombres y se agregaron \(importedCount) nuevos estudiantes.")
            }
            // Alert for resetting assignments
            .alert("¿Liberar todos los instrumentos?", isPresented: $showingResetAssignmentsAlert) {
                Button("Liberar Todos", role: .destructive) {
                    appState.resetAssignments()
                }
                Button("Cancelar", role: .cancel) { }
            } message: {
                Text("Esta acción desasignará todos los instrumentos del 1 al 13, pero mantendrá la lista de estudiantes intacta.")
            }
            // Alert for resetting all database
            .alert("¿Restablecer Aplicación?", isPresented: $showingResetAllAlert) {
                Button("Restablecer Todo", role: .destructive) {
                    appState.resetAllData()
                }
                Button("Cancelar", role: .cancel) { }
            } message: {
                Text("Se borrarán todas las asignaciones y todos los estudiantes actuales. Se cargará la lista de estudiantes de ejemplo por defecto.")
            }
            // Export Preview Sheet
            .sheet(isPresented: $showingExportSheet) {
                ExportPreviewView(reportText: appState.exportAssignmentsText())
            }
        }
    }
    
    private func runImport() {
        let cleanText = rawImportText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else { return }
        
        // Count how many we had before
        let countBefore = appState.students.count
        appState.importStudents(from: cleanText)
        let countAfter = appState.students.count
        
        importedCount = countAfter - countBefore
        rawImportText = ""
        showingImportAlert = true
    }
}

// A helper preview sheet that shows the formatted report and copy to clipboard button
struct ExportPreviewView: View {
    let reportText: String
    @Environment(\.dismiss) var dismiss
    @State private var copied = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Vista Previa del Reporte")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                
                ScrollView {
                    Text(reportText)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Button {
                    UIPasteboard.general.string = reportText
                    copied = true
                    // Visual feedback
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        copied = false
                        dismiss()
                    }
                } label: {
                    HStack {
                        Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc.fill")
                        Text(copied ? "¡Copiado!" : "Copiar al Portapapeles")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(copied ? Color.green : Color.accentColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Exportar Datos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}
