# MobileChallenge

iOS app to search through ~200k cities. Built with SwiftUI.

## Search Approach

The main challenge was searching efficiently through a huge list. With 200k cities, linear search O(n) would be too slow, especially when the user is typing and we need to filter on every keystroke.

I preprocess the list once when the app loads. I create a `CityIndex` that combines city name and country into a normalized lowercase string like `"denver, us"`, then sort it alphabetically. This way I have a sorted, normalized list ready to search instead of doing it on every search.

For the actual search, I use binary search to find the range of cities that start with the prefix. The algorithm finds the first and last index where cities with that prefix would be, then returns everything in that range.

Since the list is pre-sorted alphabetically, all cities starting with the same prefix are grouped together. Binary search lets me find that range quickly without checking every city.

## Architecture Decisions

I used protocols for `CityService` and `FavouritesRepository` instead of concrete classes. Makes testing easier and allows swapping implementations. Default implementations use remote API and UserDefaults.

Favorites are stored in UserDefaults as a Set of city IDs. Simple and works fine for this use case.

The layout switches between portrait (separate screens) and landscape (side by side) using GeometryReader to detect orientation.

## Assumptions

- JSON is always well-formed (TODOs in code)
- No network error handling yet (TODOs in code)
- No loading state (TODOs in code)

## Project Structure

```
Models/          # City, CityIndex, Coordinate
Services/        # CityService protocol + RemoteCityService
Repositories/    # FavouritesRepository protocol + UserDefaults impl
Views/           # CitiesView, CityDetailView, CityMapView
```

## Running

Open `MobileChallenge.xcodeproj` in Xcode and run. Cities download automatically on launch.
