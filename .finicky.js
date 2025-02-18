module.exports = {
	defaultBrowser: "Safari",
  handlers: [
    {
      match: [
        /^https?:\/\/calendar\.google\.com\/.*$/,
        /^https?:\/\/meet\.google\.com\/.*$/,
      ],
      browser: {
        name: "Google Chrome",
        profile: "Default" // ユーザーB
			},
			{
				match: /zoom\.us\/j/,
				browser: 'us.zoom.xos',
			},
			{
				match: /notion\.so/,
				browser: 'Notion',
			},
			{
				match: /figma\.com\/(file|design)/,
				browser: 'Figma',
			},
    }
  ]
}