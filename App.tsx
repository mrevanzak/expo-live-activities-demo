import { StatusBar } from "expo-status-bar";
import { Button, StyleSheet, Text, View } from "react-native";

import * as LiveActivities from "@local:live-activities";
import { useState } from "react";

export default function App() {
  const [token, setToken] = useState<string>();
  const [startToken, setStartToken] = useState<string>();

  LiveActivities.useLiveActivitiesSetup(({ token }) => {
    setStartToken(token);
  });

  LiveActivities.useGetPushToken(({ token }) => {
    setToken(token);
  });

  return (
    <View style={styles.container}>
      <StatusBar style="auto" />

      <Text>Token: {token}</Text>
      <Text>Start Token: {startToken}</Text>
      <Button
        title="Start Live Activities"
        onPress={() => {
          if (LiveActivities.areActivitiesEnabled()) {
            LiveActivities.startActivity("id", {
              progress: 0.2,
              title: "Technician is on the way!",
              status: "Arriving",
              estimated: "11.00 - 11.30",
            });
          }
        }}
      />
      <Button
        title="End Live Activities"
        onPress={() => {
          if (LiveActivities.areActivitiesEnabled()) {
            LiveActivities.endActivity("id", {
              progress: 1,
              title: "Technician has arrived!",
              status: "Arrived",
              estimated: "Now",
            });
          }
        }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
