import { CodedError } from "expo-modules-core";
/**
 * Live Activity module.
 * @author github.com/mrevanzak
 */

import { useEvent } from "expo";
import type {
  LiveActivityFn,
  LiveActivityState,
} from "./src/LiveActivities.types";
import LiveActivitiesModule from "./src/LiveActivitiesModule";

/**
 * Gets the push token.
 */
export function useGetPushToken() {
  const payload = useEvent(LiveActivitiesModule, "onPushTokenChange");
  return payload;
}

/**
 * Checks if the Live Activity feature is enabled on the current device.
 * iOS 16.2+
 * @platform ios
 */
export function areActivitiesEnabled(): boolean {
  return LiveActivitiesModule.areActivitiesEnabled();
}

function validateActivityOptions({
  progress,
}: Pick<LiveActivityState, "progress">): void {
  if (typeof progress !== "number" || progress < 0 || progress > 1) {
    throw new CodedError(
      "ERR_ACTIVITY_PROGRESS",
      "Progress should be a number between 0 and 1",
    );
  }
}

/**
 * Starts an iOS Live Activity.
 */
export const startActivity: LiveActivityFn = (
  key,
  { progress, title, status, estimated, widgetUrl },
) => {
  validateActivityOptions({ progress });
  try {
    LiveActivitiesModule.startActivity(
      key,
      Number(progress.toFixed(2)),
      title,
      status,
      estimated,
      widgetUrl,
    );
  } catch (error) {
    console.error(error);
    throw new CodedError("ERR_ACTIVITY_START", "Could not start activity");
  }
};

/**
 * Updates an iOS Live Activity.
 */
export const updateActivity: LiveActivityFn = (
  key,
  { progress, title, status, estimated, widgetUrl },
) => {
  validateActivityOptions({ progress });
  LiveActivitiesModule.updateActivity(
    key,
    Number(progress.toFixed(2)),
    title,
    status,
    estimated,
    widgetUrl,
  );
};

/**
 * Ends an iOS Live Activity.
 */
export const endActivity: LiveActivityFn = (
  key,
  { progress, title, status, estimated, widgetUrl },
) => {
  validateActivityOptions({ progress });
  LiveActivitiesModule.endActivity(
    key,
    Number(progress.toFixed(2)),
    title,
    status,
    estimated,
    widgetUrl,
  );
};
