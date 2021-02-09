import SwiftUI
import WidgetKit

@main
struct LedgerBundle: WidgetBundle {
    var body: some Widget {
        MonthlyBalance()
        YearlyReport()
        YearlyBalance()
    }
}

// extension CGRect {
//    init(center: CGPoint, width: CGFloat, height: CGFloat) {
//        self.init(x: center.x - width / 2, y: center.y - height / 2, width: width, height: height)
//    }
// }
//
// struct ChartView: View {
//    let values: [Float] = (1...12).map { _ in Float.random(in: 58000...70000) }
//
//    var body: some View {
//        VStack {
//            HStack {
//                VStack(alignment: .trailing) {
//                    Text("\(Int((max / 1000).rounded()))k")
//
//                    Spacer()
//
//                    if min < 0 {
//                        Text("\(Int((min / 1000).rounded()))k")
//                    } else {
//                        Text("0")
//                    }
//                }
//                    .font(.footnote)
//
//                GeometryReader { geometry in
//                    Path { path in
//                        for (index, value) in values.enumerated() {
//                            let x = geometry.size.width * CGFloat(index) / CGFloat(values.count - 1)
//
//                            let y: CGFloat
//                            if min < 0 {
//                                y = geometry.size.height * (1 - CGFloat((value - min) / (max - min)))
//                            } else {
//                                y = geometry.size.height * (1 - CGFloat(value / max))
//                            }
//
//                            let point = CGPoint(x: x, y: y)
//
//                            if index == 0 {
//                                path.move(to: point)
//                            } else {
//                                path.addLine(to: point)
//                                path.move(to: point)
//                            }
//                        }
//                    }
//                        .stroke(lineWidth: 2)
//
//            ForEach(0 ..< values.count) { index in
//                Circle()
//                    .frame(width: 10)
//                    .position(
//                        x: geometry.size.width * CGFloat(index) / CGFloat(values.count - 1),
//                        y: geometry.size.height * (1 - CGFloat((values[index] - min) / range))
//                    )
//                    .foregroundColor(values[index] > 0 ? .red : (values[index] < 0) ? .green : .black)
//            }
//                }
//            }
//
//            Text("最近一年")
//        }
//            .padding()
//    }
//
//    var min: Float { values.min() ?? 0 }
//    var max: Float { values.max() ?? 0 }
// }
//
// struct Demo2: Widget {
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: "Chart", provider: Provider()) { entry in
//            ChartView()
//        }
//            .configurationDisplayName("近期圖表")
//            .description("最近六個月收支圖表")
//            .supportedFamilies([.systemMedium, .systemLarge])
//    }
// }
//
// struct Demo_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthlyBalanceView(entry: SimpleEntry(date: Date()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
// }
