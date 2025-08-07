// lib/screens/mars_rover_screen.dart - Modern Mars Rover Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../providers/mars_rover_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/safe_image_widget.dart';
import '../services/download_service.dart';
import '../constants.dart';

class MarsRoverScreen extends ConsumerStatefulWidget {
  const MarsRoverScreen({super.key});

  @override
  ConsumerState<MarsRoverScreen> createState() => _MarsRoverScreenState();
}

class _MarsRoverScreenState extends ConsumerState<MarsRoverScreen> {
  String? selectedCamera;

  @override
  Widget build(BuildContext context) {
    final selectedRover = ref.watch(selectedRoverProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final theme = Theme.of(context);
    
    final marsPhotosAsync = ref.watch(marsRoverPhotosProvider(
      rover: selectedRover,
      earthDate: selectedDate,
      camera: selectedCamera,
    ));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Modern Header
          _buildHeader(theme),
          
          // Modern Filters
          _buildModernFilters(theme),
          
          // Photo list
          Expanded(
            child: marsPhotosAsync.when(
              data: (photos) => photos.isEmpty 
                  ? _buildEmptyState(theme)
                  : _buildPhotoGrid(photos, theme),
              loading: () => _buildLoadingState(theme),
              error: (error, stack) => _buildErrorState(error, theme),
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
            Icons.camera_alt,
            color: const Color(0xFFE91E63),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mars Rover',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Red Planet Photos',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFilters(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
            children: [
              Icon(
                Icons.tune,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Filters',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildModernRoverDropdown(theme),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModernDatePicker(theme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernRoverDropdown(ThemeData theme) {
    final selectedRover = ref.watch(selectedRoverProvider);
    
    return DropdownButtonFormField<String>(
      value: selectedRover,
      decoration: InputDecoration(
        labelText: 'Choose Rover',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      dropdownColor: theme.colorScheme.surface,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 14,
      ),
      items: Constants.roverNames.map((rover) {
        return DropdownMenuItem(
          value: rover,
          child: Row(
            children: [
              Icon(
                Icons.rocket_launch,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(rover.toUpperCase()),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          ref.read(selectedRoverProvider.notifier).setRover(value);
        }
      },
    );
  }

  Widget _buildModernDatePicker(ThemeData theme) {
    final selectedDate = ref.watch(selectedDateProvider);
    
    return InkWell(
      onTap: _showDatePicker,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceVariant,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ],
        ),
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
              Icons.camera_alt,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Taking Photos from Mars...',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loading photos from selected rover',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, ThemeData theme) {
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
              'An error occurred while loading Mars Rover photos',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(marsRoverPhotosProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(List photos, ThemeData theme) {
    return MasonryGridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return _buildModernPhotoCard(photo, theme);
      },
    );
  }

  Widget _buildModernPhotoCard(photo, ThemeData theme) {
    final favorites = ref.watch(marsRoverFavoritesProvider);
    final isFavorite = favorites.any((fav) => fav.id == photo.id);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: theme.colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo and Favorite Button
              Stack(
                children: [
                  SafeImageWidget(
                    imageUrl: photo.imgSrc,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Modern Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isFavorite 
                              ? [const Color(0xFFff6b6b), const Color(0xFFee5a52)]
                              : [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isFavorite ? const Color(0xFFff6b6b) : Colors.black).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (isFavorite) {
                            ref.read(marsRoverFavoritesProvider.notifier).removeFromFavorites(photo.id);
                          } else {
                            ref.read(marsRoverFavoritesProvider.notifier).addToFavorites(photo);
                          }
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Download button
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {
                          DownloadService.showImageOptionsDialog(
                            context,
                            photo.imgSrc,
                            'Mars Rover Photo - ${photo.roverName}',
                          );
                        },
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 20,
                        ),
                        tooltip: 'Download Image',
                      ),
                    ),
                  ),
                ],
              ),
              
              // Information
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rover name
                    Row(
                      children: [
                                                 Icon(
                           Icons.rocket_launch,
                           size: 16,
                           color: theme.colorScheme.primary,
                         ),
                         const SizedBox(width: 4),
                         Text(
                           photo.roverName.toUpperCase(),
                           style: theme.textTheme.titleSmall?.copyWith(
                             fontWeight: FontWeight.bold,
                             color: theme.colorScheme.primary,
                           ),
                         ),
                       ],
                     ),
                     const SizedBox(height: 8),
                     
                     // Camera name
                     Row(
                       children: [
                         Icon(
                           Icons.camera_alt,
                           size: 14,
                           color: theme.colorScheme.onSurface,
                         ),
                         const SizedBox(width: 4),
                         Expanded(
                           child: Text(
                             photo.cameraFullName,
                             style: theme.textTheme.bodySmall?.copyWith(
                               color: theme.colorScheme.onSurface,
                             ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                                         // Date
                     Row(
                       children: [
                         Icon(
                           Icons.calendar_today,
                           size: 14,
                           color: theme.colorScheme.onSurface,
                         ),
                         const SizedBox(width: 4),
                         Text(
                           photo.earthDate,
                           style: theme.textTheme.bodySmall?.copyWith(
                             color: theme.colorScheme.onSurface,
                           ),
                         ),
                       ],
                     ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
                color: theme.colorScheme.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.photo_camera,
                size: 48,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Photo Found',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No photos found for the selected date. Try a different date or rover.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Last 30 days
                    final now = DateTime.now();
                    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
                    ref.read(selectedDateProvider.notifier).setDate(
                      '${thirtyDaysAgo.year}-${thirtyDaysAgo.month.toString().padLeft(2, '0')}-${thirtyDaysAgo.day.toString().padLeft(2, '0')}',
                    );
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('Last 30 Days'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Reliable date
                    ref.read(selectedDateProvider.notifier).setDate('2024-01-15');
                  },
                  icon: const Icon(Icons.star),
                  label: const Text('Reliable Date'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() {
    final selectedDate = ref.read(selectedDateProvider);
    final currentDate = DateTime.parse(selectedDate);
    
    showDatePicker(
      context: context,
      initialDate: currentDate,
              firstDate: DateTime(2004), // First rover landing date
      lastDate: DateTime.now(),
              helpText: 'Select Photo Date',
              cancelText: 'Cancel',
        confirmText: 'Select',
    ).then((date) {
      if (date != null) {
        final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        ref.read(selectedDateProvider.notifier).setDate(formattedDate);
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildFilterDialog(),
    );
  }

  Widget _buildFilterDialog() {
    final theme = Theme.of(context);
    final cameras = Constants.cameras;
    
    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      title: Text(
        'Camera Filters',
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'All Cameras',
              style: TextStyle(
                color: selectedCamera == null 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.onSurface,
              ),
            ),
                         leading: Icon(
               Icons.camera_alt,
               color: selectedCamera == null 
                   ? theme.colorScheme.primary 
                   : Colors.black,
             ),
            onTap: () {
              setState(() {
                selectedCamera = null;
              });
              Navigator.pop(context);
            },
          ),
          ...cameras.map((camera) => ListTile(
            title: Text(
              camera,
              style: TextStyle(
                color: selectedCamera == camera 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.onSurface,
              ),
            ),
                         leading: Icon(
               Icons.camera,
               color: selectedCamera == camera 
                   ? theme.colorScheme.primary 
                   : Colors.black,
             ),
            onTap: () {
              setState(() {
                selectedCamera = camera;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
} 