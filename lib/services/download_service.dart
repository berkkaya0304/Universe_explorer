// lib/services/download_service.dart - Download service for images
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:device_info_plus/device_info_plus.dart';

class DownloadService {
  static final Dio _dio = Dio();

  static Future<bool> downloadImage(String imageUrl, String fileName) async {
    try {
      print('Starting download for: $imageUrl');
      
      // Check if URL is valid
      final uri = Uri.tryParse(imageUrl);
      if (uri == null || !uri.hasAbsolutePath) {
        print('Invalid URL: $imageUrl');
        return false;
      }

      // For web and desktop, use browser download
      if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        print('Opening in browser for web/desktop');
        final Uri url = Uri.parse(imageUrl);
        
        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
          return true;
        }
      }

      // For mobile platforms, try direct download
      if (Platform.isAndroid || Platform.isIOS) {
        print('Downloading to mobile device');
        
        // First try direct download
        bool directDownloadSuccess = await _downloadToDevice(imageUrl, fileName);
        if (directDownloadSuccess) {
          return true;
        }
        
        // If direct download fails, try opening in browser as fallback
        print('Direct download failed, trying browser fallback');
        return await openImageInBrowser(imageUrl);
      }

      return false;
    } catch (e) {
      print('Download error: $e');
      return false;
    }
  }

  static Future<bool> _downloadToDevice(String imageUrl, String fileName) async {
    try {
      print('Starting mobile download...');
      
      // Request permissions for Android
      if (Platform.isAndroid) {
        final hasPermission = await _requestPermissions();
        if (!hasPermission) {
          print('Storage permission denied');
          return false;
        }
        print('Permissions granted');
      }

      // Get the download directory with better fallback strategy
      Directory? downloadDir;
      if (Platform.isAndroid) {
        downloadDir = await _getAndroidDownloadDirectory();
      } else if (Platform.isIOS) {
        downloadDir = await getApplicationDocumentsDirectory();
        print('Using iOS documents directory: ${downloadDir.path}');
      }

      if (downloadDir == null) {
        print('Could not access download directory');
        return false;
      }

      // Create a safe filename
      final safeFileName = _createSafeFileName(fileName);
      final filePath = '${downloadDir.path}/$safeFileName';
      final file = File(filePath);

      print('Downloading to: $filePath');

      // Download the file with better error handling and retry logic
      bool downloadSuccess = false;
      int retryCount = 0;
      const maxRetries = 3;

      while (!downloadSuccess && retryCount < maxRetries) {
        try {
          final response = await _dio.download(
            imageUrl,
            filePath,
            onReceiveProgress: (received, total) {
              if (total != -1) {
                final progress = (received / total * 100).toStringAsFixed(0);
                print('Download progress: $progress%');
              }
            },
            options: Options(
              headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                'Accept-Language': 'en-US,en;q=0.9',
                'Cache-Control': 'no-cache',
              },
              responseType: ResponseType.bytes,
              followRedirects: true,
              maxRedirects: 5,
              sendTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 60),
            ),
          );

          if (response.statusCode == 200) {
            print('File downloaded successfully to: $filePath');
            
            // Verify file exists and has content
            if (await file.exists() && await file.length() > 0) {
              print('File verification successful. Size: ${await file.length()} bytes');
              downloadSuccess = true;
            } else {
              print('File verification failed');
              retryCount++;
              if (retryCount < maxRetries) {
                print('Retrying download... Attempt ${retryCount + 1}');
                await Future.delayed(Duration(seconds: 2));
              }
            }
          } else {
            print('Download failed with status: ${response.statusCode}');
            retryCount++;
            if (retryCount < maxRetries) {
              print('Retrying download... Attempt ${retryCount + 1}');
              await Future.delayed(Duration(seconds: 2));
            }
          }
        } catch (e) {
          print('Download attempt ${retryCount + 1} failed: $e');
          retryCount++;
          if (retryCount < maxRetries) {
            print('Retrying download... Attempt ${retryCount + 1}');
            await Future.delayed(Duration(seconds: 2));
          }
        }
      }

      return downloadSuccess;
    } catch (e) {
      print('Download to device error: $e');
      return false;
    }
  }

  static Future<Directory?> _getAndroidDownloadDirectory() async {
    try {
      // Try multiple strategies for Android download directory
      
      // Strategy 1: Try to get external storage directory
      try {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          final downloadDir = Directory('${externalDir.path}/Downloads');
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }
          print('Using external storage directory: ${downloadDir.path}');
          return downloadDir;
        }
      } catch (e) {
        print('External storage not available: $e');
      }

      // Strategy 2: Try app-specific documents directory
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final downloadDir = Directory('${appDir.path}/Downloads');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        print('Using app documents directory: ${downloadDir.path}');
        return downloadDir;
      } catch (e) {
        print('App documents directory not available: $e');
      }

      // Strategy 3: Try temporary directory
      try {
        final tempDir = await getTemporaryDirectory();
        final downloadDir = Directory('${tempDir.path}/Downloads');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        print('Using temporary directory: ${downloadDir.path}');
        return downloadDir;
      } catch (e) {
        print('Temporary directory not available: $e');
      }

      return null;
    } catch (e) {
      print('Error getting download directory: $e');
      return null;
    }
  }

  static String _createSafeFileName(String fileName) {
    // Remove or replace invalid characters
    String safeName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
    safeName = safeName.replaceAll(RegExp(r'\s+'), '_');
    
    // Ensure it has a proper extension
    if (!safeName.toLowerCase().endsWith('.jpg') && 
        !safeName.toLowerCase().endsWith('.jpeg') && 
        !safeName.toLowerCase().endsWith('.png') && 
        !safeName.toLowerCase().endsWith('.webp')) {
      safeName += '.jpg';
    }
    
    // Add timestamp to avoid conflicts
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final nameWithoutExt = safeName.substring(0, safeName.lastIndexOf('.'));
    final extension = safeName.substring(safeName.lastIndexOf('.'));
    
    return '${nameWithoutExt}_$timestamp$extension';
  }

  static Future<bool> openImageInBrowser(String imageUrl) async {
    try {
      print('Opening image in browser: $imageUrl');
      
      // Check if URL is valid
      final uri = Uri.tryParse(imageUrl);
      if (uri == null || !uri.hasAbsolutePath) {
        print('Invalid URL: $imageUrl');
        return false;
      }

      final Uri url = Uri.parse(imageUrl);
      
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        print('Successfully opened URL in browser');
        return true;
      } else {
        print('Could not open URL: $imageUrl');
        return false;
      }
    } catch (e) {
      print('Open in browser error: $e');
      return false;
    }
  }

  static Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      print('Requesting Android permissions...');
      
      // Request storage permissions with better handling
      try {
        // For Android 11+ (API 30+), try manage external storage first
        if (await _isAndroid11OrHigher()) {
          final manageStorageStatus = await Permission.manageExternalStorage.status;
          print('Manage external storage status: $manageStorageStatus');
          
          if (manageStorageStatus.isDenied) {
            final result = await Permission.manageExternalStorage.request();
            print('Manage external storage request result: $result');
            if (result.isGranted) {
              return true;
            }
          } else if (manageStorageStatus.isGranted) {
            return true;
          }
        }

        // Fallback to regular storage permissions
        final storageStatus = await Permission.storage.status;
        print('Storage permission status: $storageStatus');
        
        if (storageStatus.isDenied) {
          final result = await Permission.storage.request();
          print('Storage permission request result: $result');
          return result.isGranted;
        }
        
        return storageStatus.isGranted;
      } catch (e) {
        print('Error requesting permissions: $e');
        // If permission handling fails, try to proceed anyway
        return true;
      }
    }
    return true;
  }

  static Future<bool> _isAndroid11OrHigher() async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.version.sdkInt >= 30; // Android 11 is API 30
      }
      return false;
    } catch (e) {
      print('Error checking Android version: $e');
      // If we can't determine the version, assume it's Android 11+ for safety
      return true;
    }
  }

  static void showDownloadDialog(BuildContext context, String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.download, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              const Text('Download Image'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Would you like to download this image?'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                
                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 16),
                        Text('Preparing download...'),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );

                final success = await downloadImage(imageUrl, 'nasa_${DateTime.now().millisecondsSinceEpoch}.jpg');
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Image downloaded successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to download image. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.download),
              label: const Text('Download'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  static void showImageOptionsDialog(BuildContext context, String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.image, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              const Text('Image Options'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose an action for this image:'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                
                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 16),
                        Text('Opening in browser...'),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );

                final success = await openImageInBrowser(imageUrl);
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening image in browser'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to open image. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open in Browser'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                
                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 16),
                        Text('Preparing download...'),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );

                final success = await downloadImage(imageUrl, 'nasa_${DateTime.now().millisecondsSinceEpoch}.jpg');
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Image downloaded successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to download image. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.download),
              label: const Text('Download'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
} 