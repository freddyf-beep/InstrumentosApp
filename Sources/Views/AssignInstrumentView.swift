import SwiftUI

struct AssignInstrumentView: View {
    let instrumentNumber: Int
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    @State private var searchText = ""
    @State private var studentToReassign: Student? = nil
    @State private var showReassignAlert = false
    
    var filteredStudents: [Student] {
        if searchText.isEmpty {
            return appState.students
        } else {
            return appState.students.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var currentAssignedStudent: Student? {
        appState.studentForInstrument(instrumentNumber)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with current status
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Instrumento \(instrumentNumber)")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        
                        // Status Badge
                        Text(currentAssignedStudent == nil ? "Disponible" : "Asignado")
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(currentAssignedStudent == nil ? Color.green : Color.orange)
                            )
                    }
                    
                    if let currentStudent = currentAssignedStudent {
                        HStack {
                            Text("En posesión de: ")
                                .foregroundColor(.secondary)
                            Text(currentStudent.name)
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(role: .destructive) {
                                appState.unassign(instrumentNumber: instrumentNumber)
                                dismiss()
                            } label: {
                                Label("Liberar", systemImage: "xmark.circle")
                                    .font(.body.weight(.bold))
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                            .tint(.red)
                        }
                        .padding()
                        .background(Color(uiColor: .systemGray6))
                        .cornerRadius(12)
                    } else {
                        Text("Selecciona un estudiante de la lista de abajo para entregarle este instrumento.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 4)
                    }
                }
                .padding()
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Buscar estudiante...", text: $searchText)
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
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                // Students List
                if filteredStudents.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "person.crop.circle.badge.questionmark")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("No se encontraron estudiantes")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Puedes agregar estudiantes en la pestaña 'Estudiantes' o comprobar la búsqueda.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        Spacer()
                    }
                } else {
                    List {
                        Section(header: Text("Listado de Estudiantes")) {
                            ForEach(filteredStudents) { student in
                                Button {
                                    selectStudent(student)
                                } label: {
                                    HStack {
                                        StudentRow(
                                            student: student,
                                            assignedInstrument: appState.instrumentForStudent(student)
                                        )
                                        
                                        Spacer()
                                        
                                        // Highlight current assignment
                                        if currentAssignedStudent?.id == student.id {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.accentColor)
                                                .font(.body.weight(.bold))
                                        }
                                    }
                                }
                                .foregroundColor(.primary)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Asignar Instrumento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .alert("Confirmar Reasignación", isPresented: $showReassignAlert, presenting: studentToReassign) { student in
                Button("Reasignar", role: .destructive) {
                    appState.assign(instrumentNumber: instrumentNumber, to: student)
                    dismiss()
                }
                Button("Cancelar", role: .cancel) {}
            } message: { student in
                if let oldInstrument = appState.instrumentForStudent(student) {
                    Text("\(student.name) ya tiene asignado el Instrumento \(oldInstrument). ¿Deseas quitárselo de ese instrumento y asignarle el Instrumento \(instrumentNumber)?")
                } else {
                    Text("¿Deseas asignar el Instrumento \(instrumentNumber) a \(student.name)?")
                }
            }
        }
    }
    
    private func selectStudent(_ student: Student) {
        // If the student is already assigned to THIS instrument, just close the sheet
        if currentAssignedStudent?.id == student.id {
            dismiss()
            return
        }
        
        // Check if the student has another instrument
        if let _ = appState.instrumentForStudent(student) {
            studentToReassign = student
            showReassignAlert = true
        } else {
            // Direct assignment
            appState.assign(instrumentNumber: instrumentNumber, to: student)
            dismiss()
        }
    }
}
