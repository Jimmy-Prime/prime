import SwiftUI
import WidgetKit

struct MonthlyBalance: Widget {
    let kind: String = "MonthlyBalance"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SingleEntryProvider()) { entry in
            MonthlyBalanceView(entry: entry)
        }
            .configurationDisplayName("本月收支")
            .description("本月收支")
            .supportedFamilies([.systemSmall])
    }
}

struct MonthlyBalanceView: View {
    var entry: SingleEntryProvider.Entry

    var body: some View {
        VStack(spacing: 0) {
            Text("2020 十月")
                .font(.system(size: 17, weight: .bold))

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("+\(22000)")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.red)
                Text("-\(500)")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.green)
                Divider()

                Text("+\(21500)")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.red)
            }
        }
            .padding()
            .background(GradientBackground(colors: .widgetFill))
    }
}

struct MonthlyBalanceView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyBalanceView(entry: .instance)
    }
}
