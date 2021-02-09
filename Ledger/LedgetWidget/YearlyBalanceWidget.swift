import SwiftUI
import WidgetKit

struct YearlyBalance: Widget {
    let kind: String = "YearlyBalance"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SingleEntryProvider()) { entry in
            YearlyBalanceView(entry: entry)
        }
            .configurationDisplayName("年度收支")
            .description("年度收支")
            .supportedFamilies([.systemLarge])
    }
}

struct YearlyBalanceView: View {
    var entry: SingleEntryProvider.Entry

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("2020")
                    .font(.system(size: 36, weight: .black, design: .rounded))

                Spacer()

                VStack(alignment: .trailing, spacing: 0) {
                    Text("+\(22000)")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.red)
                    Text("-\(500)")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.green)
                    Text("+\(21500)")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.red)
                }
            }

            Spacer()

            VStack {
                randomChart(color: .red, alignment: .bottom)
                randomChart(color: .green, alignment: .top)
                randomChart(color: .red, alignment: .bottom)
            }
        }
            .padding()
            .background(GradientBackground(colors: .widgetFill))
    }

    func randomChart(color: Color, alignment: VerticalAlignment) -> some View {
        HStack(alignment: alignment, spacing: 4) {
            ForEach(0..<12) { _ in
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(color)
                    .frame(height: CGFloat.random(in: 8...64))
            }
        }
            .frame(height: 64)
    }
}

struct YearlyBalanceView_Previews: PreviewProvider {
    static var previews: some View {
        YearlyBalanceView(entry: .instance)
    }
}
