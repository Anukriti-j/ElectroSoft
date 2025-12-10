import SwiftUI

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        return path
    }
}

struct PieChartView: View {
    let data: [RoleData]

    private var total: Double {
        data.reduce(0) { $0 + $1.value }
    }

    private var slices: [(data: RoleData, start: Double, end: Double)] {
        var start = 0.0
        return data.map { item in
            let angle = item.value / total * 360
            let slice = (item, start, start + angle)
            start += angle
            return slice
        }
    }

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)

            ZStack {
                ForEach(slices, id: \.data.id) { slice in
                    let midAngle = (slice.start + slice.end) / 2
                    let labelRadius = size / 2.2
                    let lineRadius = size / 2

                    let x = center.x + cos(midAngle * .pi / 180) * labelRadius
                    let y = center.y + sin(midAngle * .pi / 180) * labelRadius

                    let lineX = center.x + cos(midAngle * .pi / 180) * lineRadius
                    let lineY = center.y + sin(midAngle * .pi / 180) * lineRadius

                    // Slice
                    PieSlice(
                        startAngle: .degrees(slice.start),
                        endAngle: .degrees(slice.end)
                    )
                    .fill(randomColor(for: slice.data.name))

                    // Line
                    Path { path in
                        path.move(to: center)
                        path.addLine(to: CGPoint(x: lineX, y: lineY))
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    .stroke(Color.gray, lineWidth: 1)

                    // Label
                    Text("\(slice.data.name)\n\(Int(slice.data.value))")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .position(x: x, y: y)
                }
            }
            .frame(width: size, height: size)
        }
    }

    func randomColor(for name: String) -> Color {
        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow]
        return colors[abs(name.hashValue) % colors.count]
    }
}
