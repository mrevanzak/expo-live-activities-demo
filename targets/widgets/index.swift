import SwiftUI
import WidgetKit

@main
struct exportWidgets: WidgetBundle {
    var body: some Widget {
        if #available(iOSApplicationExtension 18.0, *) {
            return iOS18Widgets
        } else {
            return widgets
        }
    }

    @available(iOSApplicationExtension 18.0, *)
    @WidgetBundleBuilder
    private var iOS18Widgets: some Widget {
        AirpleWidgetIOS18()
    }

    @WidgetBundleBuilder
    private var widgets: some Widget {
        AirpleWidget()
    }
}
