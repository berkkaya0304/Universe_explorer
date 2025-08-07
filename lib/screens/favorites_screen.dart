// lib/screens/favorites_screen.dart - Favorites screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/apod_provider.dart';
import '../providers/mars_rover_provider.dart';
import '../providers/asteroid_provider.dart';
import '../providers/epic_provider.dart';
import '../providers/space_weather_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/safe_image_widget.dart';
import '../constants.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apodFavorites = ref.watch(apodFavoritesProvider);
    final marsRoverFavorites = ref.watch(marsRoverFavoritesProvider);
    final asteroidFavorites = ref.watch(asteroidFavoritesProvider);
    final epicFavorites = ref.watch(epicFavoritesProvider);
    final spaceWeatherFavorites = ref.watch(spaceWeatherFavoritesProvider);
    final theme = Theme.of(context);

    final totalFavorites = apodFavorites.length + marsRoverFavorites.length + asteroidFavorites.length + epicFavorites.length + spaceWeatherFavorites.length;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: const Color(0xFFE91E63),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Favorites',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Your saved space discoveries',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab bar
            Container(
              color: theme.colorScheme.primary,
              child: TabBar(
                tabs: const [
                  Tab(text: 'APOD', icon: Icon(Icons.image)),
                  Tab(text: 'Mars Rover', icon: Icon(Icons.rocket)),
                  Tab(text: 'Asteroid', icon: Icon(Icons.public)),
                  Tab(text: 'EPIC', icon: Icon(Icons.public)),
                  Tab(text: 'Space Weather', icon: Icon(Icons.wb_sunny)),
                ],
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
              ),
            ),
            // Statistics card
            Container(
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('Total', '$totalFavorites', theme.colorScheme.primary, theme),
                  _buildStatCard('APOD', '${apodFavorites.length}', theme.colorScheme.secondary, theme),
                  _buildStatCard('Mars Rover', '${marsRoverFavorites.length}', theme.colorScheme.error, theme),
                  _buildStatCard('Asteroid', '${asteroidFavorites.length}', theme.colorScheme.tertiary, theme),
                  _buildStatCard('EPIC', '${epicFavorites.length}', const Color(0xFF4CAF50), theme),
                  _buildStatCard('Space Weather', '${spaceWeatherFavorites.length}', const Color(0xFFFF5722), theme),
                ],
              ),
            ),
            
            // Tab contents
            Expanded(
              child: TabBarView(
                children: [
                  _buildApodFavorites(context, apodFavorites, ref, theme),
                  _buildMarsRoverFavorites(context, marsRoverFavorites, ref, theme),
                  _buildAsteroidFavorites(context, asteroidFavorites, ref, theme),
                  _buildEpicFavorites(context, epicFavorites, ref, theme),
                  _buildSpaceWeatherFavorites(context, spaceWeatherFavorites, ref, theme),
                ],
              ),
            ),
          ],
        ),
        ),
      );
  }

  Widget _buildStatCard(String title, String value, Color color, ThemeData theme) {
    return Card(
      color: theme.colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApodFavorites(BuildContext context, List apodFavorites, WidgetRef ref, ThemeData theme) {
    if (apodFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: theme.colorScheme.onSurface),
            const SizedBox(height: 16),
            Text(
              'No APOD favorites added yet',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: apodFavorites.length,
      itemBuilder: (context, index) {
        final apod = apodFavorites[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: SafeImageWidget(
                  imageUrl: apod.hdurl.isNotEmpty ? apod.hdurl : apod.url,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apod.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      apod.date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFff6b6b), Color(0xFFee5a52)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFff6b6b).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ref.read(apodFavoritesProvider.notifier).removeFromFavorites(apod.date);
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Remove from Favorites',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () => _showApodDetails(context, apod, theme),
                            icon: Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMarsRoverFavorites(BuildContext context, List marsRoverFavorites, WidgetRef ref, ThemeData theme) {
    if (marsRoverFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch, size: 64, color: theme.colorScheme.onSurface),
            const SizedBox(height: 16),
            Text(
              'No Mars Rover favorites added yet',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: marsRoverFavorites.length,
      itemBuilder: (context, index) {
        final photo = marsRoverFavorites[index];
        return Card(
          elevation: 4,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: SafeImageWidget(
                    imageUrl: photo.imgSrc,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      photo.roverName.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      photo.earthDate,
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFff6b6b), Color(0xFFee5a52)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFff6b6b).withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              ref.read(marsRoverFavoritesProvider.notifier).removeFromFavorites(photo.id);
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () => _showMarsRoverDetails(context, photo, theme),
                            icon: Icon(
                              Icons.info_outline,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAsteroidFavorites(BuildContext context, List asteroidFavorites, WidgetRef ref, ThemeData theme) {
    if (asteroidFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.public, size: 64, color: theme.colorScheme.onSurface),
            const SizedBox(height: 16),
            Text(
              'No Asteroid favorites added yet',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: asteroidFavorites.length,
      itemBuilder: (context, index) {
        final asteroid = asteroidFavorites[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: Icon(
              asteroid.isPotentiallyHazardous ? Icons.warning : Icons.check_circle,
              color: asteroid.isPotentiallyHazardous ? theme.colorScheme.error : theme.colorScheme.tertiary,
            ),
            title: Text(
              asteroid.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diameter: ${asteroid.estimatedDiameter.toStringAsFixed(2)} km',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                Text(
                  'Speed: ${asteroid.velocity.toStringAsFixed(0)} km/h',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                Text(
                  'Date: ${asteroid.closeApproachDate}',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFff6b6b), Color(0xFFee5a52)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFff6b6b).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      ref.read(asteroidFavoritesProvider.notifier).removeFromFavorites(asteroid.id);
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () => _showAsteroidDetails(context, asteroid, theme),
                    icon: Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showApodDetails(BuildContext context, apod, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apod.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${apod.date}',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                const SizedBox(height: 16),
                Text(
                  apod.explanation,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMarsRoverDetails(BuildContext context, photo, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeImageWidget(
                  imageUrl: photo.imgSrc,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  'Rover: ${photo.roverName.toUpperCase()}',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                Text(
                  'Camera: ${photo.cameraFullName}',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                Text(
                  'Date: ${photo.earthDate}',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                Text(
                  'ID: ${photo.id}',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAsteroidDetails(BuildContext context, asteroid, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          asteroid.name,
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diameter: ${asteroid.estimatedDiameter.toStringAsFixed(2)} km',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            Text(
              'Speed: ${asteroid.velocity.toStringAsFixed(0)} km/h',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            Text(
              'Close Approach Date: ${asteroid.closeApproachDate}',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            Text(
              'Distance: ${asteroid.missDistance.toStringAsFixed(0)} km',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            Text(
              'Hazardous: ${asteroid.isPotentiallyHazardous ? 'Yes' : 'No'}',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpicFavorites(BuildContext context, List epicFavorites, WidgetRef ref, ThemeData theme) {
    if (epicFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.public, size: 64, color: theme.colorScheme.onSurface),
            const SizedBox(height: 16),
            Text(
              'No EPIC favorites added yet',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: epicFavorites.length,
      itemBuilder: (context, index) {
        final epic = epicFavorites[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: SafeImageWidget(
                  imageUrl: epic.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      epic.caption.isNotEmpty ? epic.caption : 'World Photo',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      epic.date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Latitude: ${epic.latitude.toStringAsFixed(2)}°, Longitude: ${epic.longitude.toStringAsFixed(2)}°',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFff6b6b), Color(0xFFee5a52)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFff6b6b).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ref.read(epicFavoritesProvider.notifier).removeFromFavorites(epic.identifier);
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Remove from Favorites',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () => _showEpicDetails(context, epic, theme),
                            icon: Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpaceWeatherFavorites(BuildContext context, List spaceWeatherFavorites, WidgetRef ref, ThemeData theme) {
    if (spaceWeatherFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wb_sunny, size: 64, color: theme.colorScheme.onSurface),
            const SizedBox(height: 16),
            Text(
              'No Space Weather favorites added yet',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: spaceWeatherFavorites.length,
      itemBuilder: (context, index) {
        final weather = spaceWeatherFavorites[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: weather.severityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                weather.severity,
                style: TextStyle(
                  color: weather.severityColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(
              weather.type.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity ID: ${weather.activityID}',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                Text(
                  'Instrument: ${weather.instrument}',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                Text(
                  'Date: ${weather.formattedEventTime}',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFff6b6b), Color(0xFFee5a52)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFff6b6b).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      ref.read(spaceWeatherFavoritesProvider.notifier).removeFromFavorites(weather.activityID);
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () => _showSpaceWeatherDetails(context, weather, theme),
                    icon: Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEpicDetails(BuildContext context, epic, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeImageWidget(
                  imageUrl: epic.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  epic.caption.isNotEmpty ? epic.caption : 'World Photo',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${epic.date}',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                Text(
                  'Latitude: ${epic.latitude.toStringAsFixed(2)}°',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                Text(
                  'Longitude: ${epic.longitude.toStringAsFixed(2)}°',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                Text(
                  'Identifier: ${epic.identifier}',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSpaceWeatherDetails(BuildContext context, weather, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          weather.type.toUpperCase(),
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity ID: ${weather.activityID}',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            Text(
              'Event Time: ${weather.formattedEventTime}',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            Text(
              'Instrument: ${weather.instrument}',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            Text(
              'Satellite: ${weather.satellite}',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            if (weather.sourceLocation.isNotEmpty)
              Text(
                'Source Location: ${weather.sourceLocation}',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            if (weather.activeRegionNum.isNotEmpty)
              Text(
                'Active Region: ${weather.activeRegionNum}',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            Text(
              'Severity: ${weather.severity}',
              style: TextStyle(color: weather.severityColor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
} 