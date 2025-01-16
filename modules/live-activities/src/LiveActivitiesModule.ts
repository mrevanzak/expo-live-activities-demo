import { NativeModule, requireNativeModule } from "expo-modules-core";
import type { LiveActivitiesModuleEvent } from "./LiveActivities.types";

class ExpoLiveActivities extends NativeModule<LiveActivitiesModuleEvent> {
  areActivitiesEnabled() {
    return false;
  }
  startActivity(
    _key: string,
    _progress: number,
    _title: string,
    _status: string,
    _estimated: string,
    _widgetUrl?: string
  ) {
    return;
  }
  updateActivity(
    _key: string,
    _progress: number,
    _title: string,
    _status: string,
    _estimated: string,
    _widgetUrl?: string
  ) {
    return;
  }
  endActivity(
    _key: string,
    _progress: number,
    _title: string,
    _status: string,
    _estimated: string,
    _widgetUrl?: string
  ) {
    return;
  }
}

export default requireNativeModule<ExpoLiveActivities>("LiveActivities");
