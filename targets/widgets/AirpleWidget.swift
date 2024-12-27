//
//  AirpleWidget.swift
//  Airple Activity
//
//  Created by Revanza on 2024-08-09.
//

import ActivityKit
import SwiftUI
import WidgetKit

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

struct TrackingProgressViewStyle: ProgressViewStyle {
    var height: Double = 4
    var offset: Double = 180

    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0

        GeometryReader { geometry in
            ZStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10.0)
                    .frame(height: height)
                    .frame(width: geometry.size.width)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color("Color"))
                            .frame(width: geometry.size.width * progress)

                    }
                Image("Car").offset(
                    x: ((-geometry.size.width / 2 + geometry.size.width
                        * progress) - 24).clamped(to: -offset...offset))

            }
        }.frame(height: height + 20)
    }
}

@available(iOSApplicationExtension 18.0, *)
struct AirpleActivityViewWithFamily: View {
    let context: ActivityViewContext<AirpleAttributes>
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.activityFamily) var activityFamily

    var body: some View {
        switch activityFamily {
        case .small:
            AirpleActivityViewSmall(context: context)
        case .medium:
            AirpleActivityView(context: context)
        @unknown default:
            AirpleActivityView(context: context)
        }
    }
}

struct AirpleActivityView: View {
    let context: ActivityViewContext<AirpleAttributes>
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(colorScheme == .dark ? "Airple_light" : "Airple")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 14)
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    Text(context.state.status)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(context.state.estimated)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Color"))

                }.padding(.top, 5)
                Text(context.state.title)
                    .font(.subheadline)
            }

            GeometryReader { geometry in
                HStack {
                    ProgressView(value: context.state.progress)
                        .progressViewStyle(
                            TrackingProgressViewStyle(
                                offset: geometry.size.width))
                    Image("Location")
                        .offset(y: -2)
                }
            }
            Spacer()

        }
        .padding(.horizontal)
    }
}

struct AirpleActivityViewSmall: View {
    let context: ActivityViewContext<AirpleAttributes>
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            VStack {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text(context.state.status)
                            .font(.headline)
                            .fontWeight(.semibold)

                        Text(context.state.estimated)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Color"))
                    }

                    Spacer()

                    Image("Car_side")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 2.0)
                        .frame(height: 12)
                }

                ProgressView(value: context.state.progress).tint(Color("Color"))
            }
        }
        .padding(.all)
    }
}

struct AirpleIslandBottom: View {
    let context: ActivityViewContext<AirpleAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading) {
                HStack {
                    Text(context.state.status)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(context.state.estimated)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Color"))

                }.padding(.top, 5)
                Text(context.state.title)
                    .font(.subheadline)
            }
            Spacer()

            GeometryReader { geometry in
                HStack {
                    ProgressView(value: context.state.progress)
                        .progressViewStyle(
                            TrackingProgressViewStyle(
                                offset: geometry.size.width))
                    Image("Location")
                        .offset(y: -2)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

@available(iOSApplicationExtension 18.0, *)
struct AirpleWidgetIOS18: Widget {
    let kind: String = "Airple_Widget"
    @Environment(\.colorScheme) var colorScheme

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AirpleAttributes.self) { context in
            AirpleActivityViewWithFamily(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image("Airple_light")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 14)
                        .padding(.leading)

                }
                DynamicIslandExpandedRegion(.trailing) {
                }
                DynamicIslandExpandedRegion(.bottom) {
                    AirpleIslandBottom(context: context)
                }
            } compactLeading: {
                Image("Airple_light")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 10)
            } compactTrailing: {
                Image("Car")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
            } minimal: {
                Image("Car")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
            }
            .widgetURL(URL(string: context.state.widgetUrl ?? ""))
        }
        .supplementalActivityFamilies([.small, .medium])
    }
}

struct AirpleWidget: Widget {
    let kind: String = "Airple_Widget"
    @Environment(\.colorScheme) var colorScheme

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AirpleAttributes.self) { context in
            AirpleActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image("Airple_light")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 14)
                        .padding(.leading)

                }
                DynamicIslandExpandedRegion(.trailing) {
                }
                DynamicIslandExpandedRegion(.bottom) {
                    AirpleIslandBottom(context: context)
                }
            } compactLeading: {
                Image("Airple_light")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 10)
            } compactTrailing: {
                Image("Car")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
            } minimal: {
                Image("Car")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
            }
            .widgetURL(URL(string: context.state.widgetUrl ?? ""))
        }
    }
}

extension AirpleAttributes {
    fileprivate static var preview: AirpleAttributes {
        AirpleAttributes()
    }
}

extension AirpleAttributes.ContentState {
    fileprivate static var state: AirpleAttributes.ContentState {
        AirpleAttributes.ContentState(
            progress: 0.5, title: "Technician is on the way!",
            status: "Arriving", estimated: "13.30 - 13.40")
    }
}

struct AirpleActivityView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AirpleAttributes.preview
                .previewContext(
                    AirpleAttributes.ContentState.state, viewKind: .content
                )
                .previewDisplayName("Content View")

            AirpleAttributes.preview
                .previewContext(
                    AirpleAttributes.ContentState.state,
                    viewKind: .dynamicIsland(.compact)
                )
                .previewDisplayName("Dynamic Island Compact")

            AirpleAttributes.preview
                .previewContext(
                    AirpleAttributes.ContentState.state,
                    viewKind: .dynamicIsland(.expanded)
                )
                .previewDisplayName("Dynamic Island Expanded")

            AirpleAttributes.preview
                .previewContext(
                    AirpleAttributes.ContentState.state,
                    viewKind: .dynamicIsland(.minimal)
                )
                .previewDisplayName("Dynamic Island Minimal")

            AirpleAttributes.preview
                .previewContext(
                    AirpleAttributes.ContentState.state,
                    viewKind: .dynamicIsland(.minimal)
                )
                .previewDisplayName("Dynamic Island Minimal")
        }
    }
}
