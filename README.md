
# 🌍 ListOfCountries
A Swift-based iOS application that fetches and displays a list of countries with powerful features such as **search**, **filtering**, and **dynamic view modes** (Grid/List). This project uses **MVVM architecture** and is built with testability and clean design principles in mind.

---

## 📱 Features

- Display all countries in either **List View** or **Grid View**
- Real-time **search functionality**
- Filter countries by specific criteria (region, name, etc.)
- Fetch data using **API layer** with proper error handling
- Modular architecture with **ViewModel**, **Model**, and **Networking** layers
- Unit Tests and UI Tests for robustness

---

## Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture pattern.

```
Model ⟶ ViewModel ⟶ ViewController
  ↑          ↓           ↓
Network    Filtering    UI Updates
Layer      + Binding
```

### Model
- `CountryModel.swift`: Represents the structure of each country including name, region, flags, etc.

### ViewModel
- `CountriesListViewModel.swift`: Handles data fetching, search logic, filtering, and exposes observable properties for the view to update reactively.

### Views
- `CountriesListViewController.swift`: UI controller responsible for displaying data and managing the list/grid toggle.
- `CountriesListTableViewCell.swift`: Cell used for **List View**.
- `CountriesListCollectiveViewCell.swift`: Cell used for **Grid View**.

### Networking
- `APIManager.swift`: Handles all API requests using `URLSession`.
- `APIEndpoints.swift`: Centralized definition of API endpoint URLs.
- `APIManagerProtocol.swift`: Protocol to abstract the API manager for easier testing.
- `NetworkError.swift`: Enum for categorizing network errors.

---

## Testing

### Unit Tests
- `CountriesListViewModelTests.swift`: Tests for view model logic like search, filtering, and parsing.
- `APIManagerTests.swift`: Tests for API request and response handling with mocks.

### Mocking
- `MockURLProtocol.swift`: Intercepts and simulates API responses for unit tests.
- `MockAPIManager.swift`: Mock implementation of `APIManagerProtocol`.

### UI Tests
- `ListOfCountriesUITests.swift`
- `ListOfCountriesUITestsLaunchTests.swift`

---

## Getting Started

### Prerequisites

- Xcode 13 or higher
- iOS 13.0+
- Swift 5.5+

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ListOfCountries.git
   cd ListOfCountries
   ```

2. Open the project in Xcode:
   ```bash
   open ListOfCountries.xcodeproj
   ```

3. Run the app on the simulator or a connected device.

---

## View Mode

You can switch between:
- **List View** – vertical scrolling list with country details.
- **Grid View** – a grid layout with country cards.

This is managed through an enum:
```swift
enum ViewMode {
    case list
    case grid
}
```

The toggle is implemented in `CountriesListViewController.swift`, and the UI refreshes accordingly.

---

## Search & Filter

- Users can type in a search bar to filter countries by name.
- ViewModel updates results in real time using reactive bindings or delegate updates.

Like:
```swift
func searchCountries(keyword: String) {
    filteredCountries = allCountries.filter {
        $0.name.lowercased().contains(keyword.lowercased())
    }
}
```

---

## Tools & Technologies

- Swift 5
- UIKit
- MVVM Pattern
- URLSession
- XCTest for Unit Testing
- XCUI Test for UI Testing

---

## Project Structure

```
ListOfCountries/
│
├── Model/
│   └── CountryModel.swift
│
├── ViewModel/
│   └── CountriesListViewModel.swift
│
├── Views/
│   ├── CountriesListViewController.swift
│   ├── CountriesListTableViewCell.swift
│   └── CountriesListCollectiveViewCell.swift
│
├── NetworkLayer/
│   ├── APIManager.swift
│   ├── APIManagerProtocol.swift
│   ├── APIEndpoints.swift
│   └── NetworkError.swift
│
├── Tests/
│   ├── CountriesListViewModelTests.swift
│   ├── APIManagerTests.swift
│   ├── MockAPIManager.swift
│   └── MockURLProtocol.swift
│
└── ListOfCountries.xcodeproj/
```

---

## Contributing

I'm more than happy for any contributions here! To contribute:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Make your changes and commit (`git commit -am 'Add feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Create a new Pull Request

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Author

**Aayush Raghuvanshi**  
[LinkedIn](https://www.linkedin.com/in/aayush-raghuvanshi-428067361/) · [Email](mailto:raghuvanshiaayush9999@gmail.com)
