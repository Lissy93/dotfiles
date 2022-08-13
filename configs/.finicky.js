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
      browser: "/Applications/Chromium.app",
      match: [
        "*zoom.com/*",
        "google.com/*",
        "*.google.com/*",
        "*and-digital.zoom.us/*",
        "*luna.and-digital.com/*",
        "*and-digital.okta.com/*",
        "*docs.google.com/*",
        "*calendar.google.com/*",
        "*miro.com/*"
      ],
    },
  ]
};
