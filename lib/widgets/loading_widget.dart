// lib/widgets/loading_widget.dart - Yükleme widget'ı
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants.dart';

class LoadingWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const LoadingWidget({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height ?? 200,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class LoadingCard extends StatelessWidget {
  final double height;
  final double width;

  const LoadingCard({
    super.key,
    this.height = 200,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: LoadingWidget(
        height: height,
        width: width,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class LoadingGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const LoadingGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const LoadingCard(height: 150);
      },
    );
  }
} 