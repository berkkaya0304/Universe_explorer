// lib/screens/home_screen.dart - Modern Home Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/apod_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/safe_image_widget.dart';
import '../services/download_service.dart';
import '../constants.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apodAsync = ref.watch(todayApodProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: apodAsync.when(
        data: (apod) => _buildApodContent(context, apod, ref, theme),
        loading: () => _buildLoadingState(theme),
        error: (error, stack) => _buildErrorState(error, ref, theme),
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
            'Data is being collected from space...',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loading today\'s photo from NASA',
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
                Icons.satellite_alt,
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
              'Could not connect to NASA servers',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(todayApodProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApodContent(BuildContext context, apod, WidgetRef ref, ThemeData theme) {
    return CustomScrollView(
      slivers: [
        // Hero Header
        SliverToBoxAdapter(
          child: _buildHeroHeader(apod, ref, theme),
        ),
        
        // Content
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Title Section
              _buildTitleSection(apod, theme),
              const SizedBox(height: 24),
              
              // Image Section
              _buildImageSection(apod, theme, context),
              const SizedBox(height: 24),
              
              // Description Section
              _buildDescriptionSection(apod, theme),
              const SizedBox(height: 24),
              
              // Action Buttons
              _buildActionButtons(apod, ref, theme),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroHeader(apod, WidgetRef ref, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.photo_camera,
            color: const Color(0xFF2196F3),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Photo',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  apod.date?.isNotEmpty == true ? apod.date : DateTime.now().toString().split(' ')[0],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ref.invalidate(todayApodProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(apod, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          apod.title?.isNotEmpty == true ? apod.title : 'Günün Astronomi Fotoğrafı',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        if (apod.copyright?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.copyright,
                size: 16,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 4),
              Text(
                apod.copyright,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildImageSection(apod, ThemeData theme, BuildContext context) {
    // Get the best available image URL
    String imageUrl = '';
    if (apod.hdurl != null && apod.hdurl.isNotEmpty) {
      imageUrl = apod.hdurl;
    } else if (apod.url != null && apod.url.isNotEmpty) {
      imageUrl = apod.url;
    }
    
    print('APOD Image URL: $imageUrl');
    print('APOD HD URL: ${apod.hdurl}');
    print('APOD URL: ${apod.url}');
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: imageUrl.isNotEmpty
                ? SafeImageWidget(
                    imageUrl: imageUrl,
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 400,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Image not available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          // Download button overlay
          if (imageUrl.isNotEmpty)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    DownloadService.showImageOptionsDialog(
                      context,
                      imageUrl,
                      apod.title?.isNotEmpty == true ? apod.title : 'NASA Image',
                    );
                  },
                  icon: const Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 24,
                  ),
                  tooltip: 'Download Image',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(apod, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            apod.explanation?.isNotEmpty == true 
                ? apod.explanation 
                : 'Bu görsel için açıklama mevcut değil. NASA API\'den veri alınamadığında bu mesaj görünür.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(apod, WidgetRef ref, ThemeData theme) {
    final isFavorite = ref.watch(apodFavoritesProvider).any((item) => item.date == apod.date);
    
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isFavorite 
                    ? [const Color(0xFFff6b6b), const Color(0xFFee5a52)]
                    : [const Color(0xFF667eea), const Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (isFavorite ? const Color(0xFFff6b6b) : const Color(0xFF667eea)).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                if (isFavorite) {
                  ref.read(apodFavoritesProvider.notifier).removeFromFavorites(apod.date);
                } else {
                  ref.read(apodFavoritesProvider.notifier).addToFavorites(apod);
                }
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              label: Text(
                isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF667eea).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: OutlinedButton.icon(
              onPressed: () {
                // Share functionality
              },
              icon: const Icon(
                Icons.share,
                color: Color(0xFF667eea),
              ),
              label: const Text(
                'Share',
                style: TextStyle(
                  color: Color(0xFF667eea),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),  
      ],
    );
  }
}

 