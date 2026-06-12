import Foundation

struct Assignment: Identifiable, Codable, Hashable {
    let id: UUID
    let instrumentNumber: Int
    let studentId: UUID
    let date: Date
    
    init(id: UUID = UUID(), instrumentNumber: Int, studentId: UUID, date: Date = Date()) {
        self.id = id
        self.instrumentNumber = instrumentNumber
        self.studentId = studentId
        self.date = date
    }
}
