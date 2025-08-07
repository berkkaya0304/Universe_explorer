// lib/constants.dart - API keys and constants
class Constants {
  // NASA API key
  static const String nasaApiKey = 'w7klmXO4NMySbhyVJCZagZQosSanBoxfAIG0wlAH';

  // API base URLs
  static const String nasaBaseUrl = 'https://api.nasa.gov';
  static const String apodEndpoint = '/planetary/apod';
  static const String marsRoverEndpoint = '/mars-photos/api/v1/rovers';
  static const String neoEndpoint = '/neo/rest/v1/feed';
  static const String issLocationEndpoint = 'http://api.open-notify.org/iss-now.json';
  
  // New endpoints
  static const String epicEndpoint = '/EPIC/api/natural';
  static const String solarSystemEndpoint = '/planetary/rest/bodies';
  static const String spaceWeatherEndpoint = '/DONKI/CME';
  static const String spaceWeatherFlareEndpoint = '/DONKI/FLR';
  static const String spaceWeatherStormEndpoint = '/DONKI/GST';

  // Mars Rover names
  static const List<String> roverNames = ['curiosity', 'opportunity', 'spirit', 'perseverance'];

  // Mars Rover cameras
  static const List<String> cameras = [
    'FHAZ',
    'RHAZ',
    'MAST',
    'CHEMCAM',
    'MAHLI',
    'MARDI',
    'NAVCAM',
    'PANCAM',
    'MINITES'
  ];

  // Theme colors
  static const int primaryColor = 0xFF1E3A8A; // Dark blue
  static const int secondaryColor = 0xFF3B82F6; // Light blue
  static const int accentColor = 0xFFF59E0B; // Orange

  // Hive box names
  static const String favoritesBox = 'favorites';
  static const String settingsBox = 'settings';

  // Asset paths
  static const String placeholderImage = 'assets/images/placeholder.png';
} 