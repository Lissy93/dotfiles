  // Config file for Finicky
// Specifies which browser to open based on the URL
// Docs: https://github.com/johnste/finicky
module.exports = {
  defaultBrowser: "Firefox",
  rewrite: [
    { // Redirect all urls to use https
      match: ({ url }) => url.protocol === "http",
      url: { protocol: "https" }
    }
  ],
  handlers: [
    { // Open work non-coding stuff in Chromium
      // browser: "/Applications/Chromium.app",
      // We must now use Chrome, because IT is evil.
      browser: "/Applications/Google\ Chrome.app",
      match: [
        // Generic work things
        "*.google.com/*",
        "*atlassian.com/*",
        "*dev.azure.com/*",
        "*docs.google.com/*",
        "*miro.com/*",
        "*.zoom.com/*",
        "*.atlassian.net/*",
        "*.pagerduty.com/*",
        "*.sentry.io/*",
        "app.incident.io/*",
        "app.clickup.com/*",
        "console.cloud.google.com/*",
        "*.myfreshworks.com/*",
        "*.openvpn.com/*",
        "*.slack.com/*",
        "*getmontecarlo.com/*",

        // Loveholidays stuff
        "*.lvh.systems/*",
        "*.loveholidays.com/*",        
        "*.hibob.com/*",
        "github.com/loveholidays/*",
        

        // I love Firefox, but Chrome devtools is better
        "localhost:*",

        // AND Digital stuff
        "*and-digital.okta.com/*",
        "*and-digital.zoom.us/*",
        "*luna.and-digital.com/*",
        
      ],
    },
    { // Open coding stuff in Firefox
      browser: "/Applications/Firefox.app",
      match: [],
    },
  ]
};
