import Charts
import UIKit

class WeatherChartRenderer: LineChartRenderer {
    private let dateFormatter = DateFormatter()

    override func drawValues(context: CGContext) {
        guard let dataProvider = dataProvider,
              let lineData = dataProvider.lineData,
              let dataSet = lineData.dataSets.first else { return }

        guard isDrawingValuesAllowed(dataProvider: dataProvider) else { return }

        var lastEntryDate: Date?
        for index in 0..<dataSet.entryCount {
            guard let entry = dataSet.entryForIndex(index) else { continue }

            let timeString: String
            let currentEntryDate = Date(timeIntervalSince1970: entry.x)
            if let lastEntryDate = lastEntryDate, Calendar.current.isDate(currentEntryDate, inSameDayAs: lastEntryDate) {
                dateFormatter.dateFormat = "HH"
                timeString = dateFormatter.string(from: currentEntryDate)
            } else {
                dateFormatter.dateFormat = "MMdd"
                timeString = dateFormatter.string(from: currentEntryDate)
            }
            lastEntryDate = Date(timeIntervalSince1970: entry.x)

            UIGraphicsPushContext(context)

            let transform = dataProvider.getTransformer(forAxis: dataSet.axisDependency).valueToPixelMatrix
            let point = CGPoint(x: entry.x, y: entry.y).applying(transform)

            let valueAttributedString = NSAttributedString(
                string: "\(Int(entry.y.rounded()))",
                attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.white]
            )

            let valueSize = valueAttributedString.size()
            let valuePoint = CGPoint(x: point.x - valueSize.width / 2, y: point.y)
            valueAttributedString.draw(at: valuePoint)

            let timeAttributedString = NSAttributedString(
                string: timeString,
                attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.secondaryLabel]
            )

            let timeSize = timeAttributedString.size()
            let timePoint = CGPoint(x: point.x - timeSize.width / 2, y: point.y + valueSize.height)
            timeAttributedString.draw(at: timePoint)

            UIGraphicsPopContext()
        }
    }
}

class WeatherItem: UIView, GridItemView {
    var area: GridArea = .init(origin: .init(x: 0, y: 0), size: .init(x: 4, y: 2))

    var settings: Settings.Section {
        .init(
            title: "WeatherItem",
            items: [
                .text(title: "Weather", detail: "WeatherItem Detail")
            ]
        )
    }

    let label = UILabel()
    let chart = LineChartView()

    func initialize() {
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "新北市 板橋區"

        let defaultRenderer = chart.renderer
        chart.renderer = WeatherChartRenderer(dataProvider: chart, animator: defaultRenderer!.animator, viewPortHandler: defaultRenderer!.viewPortHandler)

        chart.minOffset = 0

        chart.setScaleEnabled(false)
        chart.legend.enabled = false

        for axis in [chart.leftAxis, chart.rightAxis, chart.xAxis] {
            axis.drawAxisLineEnabled = false
            axis.drawGridLinesEnabled = false
            axis.drawLabelsEnabled = false
        }

        chart.leftAxis.axisMinimum = 0
        chart.rightAxis.axisMinimum = 0

        let stackView = UIStackView(arrangedSubviews: [label, chart])
        stackView.axis = .vertical
        stackView.spacing = 20
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func set(weather: [Weather]) {
        let entries = weather.map { ChartDataEntry(x: $0.time.timeIntervalSince1970, y: $0.value) }
        let dataSet = LineChartDataSet(entries: entries)

        dataSet.mode = .cubicBezier

        dataSet.lineWidth = 0

        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false

        let colors: [UIColor] = [.systemRed, .black]
        let gradient = CGGradient(colorsSpace: nil, colors: colors.map(\.cgColor) as CFArray, locations: nil)
        dataSet.fill = Fill(linearGradient: gradient!, angle: -90)
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true

        chart.data = LineChartData(dataSet: dataSet)
    }
}

struct Weather {
    let value: Double
    let time: Date

    static func adapter(_ item: Any) -> Weather {
        if let item = item as? CWBRequest.Response.Time,
           let valueText = item.elementValue.first?.value,
           let value = Double(valueText) {
            return Weather(value: value, time: item.dataTime)
        } else {
            return Weather(value: 0, time: Date())
        }
    }
}
