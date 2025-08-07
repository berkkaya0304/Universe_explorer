// lib/screens/iss_screen.dart - ISS location screen
import 'dart:async'; // Timer için eklendi
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/iss_provider.dart';
import '../widgets/loading_widget.dart';
// import '../widgets/error_widget.dart'; // Bu import kullanılmıyor, kaldırılabilir.
// import '../constants.dart'; // Bu import kullanılmıyor, kaldırılabilir.

class IssScreen extends ConsumerStatefulWidget {
  const IssScreen({super.key});

  @override
  ConsumerState<IssScreen> createState() => _IssScreenState();
}

class _IssScreenState extends ConsumerState<IssScreen> {
  GoogleMapController? _mapController;
  Timer? _timer;
  Set<Marker> _markers = {};
  bool _mapError = false;

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında ilk konumu hemen al
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(issLocationNotifierProvider.notifier).updateLocation();
    });

    // Her 30 saniyede bir konumu güncellemek için zamanlayıcı başlat
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) { // Widget'ın hala ağaçta olduğundan emin ol
        ref.read(issLocationNotifierProvider.notifier).updateLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final issLocationAsyncValue = ref.watch(issLocationNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.satellite_alt,
                  color: Color(0xFF2196F3),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ISS Location',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Live tracking of the Space Station',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(issLocationNotifierProvider.notifier).updateLocation();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Info card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    child: issLocationAsyncValue.when(
                      data: (issLocation) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'International Space Station',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildInfoCard('Latitude', '${issLocation.latitude.toStringAsFixed(4)}°', theme),
                              _buildInfoCard('Longitude', '${issLocation.longitude.toStringAsFixed(4)}°', theme),
                              _buildInfoCard('Altitude', '~408 km', theme),
                            ],
                          ),
                        ],
                      ),
                      loading: () => const LoadingWidget(height: 100),
                      error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
                    ),
                  ),
                  
                  // Map or alternative view
                  Container(
                    height: 400, // Harita için sabit yükseklik
                    child: issLocationAsyncValue.when(
                      data: (issLocation) => _mapError
                          ? _buildFallbackMap(issLocation)
                          : _buildMap(issLocation),
                      loading: () => const LoadingWidget(height: 400),
                      error: (err, stack) => Center(child: Text('Could not load location to show map.')),
                    ),
                  ),
                ],
              ),
            ),
          ), // Expanded widget'ını kapatır
        ],   // Dıştaki Column'un children listesini kapatır
      ),     // Dıştaki Column'u kapatır
    );     // Scaffold'u ve return ifadesini kapatır
  }

  Widget _buildInfoCard(String title, String value, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(issLocation) {
    final LatLng issPosition = LatLng(
      issLocation.latitude,
      issLocation.longitude,
    );

    // Marker'ı güncelle
    _markers = {
      Marker(
        markerId: const MarkerId('iss'),
        position: issPosition,
        infoWindow: const InfoWindow(
          title: 'ISS',
          snippet: 'International Space Station',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    };

    // Harita konumu değiştiğinde kamerayı hareket ettir
    _mapController?.animateCamera(CameraUpdate.newLatLng(issPosition));

    try {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: issPosition,
          zoom: 3.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          if (mounted) {
            setState(() {
              _mapError = false;
            });
          }
        },
        mapType: MapType.hybrid,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      );
    } catch (e) {
      print('Google Maps loading error: $e');
      // Hata durumunda setState asenkron olarak çağrılmalı
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _mapError = true;
          });
        }
      });
      return _buildFallbackMap(issLocation);
    }
  }

  Widget _buildFallbackMap(issLocation) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Map could not be loaded',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ISS Location: ${issLocation.latitude.toStringAsFixed(4)}°, ${issLocation.longitude.toStringAsFixed(4)}°',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _mapError = false;
              });
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Zamanlayıcıyı iptal et
    _mapController?.dispose();
    super.dispose();
  }
}