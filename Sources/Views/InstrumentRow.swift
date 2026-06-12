import SwiftUI

struct InstrumentRow: View {
    let number: Int
    let student: Student?
    let date: Date?
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon / Number Badge
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: student == nil ? [.green, .emerald] : [.orange, .amber]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .shadow(color: (student == nil ? Color.green : Color.orange).opacity(0.3), radius: 4, x: 0, y: 2)
                
                Text("\(number)")
                    .font(.system(.title3, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
            }
            
            // Text Details
            VStack(alignment: .leading, spacing: 4) {
                Text("Instrumento \(number)")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let student = student {
                    Text(student.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.amberDark)
                    
                    if let date = date {
                        Text(formattedDate(date))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("Disponible")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Action indicator badge
            if student != nil {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.orange)
                    .font(.title3)
            } else {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return "Asignado: " + formatter.string(from: date)
    }
}

// Custom Colors Helper to make UI feel premium
extension Color {
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
    static let amber = Color(red: 245/255, green: 158/255, blue: 11/255)
    static let amberDark = Color(red: 217/255, green: 119/255, blue: 6/255)
}
