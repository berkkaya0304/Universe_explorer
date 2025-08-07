// lib/screens/asteroid_screen.dart - Modern Asteroid Ekranı
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/asteroid_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../constants.dart';

class AsteroidScreen extends ConsumerStatefulWidget {
  const AsteroidScreen({super.key});

  @override
  ConsumerState<AsteroidScreen> createState() => _AsteroidScreenState();
}

class _AsteroidScreenState extends ConsumerState<AsteroidScreen> {
  @override
  Widget build(BuildContext context) {
    final asteroidsAsync = ref.watch(nextWeekAsteroidsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Modern Header
          _buildHeader(theme),
          
          // Content
          Expanded(
            child: asteroidsAsync.when(
              data: (asteroids) => _buildAsteroidContent(context, asteroids, ref, theme),
              loading: () => _buildLoadingState(theme),
              error: (error, stack) => _buildErrorState(error, ref, theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.rocket_launch,
            color: const Color(0xFFFF5722),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asteroids',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Near Earth Objects',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showInfoDialog(context),
            icon: const Icon(Icons.info_outline),
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
              Icons.rocket_launch,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Asteroid Data is being collected...',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loading asteroid data for the next 7 days',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, WidgetRef ref, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Connection Error',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'An error occurred while loading asteroid data',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(nextWeekAsteroidsProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAsteroidContent(BuildContext context, List asteroids, WidgetRef ref, ThemeData theme) {
    if (asteroids.isEmpty) {
      return _buildEmptyState(theme);
    }

    return Column(
      children: [
        // Modern İstatistikler
        _buildModernStats(asteroids, theme),
        
        // Asteroid Listesi
        Expanded(
          child: _buildAsteroidList(asteroids, theme),
        ),
      ],
    );
  }

  Widget _buildModernStats(List asteroids, ThemeData theme) {
    final totalCount = asteroids.length;
    final hazardousCount = asteroids.where((a) => a.isPotentiallyHazardous).length;
    final safeCount = totalCount - hazardousCount;

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
          Text(
            'Asteroids Near Earth in the Next 7 Days',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobil için dikey düzen
                return Column(
                  children: [
                    _buildModernStatCard(
                      'Total',
                      '$totalCount',
                      Icons.rocket_launch,
                      theme.colorScheme.primary,
                      theme,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildModernStatCard(
                            'Hazardous',
                            '$hazardousCount',
                            Icons.warning,
                            theme.colorScheme.error,
                            theme,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildModernStatCard(
                            'Safe',
                            '$safeCount',
                            Icons.check_circle,
                            theme.colorScheme.tertiary,
                            theme,
                          ),
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
                      child: _buildModernStatCard(
                        'Total',
                        '$totalCount',
                        Icons.rocket_launch,
                        theme.colorScheme.primary,
                        theme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernStatCard(
                        'Hazardous',
                        '$hazardousCount',
                        Icons.warning,
                        theme.colorScheme.error,
                        theme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernStatCard(
                        'Safe',
                        '$safeCount',
                        Icons.check_circle,
                        theme.colorScheme.tertiary,
                        theme,
                      ),
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

  Widget _buildModernStatCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
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

  Widget _buildAsteroidList(List asteroids, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: asteroids.length,
      itemBuilder: (context, index) {
        final asteroid = asteroids[index];
        return _buildModernAsteroidCard(asteroid, theme);
      },
    );
  }

  Widget _buildModernAsteroidCard(asteroid, ThemeData theme) {
    final isHazardous = asteroid.isPotentiallyHazardous;
    final favorites = ref.watch(asteroidFavoritesProvider);
    final isFavorite = favorites.any((fav) => fav.id == asteroid.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isHazardous 
              ? theme.colorScheme.error.withOpacity(0.3)
              : theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık, Tehlike Durumu ve Favori Butonu
            Row(
              children: [
                Expanded(
                  child: Text(
                    asteroid.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isHazardous 
                        ? theme.colorScheme.error.withOpacity(0.1)
                        : theme.colorScheme.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isHazardous ? Icons.warning : Icons.check_circle,
                        size: 14,
                        color: isHazardous 
                            ? theme.colorScheme.error
                            : theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isHazardous ? 'Hazardous' : 'Safe',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isHazardous 
                              ? theme.colorScheme.error
                              : theme.colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Modern Favori butonu
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isFavorite 
                          ? [const Color(0xFFff6b6b), const Color(0xFFee5a52)]
                          : [const Color(0xFF667eea), const Color(0xFF764ba2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: (isFavorite ? const Color(0xFFff6b6b) : const Color(0xFF667eea)).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (isFavorite) {
                        ref.read(asteroidFavoritesProvider.notifier).removeFromFavorites(asteroid.id);
                      } else {
                        ref.read(asteroidFavoritesProvider.notifier).addToFavorites(asteroid);
                      }
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Asteroid Bilgileri
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    'Diameter',
                    '${asteroid.estimatedDiameter.toStringAsFixed(1)} km',
                    Icons.straighten,
                    theme,
                  ),
                ),
                Expanded(
                  child: _buildInfoRow(
                    'Speed',
                    '${asteroid.velocity.toStringAsFixed(0)} km/s',
                    Icons.speed,
                    theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    'Distance',
                    '${asteroid.missDistance.toStringAsFixed(0)} km',
                    Icons.radar,
                    theme,
                  ),
                ),
                Expanded(
                  child: _buildInfoRow(
                    'Date',
                    asteroid.closeApproachDate,
                    Icons.calendar_today,
                    theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, ThemeData theme) {
    return Row(
      children: [
                 Icon(
           icon,
           size: 16,
           color: theme.colorScheme.onSurface,
         ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                             Text(
                 label,
                 style: theme.textTheme.bodySmall?.copyWith(
                   color: theme.colorScheme.onSurface,
                   fontWeight: FontWeight.w500,
                 ),
               ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 48,
                color: theme.colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Hazardous Asteroids!',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No hazardous asteroids in the next 7 days. This is good news!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(nextWeekAsteroidsProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'About Asteroid Data',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'These data are from NASA\'s NEO (Near Earth Object) program.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Hazardous asteroids are those that pass within 7.5 million km of the Earth and have a diameter of more than 140 meters.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'I understand',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
} 