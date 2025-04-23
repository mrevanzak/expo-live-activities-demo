import ActivityKit
import ExpoModulesCore

public class ExpoLiveActivitiesAppDelegate: ExpoAppDelegateSubscriber {
	public func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication
			.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		if #available(iOS 17.2, *) {
			Task {
				for await pushToken in Activity<AirpleAttributes>
					.pushToStartTokenUpdates
				{
					let pushTokenString = pushToken.reduce("") {
						$0 + String(format: "%02x", $1)
					}
					NotificationCenter.default.post(
						name: .onStartPushTokenChange, object: pushTokenString)
				}
			}
		}

		if #available(iOS 17.2, *) {
			Task {
				for await activity in Activity<AirpleAttributes>.activityUpdates
				{
					Task {
						for await pushToken in activity.pushTokenUpdates {
							let pushTokenString = pushToken.reduce("") {
								$0 + String(format: "%02x", $1)
							}
							NotificationCenter.default.post(
								name: .onPushTokenChange,
								object: pushTokenString,
								userInfo: ["key": activity.attributes.key]
							)
						}
					}
				}
			}
		}
		return true
	}
}

extension Notification.Name {
	static var onStartPushTokenChange: Notification.Name {
		return .init("LiveActivities.onStartPushTokenChange")
	}
	static var onPushTokenChange: Notification.Name {
		return .init("LiveActivities.onPushTokenChange")
	}
}
