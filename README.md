# NASA Explorer App

A comprehensive NASA data exploration application developed with Flutter. This application provides various space data including astronomy photos, Mars rover data, asteroid information, ISS location, EPIC Earth images, solar system data, and space weather using NASA APIs.

## 🚀 Features

### 📱 Main Features
- **Astronomy Picture of the Day (APOD)**: NASA's daily astronomy photo
- **APOD History**: Searchable archive of past APOD photos
- **Mars Rover Photos**: Photos from Curiosity, Opportunity, Spirit, and Perseverance rovers
- **Asteroid Data**: 7-day list of near-Earth asteroids
- **ISS Location**: Real-time location of the International Space Station
- **EPIC Earth Images**: Earth photos from DSCOVR satellite
- **Solar System**: Detailed information about planets and celestial bodies
- **Space Weather**: Solar activities and space events
- **Favorites**: Store content in local database
- **Theme Support**: Light/dark theme options

### 🛠 Technical Features
- **State Management**: Modern state management with Riverpod
- **HTTP Requests**: API calls with Dio package
- **Image Caching**: Fast image loading with CachedNetworkImage
- **Local Database**: Offline data storage with Hive
- **Map Integration**: ISS location with Google Maps
- **Material 3**: Modern and beautiful user interface
- **Responsive Design**: Design compatible with all screen sizes
- **Consistent UI**: Consistent header design across all screens

## 📋 Requirements

- Flutter SDK 3.2.3 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Android SDK (for Android)
- Xcode (for iOS)

## 🛠 Installation

1. **Clone the project:**
```bash
git clone <repository-url>
cd nasa_explorer
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Generate Hive adapters and Riverpod providers:**
```bash
flutter packages pub run build_runner build
```

4. **Run the application:**
```bash
flutter run
```

## 🏗️ Build Process

### Automatic Build Scripts

**For Linux/macOS:**
```bash
chmod +x build_script.sh
./build_script.sh
```

**For Windows:**
```cmd
build_script.bat
```

### Manual Build

**Android APK:**
```bash
flutter build apk --release
```

**Web:**
```bash
flutter build web --release
```

**Windows:**
```bash
flutter build windows --release
```

**iOS (macOS only):**
```bash
flutter build ios --release --no-codesign
```

### Build Issues and Solutions

#### Image Loading Issues
- ✅ Network security configuration added
- ✅ iOS App Transport Security settings configured
- ✅ Web CORS settings updated
- ✅ Fallback image system added

#### API Connection Issues
- ✅ Retry mechanism added
- ✅ Build environment detection added
- ✅ Fallback data system added
- ✅ Timeout settings optimized

#### Platform Specific Issues
- ✅ Android: Network security config
- ✅ iOS: App Transport Security
- ✅ Web: CORS policy
- ✅ Windows: Network permissions

## 🔧 Configuration

### API Keys
The application uses NASA's demo API key by default. For more request limits:

1. Go to [NASA API Portal](https://api.nasa.gov/)
2. Get a free API key
3. Update the `nasaApiKey` variable in `lib/constants.dart`

### Google Maps API Key (Optional)
If you want to use Google Maps for ISS location:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Maps API
3. Create an API key
4. Uncomment the `GoogleMapsFlutter.initializeWithKey()` line in `lib/main.dart`

## 📁 Project Structure

```
lib/
├── api/                    # API services
│   ├── nasa_api_service.dart
│   └── iss_api_service.dart
├── models/                 # Data models
│   ├── apod_model.dart
│   ├── mars_rover_model.dart
│   ├── asteroid_model.dart
│   ├── iss_model.dart
│   ├── epic_model.dart
│   ├── solar_system_model.dart
│   └── space_weather_model.dart
├── providers/              # Riverpod providers
│   ├── apod_provider.dart
│   ├── mars_rover_provider.dart
│   ├── asteroid_provider.dart
│   ├── iss_provider.dart
│   ├── epic_provider.dart
│   ├── solar_system_provider.dart
│   ├── space_weather_provider.dart
│   └── theme_provider.dart
├── screens/                # Screens
│   ├── home_screen.dart
│   ├── apod_history_screen.dart
│   ├── mars_rover_screen.dart
│   ├── asteroid_screen.dart
│   ├── iss_screen.dart
│   ├── iss_screen_web.dart
│   ├── epic_screen.dart
│   ├── solar_system_screen.dart
│   ├── space_weather_screen.dart
│   └── favorites_screen.dart
├── widgets/                # Common widgets
│   ├── loading_widget.dart
│   ├── error_widget.dart
│   └── safe_image_widget.dart
├── services/               # Services
│   └── download_service.dart
├── config/                 # Configuration
│   └── build_config.dart
├── constants.dart          # Constants
└── main.dart              # Main application
```

## 🎯 Usage

### Home Page
- Displays NASA's daily APOD photo
- High-resolution image
- Detailed description and copyright information
- Add/remove from favorites

### APOD History
- Searchable list of past APOD photos
- Date range selection
- Advanced filtering options (image/video, copyright)
- Statistics cards
- Scrollable list view

### Mars Rover
- Rover selection (Curiosity, Opportunity, Spirit, Perseverance)
- Date selection
- Camera filter
- Grid photo view

### Asteroid Data
- 7-day asteroid list for the future
- Detailed information in table format
- Dangerous asteroid marking
- Statistics cards

### ISS Location
- Real-time ISS location
- Google Maps integration
- Location information (latitude, longitude, altitude)
- Manual refresh

### EPIC Earth Images
- Earth photos from DSCOVR satellite
- Date selection
- High-resolution images
- Detailed descriptions

### Solar System
- Information about planets and celestial bodies
- Search function
- Statistics cards
- Detailed information cards

### Space Weather
- Solar activities
- Date range selection
- Detailed space weather information
- Access to detail pages via links

### Favorites
- Central management of all favorite content
- Category-based tabs
- Add/remove favorites
- Detail viewing

## 🎨 Theme and UI

The application uses modern design suitable for NASA theme:
- **Primary Color**: Dark blue (#1E3A8A)
- **Secondary Color**: Light blue (#3B82F6)
- **Accent Color**: Orange (#F59E0B)
- **Consistent Header Design**: Same header style across all screens
- **Material 3**: Modern and beautiful user interface
- **Responsive Design**: Compatible with all screen sizes

### Recent Updates
- ✅ Consistent header design across all screens
- ✅ APOD History header aligned with other screens
- ✅ Gradient headers converted to simple Container structure
- ✅ Transparent Scaffold background for main screen consistency

## 🔄 State Management

Modern state management is provided using Riverpod:
- **Providers**: API calls and data management
- **Notifiers**: Favorite operations and theme changes
- **FutureProviders**: Asynchronous data loading

## 💾 Data Storage

Local database support using Hive:
- **Favorites**: APOD, Mars Rover, Asteroid, EPIC, and Space Weather favorites
- **Settings**: Theme preferences and user settings
- **Offline Access**: Access to favorite content without internet

## 🚀 Performance

- **Image Caching**: Fast loading with CachedNetworkImage
- **Lazy Loading**: Load data when needed
- **Error Handling**: Comprehensive error management
- **Loading States**: User-friendly loading indicators
- **Optimized UI**: Consistent and performant user interface

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web (partial)
- ✅ Desktop (partial)

## 🤝 Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- [NASA API](https://api.nasa.gov/) - Data source
- [Flutter](https://flutter.dev/) - Framework
- [Riverpod](https://riverpod.dev/) - State management
- [Hive](https://hive.dev/) - Local database

## 📞 Contact

You can open an issue or send a pull request for your questions. 