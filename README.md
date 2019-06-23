# WeatherApp
Built from 1-29-19 to 2-4-19

# Description
This Weather App uses the Dark Weather API in order to serve the user Weather data for their given or user-inputed location.
Also persists the user's location across the app.
Also updates weather data through background app refresh.
Notifications are sent to the user upon new Weather Data through background app refresh.

# UI
![alt text](/WeatherAppDisplay.png?raw=true "Title")


Classic UIScrollView with pagecontrol

# TODO
1. Download App on physical device and try to get real information on its use cases. Walk/Drive around.
2. Implement error handling with WeatherApiClient in completion function for retrieveDarkSkyWeather().
3. Improve error handling in AppDelegate.
4. Validate local notifications are processed correctly in AppDelegate. For some reason, I’m only getting local notifications when there’s one already being processed in background or the app is brought to foreground. This may be the simulator, but need to download on physical device to test this.
5. Place the current location of the Weather being displayed at top of Main.storyboard.
6. Add more unit tests to confirm the WeatherApiClient calls are retrieving/generating the correct data.
7. Add more data to the UI by including 5-day weather forecast, instead of a summary.
8. Add more weather APIs to the WeatherApiClient file.
