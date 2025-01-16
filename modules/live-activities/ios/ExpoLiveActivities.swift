import ActivityKit
import ExpoModulesCore

let pushTokenDidChange: String =
    "LiveActivities.pushTokenDidChange"
let startTokenDidChange: String =
    "LiveActivities.startTokenDidChange"

public class ExpoLiveActivities: Module {
    let logger = Logger(logHandlers: [
        createOSLogHandler(category: Logger.EXPO_LOG_CATEGORY)
    ])

    // Each module class must implement the definition function. The definition consists of components
    // that describes the module's functionality and behavior.
    // See https://docs.expo.dev/modules/module-api for more details about available components.
    public func definition() -> ModuleDefinition {
        // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
        // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
        // The module will be accessible from `requireNativeModule('ExpoLiveActivities')` in JavaScript.
        Name("ExpoLiveActivities")

        Events(pushTokenDidChange, startTokenDidChange)

        Function("areActivitiesEnabled") { () -> Bool in
            logger.info("areActivitiesEnabled()")

            if #available(iOS 16.2, *) {
                return ActivityAuthorizationInfo().areActivitiesEnabled
            } else {
                return false
            }
        }

        Function("startActivity") {
            (
                key: String, progress: Double, title: String, status: String,
                estimated: String, widgetUrl: String?
            ) throws -> Void in
            try handleActivity(
                action: .start,
                key: key,
                progress: progress,
                title: title,
                status: status,
                estimated: estimated,
                widgetUrl: widgetUrl
            )
        }

        Function("updateActivity") {
            (
                key: String, progress: Double, title: String, status: String,
                estimated: String, widgetUrl: String?
            ) throws -> Void in
            try handleActivity(
                action: .update,
                key: key,
                progress: progress,
                title: title,
                status: status,
                estimated: estimated,
                widgetUrl: widgetUrl
            )
        }

        Function("endActivity") {
            (
                key: String, progress: Double, title: String, status: String,
                estimated: String, widgetUrl: String?
            ) throws -> Void in
            try handleActivity(
                action: .end,
                key: key,
                progress: progress,
                title: title,
                status: status,
                estimated: estimated,
                widgetUrl: widgetUrl
            )
        }
    }

    private enum ActivityAction {
        case start, update, end
    }

    private func handleActivity(
        action: ActivityAction, key: String, progress: Double, title: String,
        status: String, estimated: String, widgetUrl: String?
    ) throws {
        logger.info("\(action)Activity()")

        guard #available(iOS 16.2, *) else {
            logger.info(
                "iOS version is lower than 16.2. Live Activity is not available."
            )
            throw NSError(
                domain: "LiveActivities", code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "iOS version is lower than 16.2. Live Activity is not available."
                ])
        }

        let attributes = AirpleAttributes(key: key)
        let contentState = AirpleAttributes.ContentState(
            progress: progress, title: title, status: status,
            estimated: estimated, widgetUrl: widgetUrl)
        let activityContent = ActivityContent(
            state: contentState, staleDate: nil)

        switch action {
        case .start:
            do {
                let activity = try Activity.request(
                    attributes: attributes, content: activityContent,
                    pushType: .token)
                logger.info(
                    "Requested a Live Activity \(String(describing: activity.id))."
                )
            } catch {
                logger.error(
                    "Error requesting Live Activity: \(error.localizedDescription)"
                )
                throw error
            }
        case .update:
            Task {
                for activity in Activity<AirpleAttributes>.activities {
                    if activity.attributes.key == key {
                        await activity.update(activityContent)
                        logger.info(
                            "Updating the Live Activity: \(activity.id)")
                    }
                }
            }
        case .end:
            Task {
                for activity in Activity<AirpleAttributes>.activities {
                    if activity.attributes.key == key {
                        await activity.end(
                            activityContent)
                        logger.info("Ending the Live Activity: \(activity.id)")
                    }
                }
            }
        }
    }
}
