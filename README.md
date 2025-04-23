# Live Activities on Expo
> Live activities can ran smoothly on Expo with help of expo modules. If you have apple watch, it will also shows up on the smart stack

## How to Start/Update with APNs
```ts
import * as apn from "@parse/node-apn";

type ContentState = {
  progress: number;
  title: string;
  status: string;
  estimated: string;
  widgetUrl: string;
};

async function startUserLiveActivity(
  key: number,
  token: string,
  contentState: ContentState,
) {
  try {
    const notification = new apn.Notification();
    // TODO: change with your app bundle
    notification.topic = "${bundleId}.push-type.liveactivity";
    notification.pushType = "liveactivity";
    //@ts-expect-error - type outdated
    notification.event = "start";
    //@ts-expect-error - type outdated
    notification.timestamp = Math.floor(Date.now() / 1000) + 10;
    //@ts-expect-error - type outdated
    notification.staleDate = Math.floor(Date.now() / 1000) + 3600;
    //@ts-expect-error - type outdated
    notification.contentState = contentState;

    // TODO: change to your attribute name on `Attributes.swift`
    notification.aps["attributes-type"] = "AirpleAttributes";
    //@ts-expect-error - type outdated
    notification.aps.attributes = {
      key,
    };
    // can change it to other, its the same as notification title and body
    notification.alert = {
      title: contentState.title,
      body: contentState.status,
      //@ts-expect-error - type outdated
      sound: "a.wav",
    };

    this.apns.send(notification, token).then((response) => {
      console.log(response);
    });
  } catch (error) {
    console.log(error);
  }
}

async function updateUserLiveActivity(
  token: string,
  contentState: ContentState,
  event: "update" | "end",
) {
  try {
    const notification = new apn.Notification();
    // TODO: change with your app bundle
    notification.topic = "${bundleId}.push-type.liveactivity";
    notification.pushType = "liveactivity";
    //@ts-expect-error - type outdated
    notification.event = event;
    //@ts-expect-error - type outdated
    notification.timestamp = Math.floor(Date.now() / 1000) + 10;
    //@ts-expect-error - type outdated
    notification.staleDate = Math.floor(Date.now() / 1000) + 3600;
    //@ts-expect-error - type outdated
    notification.contentState = contentState;

    notification.alert = {
      title: contentState.title,
      body: contentState.status,
      //@ts-expect-error - type outdated
      sound: "a.wav",
    };

    this.apns.send(notification, token).then(async (response) => {
      console.log("Update live activity response", response);
    });
  } catch (error) {
    console.log(error);
  }
}

```


| DEMO Video                                                                                           | Smart Stack WatchOS |
| ---------------------------------------------------------------------------------------------------- | -------------------------- |
| <video src="https://github.com/user-attachments/assets/11a53477-caef-4548-a76b-0b32ec326b56" />      | ![incoming-F2FCB1F6-42D7-44C5-A0A8-2B008D75B7C1](https://github.com/user-attachments/assets/95d2bc3b-8255-490f-98a4-634fe4b546b4) |

> Reference
- https://fizl.io/blog/posts/live-activities
- https://github.com/EvanBacon/expo-apple-targets
- https://evanbacon.dev/blog/apple-home-screen-widgets

