import UIKit

class SettingsViewController: UITableViewController {
    private let settings: Settings

    init(settings: Settings) {
        self.settings = settings

        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.sections[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

        let item = settings.sections[indexPath.section].items[indexPath.row]
        switch item {
        case let .text(title, detail, hasNextPage):
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = detail
            cell.accessoryType = hasNextPage ? .disclosureIndicator : .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        settings.sections[section].title
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        show(GridLayoutSettingsViewController(), sender: self)
    }
}
