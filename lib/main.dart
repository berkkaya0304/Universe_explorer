// lib/main.dart - Modern Universe Explorer App
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Providers
import 'providers/theme_provider.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/apod_history_screen.dart';
import 'screens/mars_rover_screen.dart';
import 'screens/asteroid_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/iss_screen_web.dart';
import 'screens/epic_screen.dart';
import 'screens/solar_system_screen.dart';
import 'screens/space_weather_screen.dart';

// Constants
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  if (kIsWeb) {
    print('🚀 Universe Explorer Web Platformunda Çalışıyor');
  }
  
  runApp(const ProviderScope(child: NasaExplorerApp()));
}

class NasaExplorerApp extends ConsumerWidget {
  const NasaExplorerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);

    return MaterialApp(
      title: 'Universe Explorer',
      theme: themeData,
      themeMode: themeMode,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.rocket_launch,
      label: 'Home',
      screen: const HomeScreen(),
      color: const Color(0xFF0B3D91),
    ),
    NavigationItem(
      icon: Icons.history,
      label: 'APOD History',
      screen: const ApodHistoryScreen(),
      color: const Color(0xFF6B46C1),
    ),
    NavigationItem(
      icon: Icons.camera_alt,
      label: 'Mars Rover',
      screen: const MarsRoverScreen(),
      color: const Color(0xFFFF6B35),
    ),
    NavigationItem(
      icon: Icons.rocket_launch,
      label: 'Asteroids',
      screen: const AsteroidScreen(),
      color: const Color(0xFF059669),
    ),
    NavigationItem(
      icon: Icons.public,
      label: 'EPIC',
      screen: const EpicScreen(),
      color: const Color(0xFF4CAF50),
    ),
    NavigationItem(
      icon: Icons.wb_sunny,
      label: 'Solar System',
      screen: const SolarSystemScreen(),
      color: const Color(0xFFFF9800),
    ),
    NavigationItem(
      icon: Icons.flash_on,
      label: 'Space Weather',
      screen: const SpaceWeatherScreen(),
      color: const Color(0xFFFF5722),
    ),
    NavigationItem(
      icon: Icons.satellite_alt,
      label: 'ISS',
      screen: const IssScreen(),
      color: const Color(0xFFDC2626),
    ),
    NavigationItem(
      icon: Icons.favorite,
      label: 'Favorites',
      screen: const FavoritesScreen(),
      color: const Color(0xFFDB2777),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0A0A0A),
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                  ]
                : [
                    const Color(0xFFF8FAFC),
                    Colors.white,
                    const Color(0xFFE2E8F0),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header
              _buildHeader(theme),
              
              // Content Area
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _navigationItems.map((item) => item.screen).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildModernBottomNav(theme),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final currentItem = _navigationItems[_currentIndex];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // NASA Logo
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: currentItem.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.rocket_launch,
              color: currentItem.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Universe Explorer',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                Text(
                  currentItem.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: currentItem.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Theme Toggle
          IconButton(
            onPressed: () {
              ref.read(themeModeNotifierProvider.notifier).toggleTheme();
            },
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBottomNav(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Very small screens (phones) - show paginated navigation
            if (constraints.maxWidth < 400) {
              return _buildPaginatedNavigation(theme);
            }
            // Small screens (tablets) - show scrollable navigation
            else if (constraints.maxWidth < 800) {
              return _buildScrollableNavigation(theme);
            }
            // Large screens - show all items
            else {
              return _buildFullNavigation(theme);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPaginatedNavigation(ThemeData theme) {
    // Show only 5 items at a time with pagination
    final int itemsPerPage = 5;
    final int totalPages = (_navigationItems.length / itemsPerPage).ceil();
    final int currentPage = (_currentIndex / itemsPerPage).floor();
    final int startIndex = currentPage * itemsPerPage;
    final int endIndex = (startIndex + itemsPerPage).clamp(0, _navigationItems.length);
    
    final visibleItems = _navigationItems.sublist(startIndex, endIndex);
    final visibleIndices = List.generate(endIndex - startIndex, (i) => startIndex + i);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Navigation Items
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: visibleIndices.asMap().entries.map((entry) {
              final localIndex = entry.key;
              final globalIndex = entry.value;
              final item = _navigationItems[globalIndex];
              final isSelected = globalIndex == _currentIndex;
              
              return Expanded(
                child: _buildNavItem(item, globalIndex, isSelected, theme),
              );
            }).toList(),
          ),
        ),
        // Page Indicator with Navigation
        if (totalPages > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous Page Button
                if (currentPage > 0)
                  GestureDetector(
                    onTap: () => _goToPage(currentPage - 1, itemsPerPage),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.chevron_left,
                        size: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                // Page Dots
                ...List.generate(totalPages, (pageIndex) {
                  final isActive = pageIndex == currentPage;
                  return GestureDetector(
                    onTap: () => _goToPage(pageIndex, itemsPerPage),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive 
                            ? _navigationItems[_currentIndex].color 
                            : theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                  );
                }),
                // Next Page Button
                if (currentPage < totalPages - 1)
                  GestureDetector(
                    onTap: () => _goToPage(currentPage + 1, itemsPerPage),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  void _goToPage(int pageIndex, int itemsPerPage) {
    final startIndex = pageIndex * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, _navigationItems.length);
    
    // Find the best item to select on this page
    int targetIndex = startIndex;
    if (_currentIndex >= startIndex && _currentIndex < endIndex) {
      // Current item is on this page, keep it
      targetIndex = _currentIndex;
    } else {
      // Select the first item on this page
      targetIndex = startIndex;
    }
    
    setState(() {
      _currentIndex = targetIndex;
    });
    _animationController.reset();
    _animationController.forward();
  }

  Widget _buildScrollableNavigation(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _navigationItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == _currentIndex;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildNavItem(item, index, isSelected, theme),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFullNavigation(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _navigationItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == _currentIndex;
          
          return _buildNavItem(item, index, isSelected, theme);
        }).toList(),
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item, int index, bool isSelected, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVerySmall = constraints.maxWidth < 60;
        final isSmall = constraints.maxWidth < 80;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
            _animationController.reset();
            _animationController.forward();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: isVerySmall ? 4 : isSmall ? 8 : 12,
              vertical: isVerySmall ? 4 : 8,
            ),
            decoration: BoxDecoration(
              color: isSelected ? item.color.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  color: isSelected ? item.color : theme.colorScheme.onSurface,
                  size: isVerySmall ? 20 : 24,
                ),
                if (!isVerySmall) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isSelected ? item.color : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: isSmall ? 10 : 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Widget screen;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.screen,
    required this.color,
  });
} 