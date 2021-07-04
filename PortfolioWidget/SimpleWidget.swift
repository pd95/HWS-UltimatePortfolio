//
//  SimpleWidget.swift
//  PortfolioWidgetExtension
//
//  Created by Philipp on 04.07.21.
//

import SwiftUI
import WidgetKit

struct PortfolioWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        VStack {
            Text("Up next…")
                .font(.title)

            if let item = entry.items.first {
                Text(item.itemTitle)
            } else {
                Text("Nothing!")
            }
        }
    }
}

struct SimplePortfolioWidget: Widget {
    let kind: String = "SimplePortfolioWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PortfolioWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Up next…")
        .description("Your #1 top-priority item.")
        .supportedFamilies([.systemSmall])
    }
}

struct SimplePortfolioWidget_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioWidgetEntryView(entry: .example)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
