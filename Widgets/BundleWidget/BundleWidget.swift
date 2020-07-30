import SwiftUI
import WidgetKit

@main
struct BundleWidget: WidgetBundle {
    var body: some Widget {
        BlankWidget()
        ClockWidget()
        NoteWidget()
    }
}
