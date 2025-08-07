// lib/screens/apod_history_screen.dart - APOD History Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/apod_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/safe_image_widget.dart';
import '../services/download_service.dart';
import '../constants.dart';

class ApodHistoryScreen extends ConsumerStatefulWidget {
  const ApodHistoryScreen({super.key});

  @override
  ConsumerState<ApodHistoryScreen> createState() => _ApodHistoryScreenState();
}

class _ApodHistoryScreenState extends ConsumerState<ApodHistoryScreen> {
  String _startDate = '';
  String _endDate = '';
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _showFavoritesOnly = false;
  bool _showStatistics = false;
  bool _showFilters = false;

  final List<String> _filterOptions = [
    'All',
    'Images',
    'Videos',
    'With Copyright',
    'Without Copyright',
  ];

  @override
  void initState() {
    super.initState();
    _setDefaultDates();
  }

  void _setDefaultDates() {
    final now = DateTime.now();
    final endDate = now.subtract(const Duration(days: 1));
    final startDate = endDate.subtract(const Duration(days: 29)); // Last 30 days

    _selectedStartDate = startDate;
    _selectedEndDate = endDate;
    _startDate = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    _endDate = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final apodHistoryAsync = ref.watch(apodHistoryProvider(
      startDate: _startDate,
      endDate: _endDate,
    ));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Enhanced Header with Search
          _buildEnhancedHeader(theme),
          
          // Search Bar
          _buildSearchBar(theme),
          
          // Collapsible Filter Bar
          if (_showFilters) _buildFilterBar(theme),
          
          // Statistics Card (Collapsible)
          if (_showStatistics) _buildStatisticsCard(theme),
          
          // APOD list
          Expanded(
            child: apodHistoryAsync.when(
              data: (apodList) => _buildApodList(_filterAndSearchApodList(apodList), theme),
              loading: () => const Center(
                child: LoadingWidget(height: 400),
              ),
              error: (error, stack) => ApiErrorWidget(
                errorMessage: error.toString(),
                onRetry: () => ref.invalidate(apodHistoryProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(
            Icons.history,
            color: Color(0xFF3F51B5),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'APOD History',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Astronomy Picture Archive',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _showFilters = !_showFilters),
            icon: const Icon(Icons.filter_list),
            tooltip: 'Show Filters',
          ),
          IconButton(
            onPressed: () => setState(() => _showStatistics = !_showStatistics),
            icon: const Icon(Icons.analytics),
            tooltip: 'Show Statistics',
          ),
          IconButton(
            onPressed: _showDateRangePicker,
            icon: const Icon(Icons.date_range),
            tooltip: 'Select Date Range',
          ),
        ],
      ),
    );
  }



  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: TextStyle(color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: 'Search APOD titles and descriptions...',
          hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () => setState(() => _searchQuery = ''),
                  icon: Icon(Icons.clear, color: theme.colorScheme.primary),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Filter Options',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Filter Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _filterOptions.map((String option) {
              final isSelected = _selectedFilter == option;
              return FilterChip(
                label: Text(
                  option,
                  style: TextStyle(
                    color: isSelected 
                        ? theme.colorScheme.onPrimary 
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedFilter = option;
                  });
                },
                backgroundColor: theme.colorScheme.surface,
                selectedColor: theme.colorScheme.primary,
                checkmarkColor: theme.colorScheme.onPrimary,
                side: BorderSide(
                  color: isSelected 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.outline.withOpacity(0.3),
                ),
                elevation: isSelected ? 4 : 0,
                pressElevation: 2,
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Favorites Toggle
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: _showFavoritesOnly 
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _showFavoritesOnly 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: InkWell(
              onTap: () => setState(() => _showFavoritesOnly = !_showFavoritesOnly),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
                      color: _showFavoritesOnly 
                          ? theme.colorScheme.primary 
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Show Favorites Only',
                      style: TextStyle(
                        color: _showFavoritesOnly 
                            ? theme.colorScheme.primary 
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    if (_showFavoritesOnly)
                      Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Statistics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer(
            builder: (context, ref, child) {
              final apodHistoryAsync = ref.watch(apodHistoryProvider(
                startDate: _startDate,
                endDate: _endDate,
              ));
              
              return apodHistoryAsync.when(
                data: (apodList) {
                  final totalApods = apodList.length;
                  final images = apodList.where((apod) => apod.mediaType == 'image').length;
                  final videos = apodList.where((apod) => apod.mediaType == 'video').length;
                  final withCopyright = apodList.where((apod) => apod.copyright.isNotEmpty).length;
                  final favorites = ref.watch(apodFavoritesProvider).length;
                  
                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatItem('Total', totalApods.toString(), Icons.image, theme),
                      ),
                      Expanded(
                        child: _buildStatItem('Images', images.toString(), Icons.photo, theme),
                      ),
                      Expanded(
                        child: _buildStatItem('Videos', videos.toString(), Icons.video_library, theme),
                      ),
                      Expanded(
                        child: _buildStatItem('Favorites', favorites.toString(), Icons.favorite, theme),
                      ),
                    ],
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(color: theme.colorScheme.primary),
                ),
                error: (error, stack) => Text(
                  'Error loading statistics',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  List _filterAndSearchApodList(List apodList) {
    List filteredList = List.from(apodList);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((apod) {
        final query = _searchQuery.toLowerCase();
        return apod.title.toLowerCase().contains(query) ||
               apod.explanation.toLowerCase().contains(query) ||
               apod.copyright.toLowerCase().contains(query);
      }).toList();
    }

    // Apply media type filter
    switch (_selectedFilter) {
      case 'Images':
        filteredList = filteredList.where((apod) => apod.mediaType == 'image').toList();
        break;
      case 'Videos':
        filteredList = filteredList.where((apod) => apod.mediaType == 'video').toList();
        break;
      case 'With Copyright':
        filteredList = filteredList.where((apod) => apod.copyright.isNotEmpty).toList();
        break;
      case 'Without Copyright':
        filteredList = filteredList.where((apod) => apod.copyright.isEmpty).toList();
        break;
    }

    // Apply favorites filter
    if (_showFavoritesOnly) {
      final favorites = ref.read(apodFavoritesProvider);
      filteredList = filteredList.where((apod) {
        return favorites.any((favorite) => favorite.date == apod.date);
      }).toList();
    }

    return filteredList;
  }

  String _formatDateForDisplay(String date) {
    final parts = date.split('-');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return date;
  }

  Widget _buildApodList(List apodList, ThemeData theme) {
    if (apodList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty || _selectedFilter != 'All' || _showFavoritesOnly
                  ? Icons.search_off
                  : Icons.image_not_supported,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No APODs found matching your search.'
                  : _showFavoritesOnly
                      ? 'No favorite APODs found.'
                      : 'No APOD data found for this date range.',
              style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms.'
                  : 'Try selecting a different date range or filter.',
              style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: apodList.length,
      itemBuilder: (context, index) {
        final apod = apodList[index];
        final isFavorite = ref.watch(apodFavoritesProvider).any((element) => element.date == apod.date);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Image Section
              Stack(
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
                  
                  // Media Type Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: apod.mediaType == 'video' 
                            ? Colors.red.withOpacity(0.8)
                            : Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        apod.mediaType.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
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
                          final imageUrl = apod.hdurl.isNotEmpty ? apod.hdurl : apod.url;
                          DownloadService.showImageOptionsDialog(
                            context,
                            imageUrl,
                            apod.title.isNotEmpty ? apod.title : 'NASA Image',
                          );
                        },
                        icon: Icon(
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
              
              // Enhanced Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date with enhanced styling
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        apod.date,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Title with enhanced styling
                    Text(
                      apod.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Copyright with enhanced styling
                    if (apod.copyright.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Text(
                          '© ${apod.copyright}',
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    
                    // Enhanced description
                    Text(
                      apod.explanation,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    
                    // Enhanced action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final favoritesNotifier = ref.read(apodFavoritesProvider.notifier);
                              if (isFavorite) {
                                favoritesNotifier.removeFromFavorites(apod.date);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Removed from favorites'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              } else {
                                favoritesNotifier.addToFavorites(apod);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Added to favorites'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                            ),
                            label: Text(
                              isFavorite ? 'Remove' : 'Favorite',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFavorite 
                                  ? Colors.red.withOpacity(0.1)
                                  : theme.colorScheme.primary,
                              foregroundColor: isFavorite ? Colors.red : Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showApodDetails(context, apod),
                            icon: Icon(Icons.info_outline, size: 18),
                            label: Text(
                              'Details',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: theme.colorScheme.primary),
                              foregroundColor: theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
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
      },
    );
  }

  void _showDateRangePicker() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: theme.colorScheme.surface,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Text(
            'Select Date Range',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modern start date selection
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    'Start Date',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    _selectedStartDate != null 
                      ? '${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}'
                      : 'Date not selected',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => _selectStartDate(context),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurface),
                ),
              ),
              
              // Modern end date selection
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    'End Date',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    _selectedEndDate != null 
                      ? '${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}'
                      : 'Date not selected',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => _selectEndDate(context),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurface),
                ),
              ),
              
              // Quick selection options
              Text(
                'Quick Selection',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildQuickDateButton('Last 7 Days', 7),
                  _buildQuickDateButton('Last 30 Days', 30),
                  _buildQuickDateButton('Last 90 Days', 90),
                  _buildQuickDateButton('Last Year', 365),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: theme.colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedStartDate != null && _selectedEndDate != null
                        ? () {
                            _updateDateRange();
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDateButton(String label, int days) {
    return ElevatedButton(
      onPressed: () {
        final now = DateTime.now();
        final endDate = now.subtract(const Duration(days: 1));
        final startDate = endDate.subtract(Duration(days: days - 1));
        
        setState(() {
          _selectedStartDate = startDate;
          _selectedEndDate = endDate;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _selectStartDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(1995, 6, 16), // APOD başlangıç tarihi
      lastDate: DateTime.now().subtract(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.brightness == Brightness.dark
                ? ColorScheme.dark(
                    primary: theme.colorScheme.primary,
                    surface: theme.colorScheme.surface,
                    onSurface: theme.colorScheme.onSurface,
                    onPrimary: theme.colorScheme.onPrimary,
                  )
                : ColorScheme.light(
                    primary: theme.colorScheme.primary,
                    surface: theme.colorScheme.surface,
                    onSurface: theme.colorScheme.onSurface,
                    onPrimary: theme.colorScheme.onPrimary,
                  ),
            dialogBackgroundColor: theme.colorScheme.surface,
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? DateTime.now().subtract(const Duration(days: 1)),
      firstDate: DateTime(1995, 6, 16), // APOD başlangıç tarihi
      lastDate: DateTime.now().subtract(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.brightness == Brightness.dark
                ? ColorScheme.dark(
                    primary: theme.colorScheme.primary,
                    surface: theme.colorScheme.surface,
                    onSurface: theme.colorScheme.onSurface,
                    onPrimary: theme.colorScheme.onPrimary,
                  )
                : ColorScheme.light(
                    primary: theme.colorScheme.primary,
                    surface: theme.colorScheme.surface,
                    onSurface: theme.colorScheme.onSurface,
                    onPrimary: theme.colorScheme.onPrimary,
                  ),
            dialogBackgroundColor: theme.colorScheme.surface,
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  void _updateDateRange() {
    if (_selectedStartDate != null && _selectedEndDate != null) {
      // Başlangıç tarihi bitiş tarihinden büyükse değiştir
      if (_selectedStartDate!.isAfter(_selectedEndDate!)) {
        final temp = _selectedStartDate;
        _selectedStartDate = _selectedEndDate;
        _selectedEndDate = temp;
      }
      
      setState(() {
        _startDate = '${_selectedStartDate!.year}-${_selectedStartDate!.month.toString().padLeft(2, '0')}-${_selectedStartDate!.day.toString().padLeft(2, '0')}';
        _endDate = '${_selectedEndDate!.year}-${_selectedEndDate!.month.toString().padLeft(2, '0')}-${_selectedEndDate!.day.toString().padLeft(2, '0')}';
      });
      
      // Provider'ı yenile
      ref.invalidate(apodHistoryProvider);
    }
  }

  void _showApodDetails(BuildContext context, apod) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.95,
                  builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with image
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SafeImageWidget(
                            imageUrl: apod.hdurl.isNotEmpty ? apod.hdurl : apod.url,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Title and date
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  apod.title,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    apod.date,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final imageUrl = apod.hdurl.isNotEmpty ? apod.hdurl : apod.url;
                              DownloadService.showImageOptionsDialog(
                                context,
                                imageUrl,
                                apod.title.isNotEmpty ? apod.title : 'NASA Image',
                              );
                            },
                            icon: Icon(Icons.download, color: Theme.of(context).colorScheme.primary),
                            tooltip: 'Download Image',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Media type and copyright info
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: apod.mediaType == 'video' 
                                  ? Colors.red.withOpacity(0.1)
                                  : Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: apod.mediaType == 'video' 
                                    ? Colors.red.withOpacity(0.3)
                                    : Colors.green.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              apod.mediaType.toUpperCase(),
                              style: TextStyle(
                                color: apod.mediaType == 'video' ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (apod.copyright.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                                ),
                                child: Text(
                                  '© ${apod.copyright}',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Full explanation
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        apod.explanation,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final favoritesNotifier = ref.read(apodFavoritesProvider.notifier);
                                final isFavorite = ref.read(apodFavoritesProvider).any((element) => element.date == apod.date);
                                
                                if (isFavorite) {
                                  favoritesNotifier.removeFromFavorites(apod.date);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Removed from favorites'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                } else {
                                  favoritesNotifier.addToFavorites(apod);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added to favorites'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                              icon: Consumer(
                                builder: (context, ref, child) {
                                  final isFavorite = ref.watch(apodFavoritesProvider).any((element) => element.date == apod.date);
                                  return Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    size: 20,
                                  );
                                },
                              ),
                              label: Consumer(
                                builder: (context, ref, child) {
                                  final isFavorite = ref.watch(apodFavoritesProvider).any((element) => element.date == apod.date);
                                  return Text(
                                    isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                                    style: TextStyle(fontSize: 14),
                                  );
                                },
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}