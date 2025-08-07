// lib/screens/solar_system_screen.dart - Solar System Bodies Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/solar_system_model.dart';
import '../providers/solar_system_provider.dart'; // Yeni provider dosyamız
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class SolarSystemScreen extends ConsumerWidget {
  const SolarSystemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final solarSystemAsyncValue = ref.watch(solarSystemProvider);
    final filteredBodies = ref.watch(filteredSolarSystemProvider);

    return Scaffold(
      body: Column(
        children: [
          // Header
          _buildHeader(theme, () => ref.refresh(solarSystemProvider)),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                ref.read(solarSystemSearchQueryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                hintText: 'Search for a celestial body...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
            ),
          ),

          // Stats - Veri gelince göster
          solarSystemAsyncValue.when(
            data: (bodies) => _buildStatsSection(bodies, filteredBodies, theme),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(child: Text("Loading stats...")),
            ),
            error: (e, s) => const SizedBox.shrink(),
          ),

          // Content
          Expanded(
            child: solarSystemAsyncValue.when(
              data: (_) => _buildContent(filteredBodies, ref.watch(solarSystemSearchQueryProvider), theme),
              loading: () => const LoadingWidget(),
              error: (error, stack) => CustomErrorWidget(
                message: "Failed to load Solar System data.",
                onRetry: () => ref.refresh(solarSystemProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, VoidCallback onRefresh) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny_outlined, color: Color(0xFFFF9800), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Solar System', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('Planets and Celestial Bodies', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
              ],
            ),
          ),
          IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
        ],
      ),
    );
  }

  Widget _buildStatsSection(List<SolarSystemModel> allBodies, List<SolarSystemModel> filteredBodies, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Row(
        children: [
          _buildStatCard('Total', allBodies.length.toString(), const Color(0xFF2196F3), theme),
          const SizedBox(width: 8),
          _buildStatCard('Planets', allBodies.where((b) => b.isPlanet).length.toString(), const Color(0xFF4CAF50), theme),
          const SizedBox(width: 8),
          _buildStatCard('Found', filteredBodies.length.toString(), const Color(0xFFFF9800), theme),
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
        ),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<SolarSystemModel> filteredBodies, String searchQuery, ThemeData theme) {
    if (filteredBodies.isEmpty && searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No results found for "$searchQuery"'),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredBodies.length,
      itemBuilder: (context, index) {
        final body = filteredBodies[index];
        return _buildBodyCard(body, theme);
      },
    );
  }

  Widget _buildBodyCard(SolarSystemModel body, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: (body.isPlanet ? Colors.green : Colors.orange).withOpacity(0.1),
          child: Icon(body.isPlanet ? Icons.public : Icons.star_border, color: body.isPlanet ? Colors.green : Colors.orange),
        ),
        title: Text(body.englishName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                 subtitle: Text(body.isPlanet ? 'Planet' : 'Celestial Body'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Mass (10^24 kg)', body.mass > 0 ? body.mass.toStringAsFixed(2) : 'N/A', theme),
                _buildInfoRow('Gravity (m/s²)', body.gravity > 0 ? body.gravity.toStringAsFixed(2) : 'N/A', theme),
                _buildInfoRow('Mean Radius (km)', body.meanRadius > 0 ? body.meanRadius.toStringAsFixed(0) : 'N/A', theme),
                if (body.moons.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow('Moons', body.moons.length.toString(), theme),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    if (value.isEmpty || value == 'N/A') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}