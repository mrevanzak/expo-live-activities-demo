import { NativeModule, requireNativeModule } from "expo-modules-core";
import type { LiveActivitiesModuleEvent } from "./LiveActivities.types";

declare class ExpoLiveActivities extends NativeModule<LiveActivitiesModuleEvent> {
  areActivitiesEnabled(): boolean;
  startActivity(
    key: string,
    progress: number,
    title: string,
    status: string,
    estimated: string,
    widgetUrl?: string
  ): void;
  updateActivity(
    key: string,
    progress: number,
    title: string,
    status: string,
    estimated: string,
    widgetUrl?: string
  ): void;
  endActivity(
    key: string,
    progress: number,
    title: string,
    status: string,
    estimated: string,
    widgetUrl?: string
  ): void;
}

export default requireNativeModule<ExpoLiveActivities>("ExpoLiveActivities");
