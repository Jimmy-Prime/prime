import SwiftUI

extension CGRect {
    var radius: CGFloat {
        min(width, height) / 2
    }
}

extension CGPoint {
    init(circle: CGRect, angle: Angle) {
        let radian = CGFloat(angle.radians) - .pi / 2

        self.init(
            x: circle.midX + circle.radius * cos(radian),
            y: circle.midY + circle.radius * sin(radian)
        )
    }
}

extension CGSize {
    var short: CGFloat {
        width < height ? width : height
    }
}

struct Rotation: ViewModifier {
    let angle: Angle

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content.position(CGPoint(circle: geometry.frame(in: .local), angle: angle))
        }
    }
}

enum ArmType {
    case minute
    case hour
}

struct Arm: Shape {
    let thickness: CGFloat
    let lengthRatio: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let length = min(rect.width, rect.height) / 2 * lengthRatio
        path.move(to: CGPoint(x: rect.midX + thickness / 2, y: rect.midY))
        path.addLines([
            CGPoint(x: rect.midX + 1, y: rect.midY - length),
            CGPoint(x: rect.midX - 1, y: rect.midY - length),
            CGPoint(x: rect.midX - thickness / 2, y: rect.midY),
            CGPoint(x: rect.midX + thickness / 2, y: rect.midY)
        ])

        return path
    }
}

struct ClockView: View {
    enum Accuracy {
        case twoHands
        case threeHands
    }

    let accuracy: Accuracy
    let date: Date

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                // dots
                ForEach(1...60, id: \.self) { (minute: Int) in
                    Circle()
                        .frame(width: minute % 5 == 0 ? geometry.size.short * 0.03 : geometry.size.short * 0.02)
                        .modifier(Rotation(angle: .degrees(Double(minute) * 6)))
                }

                // numbers
                ForEach(1...12, id: \.self) { (hour: Int) in
                    Text(String(hour))
                        .font(Font.system(size: geometry.size.short * 0.1, weight: .black, design: .rounded))
                        .modifier(Rotation(angle: .degrees(Double(hour) * 30)))
                }
                    .padding(geometry.size.short * 0.1)

                // arms
                ZStack {
                    Arm(thickness: geometry.size.short * 0.04, lengthRatio: 0.55)
                        .rotation(.degrees(degreeOfHour), anchor: .center)
                    Arm(thickness: geometry.size.short * 0.03, lengthRatio: 0.8)
                        .rotation(.degrees(degreeOfMinute), anchor: .center)
                    if accuracy == .threeHands {
                        Arm(thickness: geometry.size.short * 0.02, lengthRatio: 0.9)
                            .rotation(.degrees(degreeOfSecond), anchor: .center)
                            .foregroundColor(.red)
                    }
                    Circle()
                        .frame(width: geometry.size.short * 0.07)
                }
            }
        }
            .padding()
    }

    var components: DateComponents {
        Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
    }

    var second: Double {
        Double(components.second!) + Double(components.nanosecond!) / 1000000000
    }

    var minute: Double {
        Double(components.minute!) + second / 60
    }

    var hour: Double {
        Double(components.hour!) + minute / 60
    }

    var degreeOfSecond: Double {
        second * 6
    }

    var degreeOfMinute: Double {
        minute * 6
    }

    var degreeOfHour: Double {
        hour * 30
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ClockView(accuracy: .twoHands, date: Date())
                .previewLayout(.fixed(width: 300, height: 300))
            ClockView(accuracy: .threeHands, date: Date())
                .previewLayout(.fixed(width: 300, height: 300))
        }
    }
}
