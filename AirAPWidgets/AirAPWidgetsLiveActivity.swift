//
//  AirAPWidgetsLiveActivity.swift
//  AirAPWidgets
//
//  Created by neon443 on 22/05/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct AirAPWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct AirAPWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AirAPWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension AirAPWidgetsAttributes {
    fileprivate static var preview: AirAPWidgetsAttributes {
        AirAPWidgetsAttributes(name: "World")
    }
}

extension AirAPWidgetsAttributes.ContentState {
    fileprivate static var smiley: AirAPWidgetsAttributes.ContentState {
        AirAPWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: AirAPWidgetsAttributes.ContentState {
         AirAPWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: AirAPWidgetsAttributes.preview) {
   AirAPWidgetsLiveActivity()
} contentStates: {
    AirAPWidgetsAttributes.ContentState.smiley
    AirAPWidgetsAttributes.ContentState.starEyes
}
