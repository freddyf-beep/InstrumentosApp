import SwiftUI

struct StudentRow: View {
    let student: Student
    let assignedInstrument: Int?
    
    var body: some View {
        HStack {
            // Avatar / Icon
            ZStack {
                Circle()
                    .fill(Color(uiColor: .systemGray6))
                    .frame(width: 40, height: 40)
                
                Text(String(student.name.prefix(1)).uppercased())
                    .font(.headline)
                    .foregroundColor(.accentColor)
            }
            
            // Name and instrument details
            VStack(alignment: .leading, spacing: 4) {
                Text(student.name)
                    .font(.body.weight(.medium))
                    .foregroundColor(.primary)
                
                if let instrumentNum = assignedInstrument {
                    HStack(spacing: 4) {
                        Image(systemName: "music.note")
                            .font(.caption)
                        Text("Instrumento \(instrumentNum)")
                            .font(.caption.weight(.medium))
                    }
                    .foregroundColor(.orange)
                } else {
                    Text("Sin instrumento asignado")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if assignedInstrument != nil {
                Text("Ocupado")
                    .font(.caption2.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.orange))
            } else {
                Text("Libre")
                    .font(.caption2.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.green))
            }
        }
        .padding(.vertical, 6)
    }
}
