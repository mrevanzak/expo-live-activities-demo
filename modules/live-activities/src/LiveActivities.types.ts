/**
 * state of the live activity
 * should be match with property on Attributes.swift
 * @see ios/Attributes.swift
 */
export interface LiveActivityState {
  progress: number;
  title: string;
  status: string;
  estimated: string;
  widgetUrl?: string;
}

export type LiveActivityFn = (key: string, state: LiveActivityState) => void;

export interface onPushTokenChangePayload {
  token: string;
}

export type LiveActivitiesModuleEvent = {
  "LiveActivities.pushTokenDidChange": (
    params: onPushTokenChangePayload
  ) => void;
  "LiveActivities.startTokenDidChange": (
    params: onPushTokenChangePayload
  ) => void;
};
