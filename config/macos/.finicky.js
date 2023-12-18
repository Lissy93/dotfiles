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
      // We must use Chrome, because IT is evil.
      browser: "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome",
      match: [
        "*.google.com/*",
        "*and-digital.okta.com/*",
        "*and-digital.zoom.us/*",
        "*atlassian.com/*",
        "*dev.azure.com/*",
        "*docs.google.com/*",
        "*luna.and-digital.com/*",
        "*miro.com/*",
        "*zoom.com/*",
        "*.atlassian.net/*"
      ],
    },
    { // Open coding stuff in Firefox
      browser: "/Applications/Firefox.app",
      match: [],
    },
    { // Open personal stuff in Orion
      browser: "/Applications/Orion.app",
      match: [],
    },
  ]
};
