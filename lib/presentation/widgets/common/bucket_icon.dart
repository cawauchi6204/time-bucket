import 'package:flutter/material.dart';
import 'dart:io';

class BucketIcon extends StatelessWidget {
  final String? iconPath;
  final Color color;
  final double size;
  final IconData fallbackIcon;

  const BucketIcon({
    super.key,
    this.iconPath,
    required this.color,
    this.size = 28,
    this.fallbackIcon = Icons.folder,
  });

  @override
  Widget build(BuildContext context) {
    if (iconPath == null) {
      return Icon(
        fallbackIcon,
        color: color,
        size: size,
      );
    }

    // Check if it's a predefined icon
    if (iconPath!.startsWith('icon:')) {
      final codePoint = int.tryParse(iconPath!.substring(5));
      if (codePoint != null) {
        return Icon(
          IconData(codePoint, fontFamily: 'MaterialIcons'),
          color: color,
          size: size,
        );
      }
    }

    // It's a custom image file
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.15),
      child: Image.file(
        File(iconPath!),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to default icon if image loading fails
          return Icon(
            fallbackIcon,
            color: color,
            size: size,
          );
        },
      ),
    );
  }
}
