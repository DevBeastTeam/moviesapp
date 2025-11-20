// library safeConverters;
// safe_converters.dart
// The most robust null-safe converter library you'll ever need (2025+)
library safe_converters;

import 'dart:convert';
import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';

// ==================================================================
// 1. toSafeString() - Handles ANY garbage → clean String
// ==================================================================
extension ToSafeString on Object? {
  String toSafeString({String fallback = ''}) {
    try {
      if (this == null) return fallback;
      final data = this;
      if (data.toString().isEmpty ||
          data.toString().toLowerCase() == 'null' ||
          data.toString().toLowerCase() == 'na' ||
          data.toString().toLowerCase() == 'nan' ||
          data.toString().toLowerCase() == 'none' ||
          data.toString().toLowerCase() == "empty" ||
          data.toString().toLowerCase() == 'undefined' ||
          data.toString().toLowerCase() == '<null>') {
        return fallback;
      }
      return data.toString();
    } catch (e) {
      debugPrint("💥 Error ToSafeString: $e");
      return fallback;
    }
  }
}

// ==================================================================
// 2. toSafeInt() - null, "abc", 0.9, "null" → 0 (or custom fallback)
// ==================================================================
extension ToSafeInt on Object? {
  int toSafeInt({int fallback = 0}) {
    try {
      if (this == null) return fallback;
      if (this is int) return this as int;
      if (this is double) return (this as double).round();

      final data = toString().trim();
      if (data.isEmpty ||
          data.toLowerCase() == 'null' ||
          data.toLowerCase() == 'na' ||
          data.toLowerCase() == 'nan' ||
          data.toLowerCase() == 'none' ||
          data.toLowerCase() == "empty" ||
          data.toLowerCase() == 'undefined') {
        return fallback;
      }

      final cleaned = data.replaceAll(RegExp(r'[^0-9\-]'), '');
      return int.tryParse(cleaned) ?? fallback;
    } catch (e) {
      debugPrint("💥 Error ToSafeInt: $e");
      return fallback;
    }
  }
}

// ==================================================================
// 3. toSafeDouble() - FIXED: Removed invalid 'g' flag
// ==================================================================
extension ToSafeDouble on Object? {
  double toSafeDouble({double fallback = 0.0}) {
    try {
      if (this == null) return fallback;
      if (this is double) return this as double;
      if (this is int) return (this as int).toDouble();

      final data = toString().trim();
      if (data.isEmpty ||
          data.toLowerCase() == 'null' ||
          data.toLowerCase() == 'undefined' ||
          data.toLowerCase() == 'na' ||
          data.toLowerCase() == 'nan' ||
          data.toLowerCase() == 'none') {
        return fallback;
      }

      // FIXED LINE: Removed invalid 'g' flag — Dart doesn't need it!
      final cleaned = data.replaceAll(RegExp(r'[^0-9\.\-]', unicode: true), '');

      final parsed = double.tryParse(cleaned);
      if (parsed == null || parsed.isNaN || parsed.isInfinite) {
        return fallback;
      }
      return parsed;
    } catch (e) {
      debugPrint("💥 Error ToSafeDouble: $e");
      return fallback;
    }
  }
}

// ==================================================================
// 4. toSafeBool() - handles 'true', 1, 'yes', 'active', etc.
// ==================================================================
extension ToSafeBool on Object? {
  bool toSafeBool({bool fallback = false}) {
    if (this == null) return fallback;
    if (this is bool) return this as bool;

    final data = toString().trim().toLowerCase();
    if (data.isEmpty ||
        data == 'null' ||
        data == 'undefined' ||
        data == '0' ||
        data == 'false' ||
        data == 'no') {
      return false;
    }
    return data == 'true' ||
        data == '1' ||
        data == 'yes' ||
        data == 'on' ||
        data == 'active' ||
        data == '1.0';
  }
}

// ==================================================================
// 5. toSafeList<T>() - handles null, [], '[]', 'null', {}, 'empty'
// ==================================================================
extension ToSafeList on Object? {
  List<T> toSafeList<T>({List<T> fallback = const []}) {
    try {
      if (this == null) return fallback;

      // Already a list
      if (this is List) {
        return List<T>.from(this as List);
      }

      // String cases: '[]', '[1,2,3]', 'null', '', 'empty'
      final data = this;
      if (data.toString().trim().isEmpty ||
          data.toString().trim().toLowerCase() == 'null' ||
          data.toString().trim().toLowerCase() == 'undefined' ||
          data.toString().trim() == '[]' ||
          data.toString().trim().toLowerCase() == 'empty') {
        return fallback;
      }
      final decoded = jsonDecode(data.toString());
      if (decoded is List) return List<T>.from(decoded);
      return fallback;
    } catch (e) {
      debugPrint("💥 Error ToSafeList: $e");
      return fallback;
    }
    // Map or anything else → reject
  }
}

// ==================================================================
// 6. toSafeMap() - handles null, {}, '{}', 'null', 'empty'
// ==================================================================
extension ToSafeMap on Object? {
  Map<String, dynamic> toSafeMap({Map<String, dynamic> fallback = const {}}) {
    try {
      if (this == null) return fallback;
      if (this is Map) {
        return Map<String, dynamic>.from(this as Map);
      }

      final data = this;
      if (data.toString().trim().isEmpty ||
          data.toString().trim().toLowerCase() == 'null' ||
          data.toString().trim() == '{}' ||
          data.toString().trim().toLowerCase() == 'empty') {
        return fallback;
      }
      final decoded = jsonDecode(data.toString());
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return fallback;
    } catch (e) {
      debugPrint("💥 Error ToSafeMap: $e");
      return fallback;
    }
  }
}

// ==================================================================
// 7. SubStringText() - strings, null
// ==================================================================

extension SubStringText on String? {
  String toSubStringText([int start = 0, int end = 15]) {
    try {
      if (toString() == 'null') {
        return "";
      } else if (toString().length > end) {
        return this?.substring(start, end) ?? '';
      } else {
        return toString();
      }
    } catch (e) {
      debugPrint("💥 Error SubStringText: $e");
      return "";
    }
  }
}

// ==================================================================
// 7. toSafeDateTime() - handles timestamps, strings, null
// ==================================================================
extension ToSafeDateTime on dynamic {
  DateTime? toSafeDateTime() {
    try {
      if (this == null) return DateTime.now();
      if (this is DateTime) return this;
      if (this is int) {
        return DateTime.fromMillisecondsSinceEpoch(this, isUtc: true);
      }

      final data = toString().trim();
      if (data.isEmpty || data.toLowerCase() == 'null') return null;

      return DateTime.tryParse(data) ??
          DateTime.tryParse(data.replaceAll('/', '-')) ??
          (int.tryParse(data) != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  int.parse(data),
                  isUtc: true,
                )
              : DateTime.now());
    } catch (e) {
      debugPrint("💥 Error toSafeDateTime: $e");
      return DateTime.now();
    }
  }
}

// ==================================================================
// BONUS: Shorthand for nullable types (optional but clean)
// ==================================================================
extension NullableString on String? {
  String toSafeString({String fallback = ''}) =>
      this?.toSafeString(fallback: fallback) ?? fallback;
}

extension NullableInt on int? {
  int toSafeInt({int fallback = 0}) => this ?? fallback;
}

extension NullableDouble on double? {
  double toSafeDouble({double fallback = 0.0}) => this ?? fallback;
}

extension NullableBool on bool? {
  bool toSafeBool({bool fallback = false}) => this ?? fallback;
}

extension NullableList<T> on List<T>? {
  List<T> toSafeList({List<T> fallback = const []}) => this ?? fallback;
}

extension NullableMap on Map<String, dynamic>? {
  Map<String, dynamic> toSafeMap({Map<String, dynamic> fallback = const {}}) =>
      this ?? fallback;
}
