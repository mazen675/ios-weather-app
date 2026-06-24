# WeatherCast App ⛅️

A native iOS weather application built with SwiftUI, demonstrating modern architectural patterns, local data persistence, and offline capabilities. This project was developed as part of the Information Technology Institute (ITI) Mobile Applications Development program.

## Features
* **Current Location Weather:** Automatically fetches local weather using `CoreLocation`.
* **Dynamic UI:** Background images and text colors automatically adapt to the current time of day (Morning/Evening).
* **Detailed Forecasts:** View a 3-day weather overview and drill down into hourly temperature breakdowns for any selected day.
* **Global Search & Favorites:** Search for any city worldwide and add it to a swipeable saved locations list.
* **Offline Support:** Seamless offline experience utilizing a local database cache for previously fetched weather data and favorite cities.

## Tech Stack
* **Framework:** SwiftUI
* **Architecture:** MVVM (Model-View-ViewModel)
* **Reactive Programming:** Combine (for search debouncing and state management)
* **Local Storage:** SwiftData (for offline API caching and bookmarking)
* **Networking:** URLSession (Integration with WeatherAPI.com)
* **Image Management:** SDWebImageSwiftUI (for asynchronous icon downloading and caching)
* **Location Services:** CoreLocation

## Developer
**Mazen Amr Mohamed Ashour**
