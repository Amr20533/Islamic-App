import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Returns an [ImageProvider] that works on both mobile and web.
///
/// * [imagePath] – The stored path or base64 data for the profile image.
///   - On mobile it is a file system path.
///   - On web it is a data‑uri string (e.g. "data:image/jpeg;base64,...").
/// * [fallbackAsset] – Asset image to use when there is no saved image.
ImageProvider resolveProfileImage({
  required String? imagePath,
  required String fallbackAsset,
}) {
  if (imagePath == null || imagePath.isEmpty) {
    return AssetImage(fallbackAsset);
  }
  if (kIsWeb) {
    // Expect a data‑uri string. If it is not, treat it as a regular URL.
    if (imagePath.startsWith('data:image')) {
      final base64Str = imagePath.split(',').last;
      final bytes = base64Decode(base64Str);
      return MemoryImage(bytes);
    }
    return NetworkImage(imagePath);
  } else {
    final file = File(imagePath);
    if (file.existsSync()) {
      return FileImage(file);
    }
    return AssetImage(fallbackAsset);
  }
}
