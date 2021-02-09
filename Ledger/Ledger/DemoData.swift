import Foundation

let tags: [String] = ["🍱 吃", "🚃 交通", "🔌 繳費", "💸 墮手", "🔞 不好說"]

func filteredTags(by keyword: String) -> [String] {
    if keyword.isEmpty {
        return tags
    } else {
        return tags.filter { $0.contains(keyword) }
    }
}
