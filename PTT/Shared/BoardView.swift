import SwiftUI

struct Board: Identifiable {
    let name: String
    let banner: String

    var id: String { name }
}

struct BoardView: View {
    let board: Board

    var body: some View {
        VStack(alignment: .leading) {
            Text(board.name)
                .font(.headline)
            Text(board.banner)
                .font(.footnote)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(
            board: Board(
                name: "Board Name",
                banner: "Board Banner Text"
            )
        )
            .previewLayout(.sizeThatFits)
    }
}
