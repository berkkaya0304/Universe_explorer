// lib/constants.dart - API keys and constants
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  // NASA API key from environment
  static String get nasaApiKey => dotenv.env['NASA_API_KEY'] ?? 'DEMO_KEY';

  // API base URLs
  static String get nasaBaseUrl => dotenv.env['NASA_BASE_URL'] ?? 'https://api.nasa.gov';
  static const String apodEndpoint = '/planetary/apod';
  static const String marsRoverEndpoint = '/mars-photos/api/v1/rovers';
  static const String neoEndpoint = '/neo/rest/v1/feed';
  static String get issLocationEndpoint => dotenv.env['ISS_LOCATION_ENDPOINT'] ?? 'http://api.open-notify.org/iss-now.json';
  
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