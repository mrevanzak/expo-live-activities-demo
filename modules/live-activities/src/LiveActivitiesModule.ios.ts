import { NativeModule, requireNativeModule } from "expo-modules-core";
import type { LiveActivityModuleEvent } from "./LiveActivities.types";

declare class ExpoLiveActivities extends NativeModule<LiveActivityModuleEvent> {
  areActivitiesEnabled(): boolean;
  startActivity(
    key: string,
    progress: number,
    title: string,
    status: string,
    estimated: string,
    widgetUrl?: string,
  ): void;
  updateActivity(
    key: string,
    progress: number,
    title: string,
    status: string,
    estimated: string,
    widgetUrl?: string,
  ): void;
  endActivity(
    key: string,
    progress: number,
    title: string,
    status: string,
    estimated: string,
    widgetUrl?: string,
  ): void;
}

export default requireNativeModule<ExpoLiveActivities>(
  "ExpoLiveActivities",
);
