// lib/screens/epic_screen.dart - EPIC Earth Images Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/epic_model.dart';
import '../providers/epic_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../services/download_service.dart';

class EpicScreen extends ConsumerStatefulWidget {
  const EpicScreen({super.key});

  @override
  ConsumerState<EpicScreen> createState() => _EpicScreenState();
}

class _EpicScreenState extends ConsumerState<EpicScreen> {
  // Yalnızca kullanıcı tarafından seçilen tarihi saklıyoruz.
  // Geri kalan her şeyi (yüklenme, hata, veri) provider yönetecek.
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 6, 1), // EPIC verilerinin başlangıç tarihi
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      // Veri yükleme çağrısına gerek yok, build metodu tarihi izleyerek
      // provider'ı otomatik olarak güncelleyecek.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
    // Yeni provider'ı izle. Tarih değiştiğinde Riverpod otomatik olarak
    // yeni veriyi getirecektir.
    final epicDataAsync = ref.watch(epicDataProvider(date: dateString));
    
    return Scaffold(
      body: Column(
        children: [
          // Header
          _buildHeader(theme),

          // Date Display
          _buildDateDisplay(theme),

          // Content
          Expanded(
            child: epicDataAsync.when(
              data: (images) {
                if (images.isEmpty) {
                  return _buildEmptyState(theme);
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final image = images[index];
                    return _buildEpicCard(image, theme);
                  },
                );
              },
              loading: () => const LoadingWidget(),
                             error: (error, stackTrace) => CustomErrorWidget(
                 message: "Failed to load images for this date. Please try another.",
                 onRetry: () => ref.refresh(epicDataProvider(date: dateString)),
               ),
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
          const Icon(
            Icons.public,
            color: Color(0xFF4CAF50),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earth Photos',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'EPIC - Earth Polychromatic Imaging Camera',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_today),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDisplay(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.colorScheme.surface.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Selected Date: ',
            style: theme.textTheme.bodyMedium,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              DateFormat('dd MMMM yyyy').format(_selectedDate),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4CAF50),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No photos found for this date.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different date.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpicCard(EpicModel image, ThemeData theme) {
    // Favori durumunu kontrol et - provider'ı watch ile izle
    final favoritesNotifier = ref.read(epicFavoritesProvider.notifier);
    final favorites = ref.watch(epicFavoritesProvider);
    final isFavorite = favorites.any((element) => element.identifier == image.identifier);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    image.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
              // Download button overlay
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      DownloadService.showImageOptionsDialog(
                        context,
                        image.imageUrl,
                        image.caption.isNotEmpty ? image.caption : 'EPIC Earth Image',
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

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  image.caption.isNotEmpty ? image.caption : 'World Photo',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Actions (simplified button logic)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (isFavorite) {
                            favoritesNotifier.removeFromFavorites(image.identifier);
                          } else {
                            favoritesNotifier.addToFavorites(image);
                          }
                        },
                        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                        label: Text(isFavorite ? 'Remove Favorite' : 'Add to Favorites'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFavorite ? Colors.pink[400] : theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
  }
}