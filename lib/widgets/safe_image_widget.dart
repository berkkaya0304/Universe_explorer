// lib/widgets/safe_image_widget.dart - Safe image widget
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'loading_widget.dart';
import '../constants.dart';

class SafeImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const SafeImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildErrorWidget();
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => LoadingWidget(
        height: height ?? 200,
        width: width,
      ),
      errorWidget: (context, url, error) {
        print('Image loading error: $error');
        print('URL: $url');
        return _buildErrorWidget();
      },
      httpHeaders: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
        'Cache-Control': 'no-cache',
        'Referer': 'https://api.nasa.gov/',
        'Origin': 'https://api.nasa.gov',
      },
      // Add more options for better compatibility
      maxWidthDiskCache: 1024,
      maxHeightDiskCache: 1024,
      memCacheWidth: 1024,
      memCacheHeight: 1024,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[300]!,
            Colors.grey[400]!,
          ],
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Try to load local placeholder image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              child: Image.asset(
                Constants.placeholderImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // If local image also fails, show icon and text
                  return Container(
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Image Unavailable',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'CORS or network issue',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 