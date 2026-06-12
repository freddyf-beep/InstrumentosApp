import Foundation
import Combine

class AppState: ObservableObject {
    @Published var students: [Student] = [] {
        didSet {
            saveStudents()
        }
    }
    
    @Published var assignments: [Assignment] = [] {
        didSet {
            saveAssignments()
        }
    }
    
    private let studentsKey = "saved_students"
    private let assignmentsKey = "saved_assignments"
    
    init() {
        loadStudents()
        loadAssignments()
        
        // If empty, load default demo students
        if students.isEmpty {
            loadDefaultStudents()
        }
    }
    
    // MARK: - Data Persistence
    
    private func saveStudents() {
        if let encoded = try? JSONEncoder().encode(students) {
            UserDefaults.standard.set(encoded, forKey: studentsKey)
        }
    }
    
    private func loadStudents() {
        if let data = UserDefaults.standard.data(forKey: studentsKey),
           let decoded = try? JSONDecoder().decode([Student].self, from: data) {
            self.students = decoded
        }
    }
    
    private func saveAssignments() {
        if let encoded = try? JSONEncoder().encode(assignments) {
            UserDefaults.standard.set(encoded, forKey: assignmentsKey)
        }
    }
    
    private func loadAssignments() {
        if let data = UserDefaults.standard.data(forKey: assignmentsKey),
           let decoded = try? JSONDecoder().decode([Assignment].self, from: data) {
            self.assignments = decoded
        }
    }
    
    private func loadDefaultStudents() {
        let defaults = [
            "Abigail Godoy",
            "Aracely Barria",
            "Benjamín Flores",
            "Cristobal Guitierrez",
            "Lucia Barria",
            "Maite Gallegos",
            "Mia Alvares",
            "Rafaela Escobar",
            "Carlos Toledo",
            "Esperanza Coñapi",
            "Gael Herrera",
            "Ignacia Leal",
            "Moises Jaiña",
            "Samira Levican",
            "Sofia Leuquen",
            "Alonso Oyarzo",
            "Bejamin Perez",
            "Daimar Romero",
            "Daryel Ruiz",
            "Isabella Muñoz",
            "Leonor Turra",
            "Pia Zuñiga",
            "Franco Cardenas",
            "Javier Pardo",
            "Jaster Matus",
            "Lucas Muñoz"
        ]
        self.students = defaults.map { Student(name: $0) }.sorted { $0.name < $1.name }
    }
    
    // MARK: - Operations
    
    func addStudent(name: String) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }
        
        // Avoid duplicate names for clarity
        if !students.contains(where: { $0.name.lowercased() == cleanName.lowercased() }) {
            let newStudent = Student(name: cleanName)
            students.append(newStudent)
            students.sort { $0.name < $1.name }
        }
    }
    
    func deleteStudent(_ student: Student) {
        // 1. Remove student from list
        students.removeAll { $0.id == student.id }
        
        // 2. Remove any assignment associated with this student
        assignments.removeAll { $0.studentId == student.id }
    }
    
    func assign(instrumentNumber: Int, to student: Student) {
        // 1. Remove any existing assignment for this specific instrument
        assignments.removeAll { $0.instrumentNumber == instrumentNumber }
        
        // 2. Remove any previous assignment of this student to OTHER instruments
        // (Ensuring one instrument per student rule, which is standard for school assignments)
        assignments.removeAll { $0.studentId == student.id }
        
        // 3. Add the new assignment
        let newAssignment = Assignment(instrumentNumber: instrumentNumber, studentId: student.id)
        assignments.append(newAssignment)
    }
    
    func unassign(instrumentNumber: Int) {
        assignments.removeAll { $0.instrumentNumber == instrumentNumber }
    }
    
    func studentForInstrument(_ number: Int) -> Student? {
        guard let assignment = assignments.first(where: { $0.instrumentNumber == number }) else {
            return nil
        }
        return students.first(where: { $0.id == assignment.studentId })
    }
    
    func assignmentForInstrument(_ number: Int) -> Assignment? {
        return assignments.first(where: { $0.instrumentNumber == number })
    }
    
    func instrumentForStudent(_ student: Student) -> Int? {
        return assignments.first(where: { $0.studentId == student.id })?.instrumentNumber
    }
    
    // MARK: - Import / Export
    
    func importStudents(from text: String) {
        let lines = text.components(separatedBy: .newlines)
        var addedAny = false
        
        for line in lines {
            let clean = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if !clean.isEmpty {
                if !students.contains(where: { $0.name.lowercased() == clean.lowercased() }) {
                    students.append(Student(name: clean))
                    addedAny = true
                }
            }
        }
        
        if addedAny {
            students.sort { $0.name < $1.name }
        }
    }
    
    func exportAssignmentsText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        var report = "📝 CONTROL DE INSTRUMENTOS\n"
        report += "Fecha: \(dateFormatter.string(from: Date()))\n"
        report += "--------------------------------------\n\n"
        
        for num in 1...13 {
            if let student = studentForInstrument(num),
               let assignment = assignmentForInstrument(num) {
                let dateStr = dateFormatter.string(from: assignment.date)
                report += "📯 Instrumento \(num): \(student.name) (Entregado: \(dateStr))\n"
            } else {
                report += "📯 Instrumento \(num): DISPONIBLE 🟢\n"
            }
        }
        
        let totalAssigned = assignments.count
        report += "\n--------------------------------------\n"
        report += "Resumen: \(totalAssigned) asignados, \(13 - totalAssigned) disponibles."
        
        return report
    }
    
    func resetAssignments() {
        assignments.removeAll()
    }
    
    func resetAllData() {
        assignments.removeAll()
        students.removeAll()
        loadDefaultStudents()
    }
}
