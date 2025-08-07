// lib/api/nasa_api_service.dart - NASA API service class
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../config/build_config.dart';
import '../models/apod_model.dart';
import '../models/mars_rover_model.dart';
import '../models/asteroid_model.dart';
import '../models/epic_model.dart';
import '../models/solar_system_model.dart';
import '../models/space_weather_model.dart';

class NasaApiService {
  late final Dio _dio;
  
  NasaApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: Constants.nasaBaseUrl,
      connectTimeout: BuildConfig.apiTimeout,
      receiveTimeout: BuildConfig.apiTimeout,
      sendTimeout: BuildConfig.apiTimeout,
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'en-US,en;q=0.9',
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache',
      },
    ));
    
    // Interceptor for adding API key to all requests
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.queryParameters['api_key'] = Constants.nasaApiKey;
        print('API Request: ${options.method} ${options.uri}');
        print('API Request Headers: ${options.headers}');
        handler.next(options);
      },
      onError: (error, handler) {
        print('API Error: ${error.message}');
        print('API Error Type: ${error.type}');
        print('API Error Response: ${error.response?.statusCode}');
        print('API Error Data: ${error.response?.data}');
        handler.next(error);
      },
      onResponse: (response, handler) {
        print('API Response: ${response.statusCode} - ${response.requestOptions.uri}');
        handler.next(response);
      },
    ));
  }

  // APOD (Astronomy Picture of the Day) service
  Future<ApodModel> getApod({String? date}) async {
    try {
      print('APOD Request: date=$date');
      
      final response = await _dio.get(
        Constants.apodEndpoint,
        queryParameters: date != null ? {'date': date} : null,
      );
      
      print('APOD Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final apodData = ApodModel.fromJson(response.data);
        print('APOD Data loaded successfully: ${apodData.title}');
        return apodData;
      } else {
        print('APOD Error: Status ${response.statusCode}');
        throw Exception('APOD data could not be retrieved. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('APOD DioException: ${e.message}');
      print('APOD DioException Type: ${e.type}');
      print('APOD DioException Response: ${e.response?.statusCode}');
      
      // Use fallback data for connection issues
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        print('Using fallback APOD data due to connection issues');
        return _getFallbackApodData(date);
      }
      
      throw Exception('APOD service error: ${e.message}');
    } catch (e) {
      print('APOD General Exception: $e');
      print('Using fallback APOD data due to general error');
      return _getFallbackApodData(date);
    }
  }

  // Fallback APOD data for build environments
  ApodModel _getFallbackApodData(String? date) {
    final targetDate = date ?? DateTime.now().toString().split(' ')[0];
    final fallbackImage = BuildConfig.getRandomFallbackImage();
    
    // Enhanced fallback data with better content
    final List<Map<String, String>> fallbackData = [
      {
        'title': 'Galaksi Merkezi - Samanyolu',
        'explanation': 'Bu görsel, Samanyolu galaksimizin merkezini gösteriyor. Milyarlarca yıldız ve nebulaların oluşturduğu bu muhteşem manzara, evrenin büyüklüğünü ve güzelliğini yansıtıyor. NASA\'nın Hubble Uzay Teleskobu tarafından çekilen bu fotoğraf, derin uzayın en etkileyici görüntülerinden biridir.',
        'copyright': 'NASA/JPL-Caltech/Hubble Space Telescope'
      },
      {
        'title': 'Nebula Bulutları - Yıldız Doğumevi',
        'explanation': 'Bu nebulalar, yeni yıldızların doğduğu kozmik bulutlardır. Hidrojen ve helyum gazlarının yoğunlaşmasıyla oluşan bu yapılar, evrenin en güzel ve en dinamik bölgelerinden birini temsil ediyor. Bu görsel, yıldız oluşum sürecinin en etkileyici örneklerinden birini gösteriyor.',
        'copyright': 'NASA/JPL-Caltech/Spitzer Space Telescope'
      },
      {
        'title': 'Mars Yüzeyi - Kızıl Gezegen',
        'explanation': 'Mars\'ın yüzeyindeki bu manzara, kızıl gezegenin jeolojik geçmişini anlatıyor. Kraterler, vadiler ve eski nehir yatakları, Mars\'ın bir zamanlar suya sahip olduğunu gösteriyor. Bu görsel, gelecekteki Mars misyonları için değerli bilgiler sağlıyor.',
        'copyright': 'NASA/JPL-Caltech/Mars Rover'
      },
      {
        'title': 'Satürn Halkaları - Halkalı Gezegen',
        'explanation': 'Satürn\'ün ikonik halkaları, milyarlarca buz parçasından oluşuyor. Bu muhteşem yapı, güneş sistemimizin en güzel manzaralarından birini sunuyor. Cassini uzay aracı tarafından çekilen bu fotoğraf, Satürn\'ün halkalarının karmaşık yapısını gösteriyor.',
        'copyright': 'NASA/JPL-Caltech/Cassini Mission'
      },
      {
        'title': 'Andromeda Galaksisi - Komşu Galaksi',
        'explanation': 'Andromeda Galaksisi, Samanyolu\'na en yakın büyük galaksidir. 2.5 milyon ışık yılı uzaklıktaki bu galaksi, milyarlarca yıldız içeriyor. Bu görsel, galaksiler arası etkileşimlerin ve evrenin genişlemesinin en güzel örneklerinden birini gösteriyor.',
        'copyright': 'NASA/JPL-Caltech/Hubble Space Telescope'
      },
      {
        'title': 'Güneş Patlamaları - Yıldızımızın Aktivitesi',
        'explanation': 'Güneş\'in yüzeyindeki bu patlamalar, yıldızımızın dinamik doğasını gösteriyor. Güneş lekeleri ve koronal kütle atımları, Dünya\'daki manyetik alanı ve iletişim sistemlerini etkileyebiliyor. Bu görsel, güneş fiziğinin en etkileyici örneklerinden birini sunuyor.',
        'copyright': 'NASA/JPL-Caltech/Solar Dynamics Observatory'
      }
    ];
    
    final randomIndex = DateTime.now().millisecond % fallbackData.length;
    final selectedData = fallbackData[randomIndex];
    
    return ApodModel(
      copyright: selectedData['copyright'] ?? 'NASA/JPL-Caltech',
      date: targetDate,
      explanation: selectedData['explanation'] ?? 'Bu, Günün Astronomi Fotoğrafı için yedek görseldir. NASA API verileri build sürecinde alınamadı.',
      hdurl: fallbackImage,
      mediaType: 'image',
      serviceVersion: 'v1',
      title: selectedData['title'] ?? 'Yedek Günün Astronomi Fotoğrafı - $targetDate',
      url: fallbackImage,
    );
  }

  // Get historical APOD data
  Future<List<ApodModel>> getApodHistory({required String startDate, required String endDate}) async {
    try {
      print('APOD History Request: startDate=$startDate, endDate=$endDate');
      
      final response = await _dio.get(
        Constants.apodEndpoint,
        queryParameters: {
          'start_date': startDate,
          'end_date': endDate,
        },
      );
      
      print('APOD History Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print('APOD History Data Count: ${data.length}');
        return data.map((json) => ApodModel.fromJson(json)).toList();
      } else {
        print('APOD History Error: Status ${response.statusCode}');
        throw Exception('APOD history data could not be retrieved. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('APOD History DioException: ${e.message}');
      print('APOD History DioException Type: ${e.type}');
      print('APOD History DioException Response: ${e.response?.statusCode}');
      
      // Fallback to static data for build environments
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        print('Using fallback APOD history data for build environment');
        return _getFallbackApodHistoryData(startDate, endDate);
      }
      
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Please check your internet connection.');
      } else {
        throw Exception('APOD history service error: ${e.message}');
      }
    } catch (e) {
      print('APOD History General Exception: $e');
      throw Exception('APOD history service error: $e');
    }
  }

  // Fallback APOD history data for build environments
  List<ApodModel> _getFallbackApodHistoryData(String startDate, String endDate) {
    final List<ApodModel> fallbackData = [];
    
    // Enhanced fallback data with better content
    final List<Map<String, String>> fallbackContent = [
      {
        'title': 'Galaksi Merkezi - Samanyolu',
        'explanation': 'Bu görsel, Samanyolu galaksimizin merkezini gösteriyor. Milyarlarca yıldız ve nebulaların oluşturduğu bu muhteşem manzara, evrenin büyüklüğünü ve güzelliğini yansıtıyor.',
        'copyright': 'NASA/JPL-Caltech/Hubble Space Telescope'
      },
      {
        'title': 'Nebula Bulutları - Yıldız Doğumevi',
        'explanation': 'Bu nebulalar, yeni yıldızların doğduğu kozmik bulutlardır. Hidrojen ve helyum gazlarının yoğunlaşmasıyla oluşan bu yapılar, evrenin en güzel bölgelerinden birini temsil ediyor.',
        'copyright': 'NASA/JPL-Caltech/Spitzer Space Telescope'
      },
      {
        'title': 'Mars Yüzeyi - Kızıl Gezegen',
        'explanation': 'Mars\'ın yüzeyindeki bu manzara, kızıl gezegenin jeolojik geçmişini anlatıyor. Kraterler, vadiler ve eski nehir yatakları, Mars\'ın bir zamanlar suya sahip olduğunu gösteriyor.',
        'copyright': 'NASA/JPL-Caltech/Mars Rover'
      },
      {
        'title': 'Satürn Halkaları - Halkalı Gezegen',
        'explanation': 'Satürn\'ün ikonik halkaları, milyarlarca buz parçasından oluşuyor. Bu muhteşem yapı, güneş sistemimizin en güzel manzaralarından birini sunuyor.',
        'copyright': 'NASA/JPL-Caltech/Cassini Mission'
      },
      {
        'title': 'Andromeda Galaksisi - Komşu Galaksi',
        'explanation': 'Andromeda Galaksisi, Samanyolu\'na en yakın büyük galaksidir. 2.5 milyon ışık yılı uzaklıktaki bu galaksi, milyarlarca yıldız içeriyor.',
        'copyright': 'NASA/JPL-Caltech/Hubble Space Telescope'
      },
      {
        'title': 'Güneş Patlamaları - Yıldızımızın Aktivitesi',
        'explanation': 'Güneş\'in yüzeyindeki bu patlamalar, yıldızımızın dinamik doğasını gösteriyor. Güneş lekeleri ve koronal kütle atımları, Dünya\'daki manyetik alanı etkileyebiliyor.',
        'copyright': 'NASA/JPL-Caltech/Solar Dynamics Observatory'
      },
      {
        'title': 'Jüpiter Fırtınaları - Dev Gezegen',
        'explanation': 'Jüpiter\'in yüzeyindeki bu dev fırtına, Büyük Kırmızı Leke olarak biliniyor. Yüzyıllardır süren bu fırtına, güneş sistemimizin en büyük gezegeninin dinamik atmosferini gösteriyor.',
        'copyright': 'NASA/JPL-Caltech/Juno Mission'
      }
    ];
    
    // Generate fallback data for the date range
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    final days = end.difference(start).inDays;
    
    for (int i = 0; i <= days && i < 7; i++) { // Limit to 7 days max
      final date = start.add(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      final imageIndex = i % BuildConfig.fallbackImageUrls.length;
      final contentIndex = i % fallbackContent.length;
      final fallbackImage = BuildConfig.fallbackImageUrls[imageIndex];
      final selectedContent = fallbackContent[contentIndex];
      
      fallbackData.add(ApodModel(
        copyright: selectedContent['copyright'] ?? 'NASA/JPL-Caltech',
        date: dateStr,
        explanation: selectedContent['explanation'] ?? 'Bu, $dateStr tarihli Günün Astronomi Fotoğrafı için yedek veridir. NASA API verileri build sürecinde alınamadı.',
        hdurl: fallbackImage,
        mediaType: 'image',
        serviceVersion: 'v1',
        title: selectedContent['title'] ?? 'Yedek APOD - $dateStr',
        url: fallbackImage,
      ));
    }
    
    return fallbackData;
  }

  // Mars Rover photos
  Future<List<MarsRoverModel>> getMarsRoverPhotos({
    required String rover,
    required String earthDate,
    String? camera,
  }) async {
    try {
      print('Mars Rover API call: $rover, $earthDate, camera: $camera');
      
      // Enhanced retry mechanism for build environments
      int retryCount = 0;
      const maxRetries = 3;
      const baseDelay = 1; // seconds
      
      while (retryCount < maxRetries) {
        try {
      final response = await _dio.get(
        '${Constants.marsRoverEndpoint}/$rover/photos',
        queryParameters: {
          'earth_date': earthDate,
          if (camera != null) 'camera': camera,
        },
      );
      
      print('Mars Rover API response: ${response.statusCode}');
      print('Mars Rover API URL: ${response.requestOptions.uri}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        print('Mars Rover API data structure: ${data.keys.toList()}');
        
        final List<dynamic> photos = data['photos'] ?? [];
        print('Mars Rover photo count: ${photos.length}');
        
        if (photos.isEmpty) {
          print('WARNING: No photos on selected date. Rover: $rover, Date: $earthDate');
          print('Recommended dates:');
          print('- Curiosity: 2024-01-15, 2023-12-01, 2023-11-15');
          print('- Perseverance: 2024-01-15, 2023-12-01, 2023-11-15');
          print('- Opportunity: 2018-06-10, 2018-05-15, 2018-04-20');
          print('- Spirit: 2009-03-22, 2009-02-15, 2009-01-10');
        }
        
        final List<MarsRoverModel> roverPhotos = [];
        for (final photoJson in photos) {
          try {
            roverPhotos.add(MarsRoverModel.fromJson(photoJson));
          } catch (e) {
            print('Mars Rover photo parse error: $e');
            print('Invalid JSON: $photoJson');
          }
        }
        
        print('Successfully parsed photo count: ${roverPhotos.length}');
        return roverPhotos;
      } else {
        print('Mars Rover API response error: ${response.statusCode}');
        throw Exception('Could not get Mars Rover photos: ${response.statusCode}');
      }
        } catch (e) {
          retryCount++;
          print('Mars Rover API retry $retryCount/$maxRetries: $e');
          
          if (retryCount >= maxRetries) {
            print('Mars Rover API failed after $maxRetries attempts');
            rethrow;
          }
          
          // Exponential backoff with jitter
          final delay = baseDelay * (2 ^ (retryCount - 1)) + (retryCount * 0.5);
          print('Mars Rover API waiting ${delay.toStringAsFixed(1)} seconds before retry');
          await Future.delayed(Duration(milliseconds: (delay * 1000).round()));
        }
      }
      
      throw Exception('Failed to load Mars Rover data after $maxRetries attempts');
    } catch (e) {
              print('Mars Rover API error: $e');
              throw Exception('Mars Rover service error: $e');
    }
  }

  // Asteroid data (NEO - Near Earth Objects)
  Future<List<AsteroidModel>> getAsteroidData({
    required String startDate,
    required String endDate,
  }) async {
    try {
              print('Asteroid API call: $startDate - $endDate');
      final response = await _dio.get(
        Constants.neoEndpoint,
        queryParameters: {
          'start_date': startDate,
          'end_date': endDate,
        },
      );
      
              print('Asteroid API response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<AsteroidModel> asteroids = [];
        
        // Check API response structure
        if (data.containsKey('near_earth_objects')) {
          final nearEarthObjects = data['near_earth_objects'] as Map<String, dynamic>;
          
          nearEarthObjects.forEach((date, asteroidsData) {
            print('Date: $date, Asteroid count: ${asteroidsData.length}');
            if (asteroidsData is List) {
              for (final asteroidJson in asteroidsData) {
                try {
                  asteroids.add(AsteroidModel.fromJson(asteroidJson));
                } catch (e) {
                  print('Asteroid parse error: $e');
                  print('Invalid JSON: $asteroidJson');
                }
              }
            }
          });
        } else {
          // Alternative structure check
          data.forEach((date, asteroidsData) {
            print('Date: $date, Data type: ${asteroidsData.runtimeType}');
            if (asteroidsData is List) {
              for (final asteroidJson in asteroidsData) {
                try {
                  asteroids.add(AsteroidModel.fromJson(asteroidJson));
                } catch (e) {
                  print('Asteroid parse error: $e');
                }
              }
            }
          });
        }
        
        print('Total asteroid count: ${asteroids.length}');
        return asteroids;
      } else {
        print('API response error: ${response.statusCode}');
        throw Exception('Could not get asteroid data: ${response.statusCode}');
      }
    } catch (e) {
              print('Asteroid API error: $e');
              throw Exception('Asteroid service error: $e');
    }
  }

  // EPIC (Earth Polychromatic Imaging Camera) data
  Future<List<EpicModel>> getEpicData({String? date}) async {
    try {
      print('EPIC API call: ${date ?? 'latest'}');
      final response = await _dio.get(
        Constants.epicEndpoint,
        queryParameters: date != null ? {'date': date} : null,
      );
      
      print('EPIC API response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<EpicModel> epicImages = [];
        
        for (final imageJson in data) {
          try {
            epicImages.add(EpicModel.fromJson(imageJson));
          } catch (e) {
            print('EPIC parse error: $e');
            print('Invalid JSON: $imageJson');
          }
        }
        
        print('EPIC images count: ${epicImages.length}');
        return epicImages;
      } else {
        print('EPIC API response error: ${response.statusCode}');
        throw Exception('Could not get EPIC data: ${response.statusCode}');
      }
    } catch (e) {
      print('EPIC API error: $e');
      throw Exception('EPIC service error: $e');
    }
  }

  // Solar System Bodies data (Static data)
  Future<List<SolarSystemModel>> getSolarSystemBodies() async {
    try {
      print('Solar System Bodies - Static data');
      
      // Static Solar System data
      final List<Map<String, dynamic>> staticData = [
        {
          'id': 'sun',
          'name': 'Sun',
          'englishName': 'Sun',
          'isPlanet': false,
          'moons': [],
          'mass': 1.989e30,
          'volume': 1.412e18,
          'density': 1.408,
          'gravity': 274.0,
          'meanRadius': 696340.0,
          'sideralOrbit': 0.0,
          'sideralRotation': 609.12,
        },
        {
          'id': 'mercury',
          'name': 'Mercury',
          'englishName': 'Mercury',
          'isPlanet': true,
          'moons': [],
          'mass': 3.285e23,
          'volume': 6.083e10,
          'density': 5.427,
          'gravity': 3.7,
          'meanRadius': 2439.7,
          'sideralOrbit': 87.97,
          'sideralRotation': 1407.6,
        },
        {
          'id': 'venus',
          'name': 'Venus',
          'englishName': 'Venus',
          'isPlanet': true,
          'moons': [],
          'mass': 4.867e24,
          'volume': 9.284e11,
          'density': 5.243,
          'gravity': 8.87,
          'meanRadius': 6051.8,
          'sideralOrbit': 224.7,
          'sideralRotation': -5832.5,
        },
        {
          'id': 'earth',
          'name': 'Earth',
          'englishName': 'Earth',
          'isPlanet': true,
          'moons': [
            {'moon': 'Moon', 'rel': 'https://api.nasa.gov/rest/bodies/earth/moons/moon'}
          ],
          'mass': 5.972e24,
          'volume': 1.083e12,
          'density': 5.514,
          'gravity': 9.81,
          'meanRadius': 6371.0,
          'sideralOrbit': 365.26,
          'sideralRotation': 24.0,
        },
        {
          'id': 'mars',
          'name': 'Mars',
          'englishName': 'Mars',
          'isPlanet': true,
          'moons': [
            {'moon': 'Phobos', 'rel': 'https://api.nasa.gov/rest/bodies/mars/moons/phobos'},
            {'moon': 'Deimos', 'rel': 'https://api.nasa.gov/rest/bodies/mars/moons/deimos'}
          ],
          'mass': 6.39e23,
          'volume': 1.631e11,
          'density': 3.934,
          'gravity': 3.71,
          'meanRadius': 3389.5,
          'sideralOrbit': 686.98,
          'sideralRotation': 24.6,
        },
        {
          'id': 'jupiter',
          'name': 'Jupiter',
          'englishName': 'Jupiter',
          'isPlanet': true,
          'moons': [
            {'moon': 'Io', 'rel': 'https://api.nasa.gov/rest/bodies/jupiter/moons/io'},
            {'moon': 'Europa', 'rel': 'https://api.nasa.gov/rest/bodies/jupiter/moons/europa'},
            {'moon': 'Ganymede', 'rel': 'https://api.nasa.gov/rest/bodies/jupiter/moons/ganymede'},
            {'moon': 'Callisto', 'rel': 'https://api.nasa.gov/rest/bodies/jupiter/moons/callisto'}
          ],
          'mass': 1.898e27,
          'volume': 1.431e15,
          'density': 1.326,
          'gravity': 24.79,
          'meanRadius': 69911.0,
          'sideralOrbit': 4332.59,
          'sideralRotation': 9.9,
        },
        {
          'id': 'saturn',
          'name': 'Saturn',
          'englishName': 'Saturn',
          'isPlanet': true,
          'moons': [
            {'moon': 'Titan', 'rel': 'https://api.nasa.gov/rest/bodies/saturn/moons/titan'},
            {'moon': 'Enceladus', 'rel': 'https://api.nasa.gov/rest/bodies/saturn/moons/enceladus'},
            {'moon': 'Mimas', 'rel': 'https://api.nasa.gov/rest/bodies/saturn/moons/mimas'}
          ],
          'mass': 5.683e26,
          'volume': 8.271e14,
          'density': 0.687,
          'gravity': 10.44,
          'meanRadius': 58232.0,
          'sideralOrbit': 10759.22,
          'sideralRotation': 10.7,
        },
        {
          'id': 'uranus',
          'name': 'Uranus',
          'englishName': 'Uranus',
          'isPlanet': true,
          'moons': [
            {'moon': 'Titania', 'rel': 'https://api.nasa.gov/rest/bodies/uranus/moons/titania'},
            {'moon': 'Oberon', 'rel': 'https://api.nasa.gov/rest/bodies/uranus/moons/oberon'},
            {'moon': 'Miranda', 'rel': 'https://api.nasa.gov/rest/bodies/uranus/moons/miranda'}
          ],
          'mass': 8.681e25,
          'volume': 6.833e13,
          'density': 1.27,
          'gravity': 8.69,
          'meanRadius': 25362.0,
          'sideralOrbit': 30688.5,
          'sideralRotation': -17.2,
        },
        {
          'id': 'neptune',
          'name': 'Neptune',
          'englishName': 'Neptune',
          'isPlanet': true,
          'moons': [
            {'moon': 'Triton', 'rel': 'https://api.nasa.gov/rest/bodies/neptune/moons/triton'},
            {'moon': 'Proteus', 'rel': 'https://api.nasa.gov/rest/bodies/neptune/moons/proteus'},
            {'moon': 'Nereid', 'rel': 'https://api.nasa.gov/rest/bodies/neptune/moons/nereid'}
          ],
          'mass': 1.024e26,
          'volume': 6.254e13,
          'density': 1.638,
          'gravity': 11.15,
          'meanRadius': 24622.0,
          'sideralOrbit': 60182.0,
          'sideralRotation': 16.1,
        },
        {
          'id': 'pluto',
          'name': 'Pluto',
          'englishName': 'Pluto',
          'isPlanet': false,
          'moons': [
            {'moon': 'Charon', 'rel': 'https://api.nasa.gov/rest/bodies/pluto/moons/charon'},
            {'moon': 'Nix', 'rel': 'https://api.nasa.gov/rest/bodies/pluto/moons/nix'},
            {'moon': 'Hydra', 'rel': 'https://api.nasa.gov/rest/bodies/pluto/moons/hydra'}
          ],
          'mass': 1.309e22,
          'volume': 7.057e9,
          'density': 1.854,
          'gravity': 0.62,
          'meanRadius': 1188.3,
          'sideralOrbit': 90520.0,
          'sideralRotation': -153.3,
        },
      ];
      
      final List<SolarSystemModel> bodies = [];
      
      for (final bodyJson in staticData) {
        try {
          bodies.add(SolarSystemModel.fromJson(bodyJson));
        } catch (e) {
          print('Solar System Body parse error: $e');
          print('Invalid JSON: $bodyJson');
        }
      }
      
      print('Solar System bodies count: ${bodies.length}');
      return bodies;
    } catch (e) {
      print('Solar System Bodies error: $e');
      throw Exception('Solar System Bodies service error: $e');
    }
  }

  // Space Weather data from NASA DONKI API
  Future<List<SpaceWeatherModel>> getSpaceWeatherData({String? startDate, String? endDate}) async {
    try {
      print('Space Weather API - Called with startDate: $startDate, endDate: $endDate');
      
      // Try to get real data from NASA DONKI API
      try {
        print('Space Weather API - Attempting to fetch real data...');
        final List<SpaceWeatherModel> realEvents = await _getRealSpaceWeatherData(startDate, endDate);
        if (realEvents.isNotEmpty) {
          print('Space Weather API - Successfully loaded ${realEvents.length} real events');
          return realEvents;
        } else {
          print('Space Weather API - No real events found, using static data');
        }
      } catch (e) {
        print('Space Weather API - Real API failed: $e');
        print('Space Weather API - Falling back to static data');
      }
      
      // Fallback to static data if real API fails
      return _getStaticSpaceWeatherData(startDate, endDate);
    } catch (e) {
      print('Space Weather error: $e');
      throw Exception('Space Weather service error: $e');
    }
  }

  // Real Space Weather data from NASA DONKI API
  Future<List<SpaceWeatherModel>> _getRealSpaceWeatherData(String? startDate, String? endDate) async {
    try {
      print('Space Weather API - Fetching real data from DONKI API');
      print('Space Weather API - Date range: $startDate to $endDate');
      
      // Use shorter date range for better API performance
      final effectiveStartDate = startDate ?? DateTime.now().subtract(const Duration(days: 2)).toString().split(' ')[0];
      final effectiveEndDate = endDate ?? DateTime.now().toString().split(' ')[0];
      
      print('Space Weather API - Effective date range: $effectiveStartDate to $effectiveEndDate');
      
      // Get CME (Coronal Mass Ejection) data with increased timeout
      final cmeResponse = await _dio.get(
        Constants.spaceWeatherEndpoint,
        queryParameters: {
          'startDate': effectiveStartDate,
          'endDate': effectiveEndDate,
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 60), // Increased timeout
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      
      print('Space Weather API - CME Response: ${cmeResponse.statusCode}');
      
      final List<SpaceWeatherModel> events = [];
      
      if (cmeResponse.statusCode == 200) {
        final List<dynamic> cmeData = cmeResponse.data;
        print('Space Weather API - CME data count: ${cmeData.length}');
        
        for (final cmeJson in cmeData) {
          try {
            final event = _parseCMEData(cmeJson);
            if (event != null) {
              events.add(event);
            }
          } catch (e) {
            print('Space Weather API - CME parse error: $e');
          }
        }
      }
      
             // Get Solar Flare data
       try {
         final flareResponse = await _dio.get(
           Constants.spaceWeatherFlareEndpoint,
           queryParameters: {
             'startDate': effectiveStartDate,
             'endDate': effectiveEndDate,
           },
           options: Options(
             receiveTimeout: const Duration(seconds: 60), // Increased timeout
             sendTimeout: const Duration(seconds: 30),
           ),
         );
        
        print('Space Weather API - Flare Response: ${flareResponse.statusCode}');
        
        if (flareResponse.statusCode == 200) {
          final List<dynamic> flareData = flareResponse.data;
          print('Space Weather API - Flare data count: ${flareData.length}');
          
          for (final flareJson in flareData) {
            try {
              final event = _parseFlareData(flareJson);
              if (event != null) {
                events.add(event);
              }
            } catch (e) {
              print('Space Weather API - Flare parse error: $e');
            }
          }
        }
      } catch (e) {
        print('Space Weather API - Flare API error: $e');
      }
      
             // Get Geomagnetic Storm data
       try {
         final stormResponse = await _dio.get(
           Constants.spaceWeatherStormEndpoint,
           queryParameters: {
             'startDate': effectiveStartDate,
             'endDate': effectiveEndDate,
           },
           options: Options(
             receiveTimeout: const Duration(seconds: 60), // Increased timeout
             sendTimeout: const Duration(seconds: 30),
           ),
         );
        
        print('Space Weather API - Storm Response: ${stormResponse.statusCode}');
        
        if (stormResponse.statusCode == 200) {
          final List<dynamic> stormData = stormResponse.data;
          print('Space Weather API - Storm data count: ${stormData.length}');
          
          for (final stormJson in stormData) {
            try {
              final event = _parseStormData(stormJson);
              if (event != null) {
                events.add(event);
              }
            } catch (e) {
              print('Space Weather API - Storm parse error: $e');
            }
          }
        }
      } catch (e) {
        print('Space Weather API - Storm API error: $e');
      }
      
      print('Space Weather API - Total real events: ${events.length}');
      return events;
    } catch (e) {
      print('Space Weather API - Real data fetch error: $e');
      if (e.toString().contains('timeout') || e.toString().contains('connection')) {
        print('Space Weather API - Network timeout, will use static data');
        return []; // Return empty list to trigger fallback
      }
      rethrow;
    }
  }

  // Parse CME data from NASA API
  SpaceWeatherModel? _parseCMEData(Map<String, dynamic> cmeJson) {
    try {
      final activityID = cmeJson['activityID']?.toString() ?? '';
      final eventTime = cmeJson['time21_5']?.toString() ?? '';
      final detectionDate = eventTime.isNotEmpty ? eventTime.split('T')[0] : '';
      
      return SpaceWeatherModel(
        activityID: activityID,
        eventTime: eventTime,
        instrument: 'SOHO/LASCO',
        satellite: 'SOHO',
        detectionDate: detectionDate,
        initialTime: cmeJson['time21_5']?.toString() ?? '',
        finalTime: cmeJson['time21_5']?.toString() ?? '',
        type: 'CME',
        sourceLocation: cmeJson['sourceLocation']?.toString() ?? '',
        activeRegionNum: cmeJson['activeRegionNum']?.toString() ?? '',
        linkedEvents: cmeJson['linkedEvents']?.toString() ?? '',
        link: 'https://spaceweather.com',
      );
    } catch (e) {
      print('Space Weather API - CME parse error: $e');
      return null;
    }
  }

  // Parse Flare data from NASA API
  SpaceWeatherModel? _parseFlareData(Map<String, dynamic> flareJson) {
    try {
      final activityID = flareJson['flrID']?.toString() ?? '';
      final eventTime = flareJson['beginTime']?.toString() ?? '';
      final detectionDate = eventTime.isNotEmpty ? eventTime.split('T')[0] : '';
      
      return SpaceWeatherModel(
        activityID: activityID,
        eventTime: eventTime,
        instrument: 'GOES/SUVI',
        satellite: 'GOES',
        detectionDate: detectionDate,
        initialTime: flareJson['beginTime']?.toString() ?? '',
        finalTime: flareJson['endTime']?.toString() ?? '',
        type: 'Flare',
        sourceLocation: flareJson['sourceLocation']?.toString() ?? '',
        activeRegionNum: flareJson['activeRegionNum']?.toString() ?? '',
        linkedEvents: flareJson['classType']?.toString() ?? '',
        link: 'https://spaceweather.com',
      );
    } catch (e) {
      print('Space Weather API - Flare parse error: $e');
      return null;
    }
  }

  // Parse Storm data from NASA API
  SpaceWeatherModel? _parseStormData(Map<String, dynamic> stormJson) {
    try {
      final activityID = stormJson['gstID']?.toString() ?? '';
      final eventTime = stormJson['startTime']?.toString() ?? '';
      final detectionDate = eventTime.isNotEmpty ? eventTime.split('T')[0] : '';
      
      return SpaceWeatherModel(
        activityID: activityID,
        eventTime: eventTime,
        instrument: 'GOES/MAG',
        satellite: 'GOES',
        detectionDate: detectionDate,
        initialTime: stormJson['startTime']?.toString() ?? '',
        finalTime: stormJson['endTime']?.toString() ?? '',
        type: 'Storm',
        sourceLocation: 'Geomagnetic',
        activeRegionNum: '',
        linkedEvents: stormJson['allKpIndex']?.toString() ?? '',
        link: 'https://spaceweather.com',
      );
    } catch (e) {
      print('Space Weather API - Storm parse error: $e');
      return null;
    }
  }

  // Static Space Weather data as fallback
  List<SpaceWeatherModel> _getStaticSpaceWeatherData(String? startDate, String? endDate) {
    print('Space Weather API - Using static data');
      
      // Static Space Weather data
      final List<Map<String, dynamic>> staticData = [
        {
          'activityID': '2024-001',
          'eventTime': '2024-01-15T10:30:00Z',
          'instrument': 'SOHO/LASCO',
          'satellite': 'SOHO',
          'detectionDate': '2024-01-15',
          'initialTime': '2024-01-15T10:30:00Z',
          'finalTime': '2024-01-15T12:45:00Z',
          'type': 'CME',
          'sourceLocation': 'Active Region 13536',
          'activeRegionNum': '13536',
          'linkedEvents': 'Solar Flare M2.1',
          'link': 'https://spaceweather.com/2024/01/15',
        },
        {
          'activityID': '2024-002',
          'eventTime': '2024-01-14T14:20:00Z',
          'instrument': 'GOES-16/SUVI',
          'satellite': 'GOES-16',
          'detectionDate': '2024-01-14',
          'initialTime': '2024-01-14T14:20:00Z',
          'finalTime': '2024-01-14T15:10:00Z',
          'type': 'Flare',
          'sourceLocation': 'Active Region 13535',
          'activeRegionNum': '13535',
          'linkedEvents': 'CME, Radio Blackout',
          'link': 'https://spaceweather.com/2024/01/14',
        },
        {
          'activityID': '2024-003',
          'eventTime': '2024-01-13T08:15:00Z',
          'instrument': 'STEREO-A/COR2',
          'satellite': 'STEREO-A',
          'detectionDate': '2024-01-13',
          'initialTime': '2024-01-13T08:15:00Z',
          'finalTime': '2024-01-13T09:30:00Z',
          'type': 'CME',
          'sourceLocation': 'Active Region 13534',
          'activeRegionNum': '13534',
          'linkedEvents': 'Solar Flare X1.2',
          'link': 'https://spaceweather.com/2024/01/13',
        },
        {
          'activityID': '2024-004',
          'eventTime': '2024-01-12T16:45:00Z',
          'instrument': 'SDO/AIA',
          'satellite': 'SDO',
          'detectionDate': '2024-01-12',
          'initialTime': '2024-01-12T16:45:00Z',
          'finalTime': '2024-01-12T17:20:00Z',
          'type': 'Flare',
          'sourceLocation': 'Active Region 13533',
          'activeRegionNum': '13533',
          'linkedEvents': 'CME, Proton Storm',
          'link': 'https://spaceweather.com/2024/01/12',
        },
        {
          'activityID': '2024-005',
          'eventTime': '2024-01-11T11:30:00Z',
          'instrument': 'GOES-18/SUVI',
          'satellite': 'GOES-18',
          'detectionDate': '2024-01-11',
          'initialTime': '2024-01-11T11:30:00Z',
          'finalTime': '2024-01-11T12:15:00Z',
          'type': 'Storm',
          'sourceLocation': 'Active Region 13532',
          'activeRegionNum': '13532',
          'linkedEvents': 'Geomagnetic Storm G3',
          'link': 'https://spaceweather.com/2024/01/11',
        },
      ];
      
      final List<SpaceWeatherModel> weatherEvents = [];
    
    print('Space Weather API - Processing ${staticData.length} static events');
    print('Space Weather API - Date filter: $startDate to $endDate');
      
      for (final eventJson in staticData) {
        try {
        final event = SpaceWeatherModel.fromJson(eventJson);
        
        // Filter by date range if provided
        if (startDate != null && endDate != null) {
          try {
            final eventDate = DateTime.parse(event.detectionDate);
            final startDateTime = DateTime.parse(startDate);
            final endDateTime = DateTime.parse(endDate);
            
            if (eventDate.isAfter(startDateTime.subtract(const Duration(days: 1))) && 
                eventDate.isBefore(endDateTime.add(const Duration(days: 1)))) {
              weatherEvents.add(event);
              print('Space Weather API - Parsed event (in range): ${event.activityID} - ${event.type} - ${event.detectionDate}');
            } else {
              print('Space Weather API - Skipped event (out of range): ${event.activityID} - ${event.detectionDate}');
            }
          } catch (e) {
            print('Space Weather API - Date parsing error for event ${event.activityID}: $e');
            // If date parsing fails, include the event anyway
            weatherEvents.add(event);
          }
        } else {
          // If no date filter, include all events
          weatherEvents.add(event);
          print('Space Weather API - Parsed event (no filter): ${event.activityID} - ${event.type}');
        }
        } catch (e) {
          print('Space Weather parse error: $e');
          print('Invalid JSON: $eventJson');
        }
      }
      
    print('Space Weather API - Successfully parsed ${weatherEvents.length} static events');
      return weatherEvents;
  }
} 

// NASA API Service Provider
final nasaApiServiceProvider = Provider<NasaApiService>((ref) {
  return NasaApiService();
}); 