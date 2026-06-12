import SwiftUI

struct StudentListView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var newStudentName = ""
    @State private var isShowingAddSheet = false
    
    var filteredStudents: [Student] {
        if searchText.isEmpty {
            return appState.students
        } else {
            return appState.students.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Buscar por nombre...", text: $searchText)
                        .textFieldStyle(.plain)
                    
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // List / Empty State
                if appState.students.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "person.3.sequence.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.secondary.opacity(0.7))
                        Text("No hay estudiantes registrados")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        Text("Puedes añadir estudiantes manualmente con el botón + o pegando una lista masiva en la pestaña de Configuración.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        
                        Button {
                            isShowingAddSheet = true
                        } label: {
                            Text("Añadir Estudiante")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                } else if filteredStudents.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "person.fill.badge.questionmark")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("Búsqueda sin resultados")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    List {
                        Section(header: Text("Total: \(filteredStudents.count) estudiantes")) {
                            ForEach(filteredStudents) { student in
                                StudentRow(
                                    student: student,
                                    assignedInstrument: appState.instrumentForStudent(student)
                                )
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        appState.deleteStudent(student)
                                    } label: {
                                        Label("Eliminar", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Estudiantes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                NavigationView {
                    Form {
                        Section(header: Text("Información del Alumno")) {
                            TextField("Nombre completo", text: $newStudentName)
                                .disableAutocorrection(true)
                        }
                    }
                    .navigationTitle("Nuevo Estudiante")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancelar") {
                                isShowingAddSheet = false
                                newStudentName = ""
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Añadir") {
                                if !newStudentName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    appState.addStudent(name: newStudentName)
                                    isShowingAddSheet = false
                                    newStudentName = ""
                                }
                            }
                            .disabled(newStudentName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
        }
    }
}
