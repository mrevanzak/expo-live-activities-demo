const { withInfoPlist } = require("@expo/config-plugins");

/**
 * @type {import('@expo/config-plugins').ConfigPlugin<{ frequentUpdates?: boolean }>}
 */
const withLiveActivities = (config, { frequentUpdates = false }) =>
  withInfoPlist(config, (config) => {
    config.modResults.NSSupportsLiveActivities = true;
    config.modResults.NSSupportsLiveActivitiesFrequentUpdates = frequentUpdates;
    return config;
  });

module.exports = withLiveActivities;
