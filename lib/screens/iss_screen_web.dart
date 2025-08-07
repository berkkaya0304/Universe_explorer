// lib/screens/iss_screen_web.dart - Modern ISS Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/iss_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../constants.dart';

class IssScreen extends ConsumerStatefulWidget {
  const IssScreen({super.key});

  @override
  ConsumerState<IssScreen> createState() => _IssScreenState();
}

class _IssScreenState extends ConsumerState<IssScreen> {
  @override
  void initState() {
    super.initState();
    // Initial location update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(issLocationNotifierProvider.notifier).updateLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final issLocation = ref.watch(issLocationNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Modern Header
            _buildHeader(theme),
            
            // Content
            issLocation != null
                ? _buildIssContent(issLocation, theme)
                : _buildLoadingState(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.satellite_alt,
            color: const Color(0xFF2196F3),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ISS',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'International Space Station',
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
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.satellite_alt,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Getting ISS Location...',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loading live space station location',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssContent(issLocation, ThemeData theme) {
    return Column(
      children: [
        // Modern Info Card
        _buildModernInfoCard(issLocation, theme),
        
        // Modern Map View
        _buildModernWebMap(issLocation, theme),
      ],
    );
  }

  Widget _buildModernInfoCard(issLocation, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live Location Data',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.tertiary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: theme.colorScheme.tertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'ONLINE',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobil için dikey düzen
                return Column(
                  children: [
                    _buildInfoCard('Latitude', '${issLocation.latitude.toStringAsFixed(4)}°', Icons.explore, theme),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard('longitude', '${issLocation.longitude.toStringAsFixed(4)}°', Icons.explore_outlined, theme),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard('Height', '~408 km', Icons.height, theme),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Desktop için yatay düzen
                return Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard('Latitude', '${issLocation.latitude.toStringAsFixed(4)}°', Icons.explore, theme),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard('longitude', '${issLocation.longitude.toStringAsFixed(4)}°', Icons.explore_outlined, theme),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard('Height', '~408 km', Icons.height, theme),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernWebMap(issLocation, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ISS Icon and Animation
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.satellite_alt,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          
          // Title
          Text(
            'ISS Live Location',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Coordinates
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                _buildCoordinateRow('Latitude', '${issLocation.latitude.toStringAsFixed(4)}°', theme),
                const Divider(),
                _buildCoordinateRow('Longitude', '${issLocation.longitude.toStringAsFixed(4)}°', theme),
                const Divider(),
                _buildCoordinateRow('Height', '~408 km', theme),
                _buildCoordinateRow('Speed', '~27,600 km/h', theme),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Map Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMapButton(
                'Google Maps',
                Icons.map,
                () => _openInGoogleMaps(issLocation),
                theme,
              ),
              _buildMapButton(
                'OpenStreetMap',
                Icons.public,
                () => _openInOpenStreetMap(issLocation),
                theme,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'About ISS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'International Space Station, 408 km above the Earth, moving at 27,600 km/h. Every 90 minutes, it orbits the Earth.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinateRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(String label, IconData icon, VoidCallback onPressed, ThemeData theme) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _openInGoogleMaps(issLocation) async {
    final url = 'https://www.google.com/maps?q=${issLocation.latitude},${issLocation.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void _openInOpenStreetMap(issLocation) async {
    final url = 'https://www.openstreetmap.org/?mlat=${issLocation.latitude}&mlon=${issLocation.longitude}&zoom=3';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
} 