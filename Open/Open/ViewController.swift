import UIKit

class ViewController: UIViewController {
    private let grid = GridView()

    private let weatherItem = WeatherItem()

    private let photoItem = PhotoItem()

    private let newsItem = NewsItem(frame: .zero, style: .plain)
    private var newsDataSource: NewsAPIDataSource!

    private let settingsButton = SettingsButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsButton.frame = CGRect(x: view.bounds.width - 8, y: 0, width: 8, height: view.bounds.height)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .primaryActionTriggered)
        view.addSubview(settingsButton)

        grid.index = .init(x: 7, y: 4)
        grid.itemInset = .init(top: 9, left: 16, bottom: 9, right: 16)
        view.addSubview(grid)
        grid.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            grid.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            grid.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            grid.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            grid.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        grid.add(item: weatherItem)
        weatherItem.initialize()

        grid.add(item: photoItem)
        photoItem.initialize()

        newsDataSource = .init(tableView: newsItem, cellProvider: newsCellProvider)
        grid.add(item: newsItem)

        fetchAll()
    }

    private func fetchAll() {
        URLSession.shared.send(CWBRequest()) { (result) in
            guard case let .success(response) = result else { return }

            guard let city = response.records.locations.first,
                  let district = city.location.first,
                  let records = district.weatherElement.first?.time else { return }

            DispatchQueue.main.async {
                self.weatherItem.set(weather: records.map(Weather.adapter))
            }
        }

        photoItem.fetchPhotos()

//        newsDataSource.fetch()
    }

    func newsCellProvider(tableView: UITableView, indexPath: IndexPath, item: News) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitle") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")

        cell.selectionStyle = .none

        cell.textLabel?.text = item.title
        cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = item.description
        cell.detailTextLabel?.font = .preferredFont(forTextStyle: .footnote)
        cell.detailTextLabel?.numberOfLines = 0

        return cell
    }

    @objc
    private func settingsButtonTapped() {
        let settings = grid.generateSettings()
        let vc = SettingsViewController(settings: settings)
        show(vc, sender: self)
    }
}
