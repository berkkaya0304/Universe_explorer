// lib/screens/space_weather_screen.dart - Space Weather Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/nasa_api_service.dart';
import '../models/space_weather_model.dart';
import '../providers/space_weather_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class SpaceWeatherScreen extends ConsumerStatefulWidget {
  const SpaceWeatherScreen({super.key});

  @override
  ConsumerState<SpaceWeatherScreen> createState() => _SpaceWeatherScreenState();
}

class _SpaceWeatherScreenState extends ConsumerState<SpaceWeatherScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30)); // 30 days back for better API performance
  DateTime _endDate = DateTime.now();

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2010, 1, 1),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _openDetailsLink(String link) async {
    try {
      final Uri url = Uri.parse(link);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open link'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening link: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.wb_sunny,
            color: const Color(0xFFFF5722),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Space Weather',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Solar activities and space events',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _selectDateRange,
            icon: const Icon(Icons.date_range),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startDateString = DateFormat('yyyy-MM-dd').format(_startDate);
    final endDateString = DateFormat('yyyy-MM-dd').format(_endDate);
    
    print('Space Weather Screen - Date range: $startDateString to $endDateString');
    
    // Use provider instead of manual state management
    final spaceWeatherAsync = ref.watch(spaceWeatherDataProvider(
      startDate: startDateString,
      endDate: endDateString,
    ));
    
    return Scaffold(
      body: Column(
        children: [
          // Header
          _buildHeader(theme),

          // Date Range Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Date Range: ',
                  style: theme.textTheme.bodyMedium,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5722).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${DateFormat('dd/MM/yyyy').format(_startDate)} - ${DateFormat('dd/MM/yyyy').format(_endDate)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFF5722),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: spaceWeatherAsync.when(
              data: (weatherEvents) {
                if (weatherEvents.isEmpty) {
                  return _buildEmptyState(theme);
                }
                return Column(
                  children: [
                    // Stats
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 600) {
                            // Mobile vertical layout
                            return Column(
                              children: [
                                _buildStatCard(
                                  'Total',
                                  weatherEvents.length.toString(),
                                  const Color(0xFF2196F3),
                                  theme,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        'Critical',
                                        weatherEvents.where((e) => e.severity == 'Kritik').length.toString(),
                                        const Color(0xFFF44336),
                                        theme,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildStatCard(
                                        'High',
                                        weatherEvents.where((e) => e.severity == 'Yüksek').length.toString(),
                                        const Color(0xFFFF9800),
                                        theme,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            // Desktop horizontal layout
                            return Row(
                              children: [
                                _buildStatCard(
                                  'Total',
                                  weatherEvents.length.toString(),
                                  const Color(0xFF2196F3),
                                  theme,
                                ),
                                const SizedBox(width: 8),
                                _buildStatCard(
                                  'Critical',
                                  weatherEvents.where((e) => e.severity == 'Kritik').length.toString(),
                                  const Color(0xFFF44336),
                                  theme,
                                ),
                                const SizedBox(width: 8),
                                _buildStatCard(
                                  'High',
                                  weatherEvents.where((e) => e.severity == 'Yüksek').length.toString(),
                                  const Color(0xFFFF9800),
                                  theme,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    
                    // Events List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: weatherEvents.length,
                        itemBuilder: (context, index) {
                          final event = weatherEvents[index];
                          return _buildWeatherCard(event, theme);
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, stackTrace) => CustomErrorWidget(
                message: "Failed to load space weather data. Please try again.",
                onRetry: () => ref.refresh(spaceWeatherDataProvider(
                  startDate: startDateString,
                  endDate: endDateString,
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, ThemeData theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wb_sunny_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No space weather events found for this date range',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different date range',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(SpaceWeatherModel event, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: event.severityColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: event.severityColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.severity,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: event.severityColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.type.toUpperCase(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    _getEventIcon(event.type),
                    color: event.severityColor,
                    size: 24,
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Event Details
              _buildDetailRow('Event Time', event.formattedEventTime, theme),
              _buildDetailRow('Activity ID', event.activityID, theme),
              _buildDetailRow('Instrument', event.instrument, theme),
              _buildDetailRow('Satellite', event.satellite, theme),
              
              if (event.sourceLocation.isNotEmpty)
                _buildDetailRow('Source Location', event.sourceLocation, theme),
              
              if (event.activeRegionNum.isNotEmpty)
                _buildDetailRow('Active Region', event.activeRegionNum, theme),
              
              if (event.initialTime.isNotEmpty && event.finalTime.isNotEmpty) ...[
                _buildDetailRow('Start', event.initialTime, theme),
                _buildDetailRow('End', event.finalTime, theme),
              ],
              
              if (event.linkedEvents.isNotEmpty)
                _buildDetailRow('Linked Events', event.linkedEvents, theme),
              
              const SizedBox(height: 12),
              
              // Modern Action Buttons
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 400) {
                    // Mobil için dikey düzen
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                event.severityColor.withOpacity(0.8),
                                event.severityColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: event.severityColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final favoritesNotifier = ref.read(spaceWeatherFavoritesProvider.notifier);
                              if (favoritesNotifier.isFavorite(event.activityID)) {
                                favoritesNotifier.removeFromFavorites(event.activityID);
                              } else {
                                favoritesNotifier.addToFavorites(event);
                              }
                            },
                            icon: Icon(
                              ref.watch(spaceWeatherFavoritesProvider).any((element) => element.activityID == event.activityID)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                            ),
                            label: Text(
                              ref.watch(spaceWeatherFavoritesProvider).any((element) => element.activityID == event.activityID)
                                  ? 'Remove from Favorites'
                                  : 'Add to Favorites',
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
                        if (event.link.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  event.severityColor,
                                  event.severityColor.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: event.severityColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () => _openDetailsLink(event.link),
                              icon: const Icon(
                                Icons.open_in_new,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Details',
                                style: TextStyle(
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
                        ],
                      ],
                    );
                  } else {
                    // Desktop için yatay düzen
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  event.severityColor.withOpacity(0.8),
                                  event.severityColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: event.severityColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final favoritesNotifier = ref.read(spaceWeatherFavoritesProvider.notifier);
                                if (favoritesNotifier.isFavorite(event.activityID)) {
                                  favoritesNotifier.removeFromFavorites(event.activityID);
                                } else {
                                  favoritesNotifier.addToFavorites(event);
                                }
                              },
                              icon: Icon(
                                ref.watch(spaceWeatherFavoritesProvider).any((element) => element.activityID == event.activityID)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              ),
                              label: Text(
                                ref.watch(spaceWeatherFavoritesProvider).any((element) => element.activityID == event.activityID)
                                    ? 'Remove from Favorites'
                                    : 'Add to Favorites',
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
                        if (event.link.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    event.severityColor,
                                    event.severityColor.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: event.severityColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () => _openDetailsLink(event.link),
                                icon: const Icon(
                                  Icons.open_in_new,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Details',
                                  style: TextStyle(
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
                        ],
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    if (value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(String type) {
    switch (type.toLowerCase()) {
      case 'cme':
        return Icons.flash_on;
      case 'flare':
        return Icons.wb_sunny;
      case 'storm':
        return Icons.thunderstorm;
      default:
        return Icons.warning;
    }
  }
} 