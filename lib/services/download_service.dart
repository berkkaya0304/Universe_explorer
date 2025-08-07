// lib/services/download_service.dart - Download service for images and files
import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadService {
  static Future<String?> downloadImage(String imageUrl, String fileName) async {
    try {
      // Check if running on web
      if (kIsWeb) {
        print('Web platform detected - using alternative download method');
        return _downloadImageWeb(imageUrl, fileName);
      }

      // Check permissions
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        print('Storage permission not granted');
        return null;
      }

      // Get download directory
      Directory? downloadDir;
      if (Platform.isAndroid) {
        downloadDir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadDir = await getApplicationDocumentsDirectory();
      } else {
        downloadDir = await getDownloadsDirectory();
      }

      if (downloadDir == null) {
        print('Could not get download directory');
        return null;
      }

      // Create file path
      final filePath = '${downloadDir.path}/$fileName';
      final file = File(filePath);

      // Download file
      final response = await HttpClient().getUrl(Uri.parse(imageUrl));
      final httpResponse = await response.close();
      final bytes = await consolidateHttpClientResponseBytes(httpResponse);
      await file.writeAsBytes(bytes);

      print('Image downloaded successfully: $filePath');
      return filePath;
    } catch (e) {
      print('Error downloading image: $e');
      return null;
    }
  }

  static Future<String?> _downloadImageWeb(String imageUrl, String fileName) async {
    try {
      // For web, we'll create a download link
      final anchor = html.AnchorElement(href: imageUrl)
        ..setAttribute('download', fileName)
        ..click();
      
      print('Web download initiated for: $fileName');
      return 'web_download_$fileName';
    } catch (e) {
      print('Error downloading image on web: $e');
      return null;
    }
  }

  static Future<String?> getProxyImageUrl(String originalUrl) async {
    if (kIsWeb) {
      // For web, try to use a CORS proxy or return the original URL
      // You can implement a custom proxy service here
      return originalUrl;
    }
    return originalUrl;
  }

  static Future<bool> isImageAccessible(String imageUrl) async {
    try {
      if (kIsWeb) {
        // For web, we'll assume the image is accessible
        // In a real implementation, you might want to check this
        return true;
      }

      final request = await HttpClient().getUrl(Uri.parse(imageUrl));
      final response = await request.close();
      return response.statusCode == 200;
    } catch (e) {
      print('Error checking image accessibility: $e');
      return false;
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
                
                if (success != null) {
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
                
                if (success != null) {
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
} 