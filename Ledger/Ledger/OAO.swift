// import SwiftUI
//
// extension View {
//    func color(of value: Int) -> some View {
//        if value > 0 {
//            return self.foregroundColor(.red)
//        } else if value < 0 {
//            return self.foregroundColor(.green)
//        } else {
//            return self.foregroundColor(.primary)
//        }
//    }
// }
//
// struct ContentView: View {
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 12) {
//                ThisPeriodView()
//                    .padding()
//                    .gradientCard()
//
//                VStack {
//                    Text("最近一年收支")
//                        .font(.title)
//
//                    LineChart(
//                        values: [
//                            .init(x: 6, y: 75000),
//                            .init(x: 7, y: 76000),
//                            .init(x: 8, y: 68000),
//                            .init(x: 9, y: 100000),
//                            .init(x: 10, y: 70000)
//                        ],
//                        yValueBase: .zero
//                    )
//                        .frame(height: 300)
//                }
//                    .padding()
//                    .card()
//
//                VStack {
//                    Text("支出比例")
//                        .font(.title)
//
//                    PieChart(values: [(51000, .red), (878, .green), (8000, .blue)])
//                        .frame(height: 300)
//                }
//                    .padding()
//                    .card()
//
//                HStack {
//                    Spacer()
//                    Text("支出明細")
//                        .font(.title)
//                    Spacer()
//                }
//                    .padding()
//                    .card()
//
//                Text("thonk")
//            }
//                .padding()
//        }
//    }
// }
//
// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
// }
//
// struct ThisPeriodView: View {
//    let income: Int = 22000
//    let expense: Int = 500
//    let balance: Int = 8888888
//
//    func signSymbol(of value: Int) -> String {
//        if value > 0 {
//            return "+"
//        } else if value < 0 {
//            return "-"
//        } else {
//            return ""
//        }
//    }
//
//    var body: some View {
//        VStack {
//            Text("本月帳務")
//                .font(.title)
//
//            VStack(alignment: .trailing, spacing: 8) {
//                HStack {
//                    Text("收入")
//                    Spacer()
//                    Text("\(signSymbol(of: income))\(income)")
//                        .font(Font.system(.largeTitle, design: .rounded).weight(.black))
//                        .color(of: income)
//                }
//                HStack {
//                    Text("支出")
//                    Spacer()
//                    Text("\(signSymbol(of: -expense))\(expense)")
//                        .font(Font.system(.largeTitle, design: .rounded).weight(.black))
//                        .color(of: -expense)
//                }
//                Divider()
//                HStack {
//                    Text("結餘")
//                    Spacer()
//                    Text("\(signSymbol(of: income - expense))\(abs(income - expense))")
//                        .font(Font.system(.largeTitle, design: .rounded).weight(.black))
//                        .color(of: income - expense)
//                }
//
//                HStack {
//                    Text("餘額")
//                    Spacer()
//                    Text("\(balance)")
//                        .font(Font.system(.largeTitle, design: .rounded).weight(.black))
//                }
//            }
//        }
//    }
// }
//
// struct LineChart: View {
//    enum YValueBase {
//        case minMax
//        case zero
//    }
//
//    let values: [CGPoint]
//    let yValueBase: YValueBase
//
//    init(values: [CGPoint], yValueBase: YValueBase = .minMax) {
//        self.values = values
//        self.yValueBase = yValueBase
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            Path { path in
//                let minX = values.lazy.map(\.x).min() ?? 0
//                let maxX = values.lazy.map(\.x).max() ?? 0
//                let xRange = maxX - minX
//
//                let minY = values.lazy.map(\.y).min() ?? 0
//                let maxY = values.lazy.map(\.y).max() ?? 0
//                let yRange = maxY - minY
//
//                for (index, value) in values.enumerated() {
//                    let x = geometry.size.width * (value.x - minX) / xRange
//
//                    let y: CGFloat
//                    if yValueBase == .minMax {
//                        y = geometry.size.height * (1 - (value.y - minY) / yRange)
//                    } else {
//                        y = geometry.size.height * (1 - value.y / maxY)
//                    }
//
//                    let point = CGPoint(x: x, y: y)
//
//                    if index == 0 {
//                        path.move(to: point)
//                    } else {
//                        path.addLine(to: point)
//                        path.move(to: point)
//                    }
//                }
//            }
//                .stroke(lineWidth: 1)
//        }
//    }
// }
//
// struct PieChartCell: View {
//    struct ViewModel: Hashable {
//        let startAngle: Angle
//        let endAngle: Angle
//        let color: Color
//    }
//
//    let vm: ViewModel
//
//    var body: some View {
//        GeometryReader { geometry in
//            Path { path in
//                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
//
//                path.addArc(
//                    center: center,
//                    radius: min(geometry.size.width, geometry.size.height) / 2,
//                    startAngle: vm.startAngle,
//                    endAngle: vm.endAngle,
//                    clockwise: false
//                )
//                path.addLine(to: center)
//            }
//                .stroke(lineWidth: 1)
////                .foregroundColor(vm.color)
//        }
//    }
// }
//
// struct PieChart: View {
//    let vms: [PieChartCell.ViewModel]
//
//    init(values: [(value: Int, color: Color)]) {
//        let sum = Double(values.lazy.map(\.value).reduce(0, +))
//        var runningSum: Double = 0
//
//        var vms: [PieChartCell.ViewModel] = []
//        for (value, color) in values {
//            let startAngle = runningSum / sum * 360
//            runningSum += Double(value)
//            let endAngle = runningSum / sum * 360
//            vms.append(.init(startAngle: .degrees(startAngle), endAngle: .degrees(endAngle), color: color))
//        }
//
//        self.vms = vms
//    }
//
//    var body: some View {
//        ZStack {
//            ForEach(vms, id: \.self) { vm in
//                PieChartCell(vm: vm)
//            }
//        }
//    }
// }
