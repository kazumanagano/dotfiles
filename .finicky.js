module.exports = {
	defaultBrowser: "Safari",
	options: {
		// Hide the finicky icon from the top bar. Default: false
		hideIcon: true,
		// Check for update on startup. Default: true
		checkForUpdate: true,
		// Change the internal list of url shortener services. Default: undefined
		urlShorteners: (list) => [...list, "custom.urlshortener.com"],
		// Log every request with basic information to console. Default: false
		logRequests: false
	},
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
		},
		{
			match: /zoom\.us\/j/,
			browser: 'us.zoom.xos',
		},
		{
			match: /figma\.com\/(file|design)/,
			browser: 'Figma',
		},
		{
			match: /linear\.app/,
			browser: 'Linear',
		}
	],
	rewrite: [
		{
			// Redirect all https://slack.com/app_redirect?team=team=apegroup&channel=random 
			// to slack://channel?team=apegroup&id=random
			match: ({ url }) => url.host.includes("slack.com") && url.pathname.includes("app_redirect"),
			url({ url }) {
				const team = url.search.split('&').filter(part => part.startsWith('team'));
				var channel = "" + url.search.split('&').filter(part => part.startsWith('channel'));
				var id = channel.replace("channel", "id");
				return {
					protocol: "slack",
					username: "",
					password: "",
					host: "channel",
					port: null,
					pathname: "",
					search: team + '&' + id,
					hash: ""

				}
			}
		}
	]
}