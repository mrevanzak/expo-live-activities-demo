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

export interface ChangeEventPayload {
  token: string;
}

export type LiveActivityModuleEvent = {
  onPushTokenChange: (params: ChangeEventPayload) => void;
};
