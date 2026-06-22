class ApiParser {
  /// Safely parses string from Odoo fields which return false when empty/null
  static String? parseString(dynamic value) {
    if (value is String) {
      return value;
    }
    return null;
  }

  /// Safely parses doubles, handling number values and degrees-formatted coordinates
  static double? parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      final clean = value
          .replaceAll('°', '')
          .replaceAll('N', '')
          .replaceAll('S', '')
          .replaceAll('E', '')
          .replaceAll('W', '')
          .trim();
      double? val = double.tryParse(clean);
      if (val != null) {
        if (value.contains('S') || value.contains('W')) {
          val = -val;
        }
      }
      return val;
    }
    return null;
  }

  /// Safely parses integers, handling string conversions
  static int? parseInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  /// Safely parses booleans, handling strings like 'true' / 'false' and numeric flags
  static bool? parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
    if (value is num) {
      return value != 0;
    }
    return null;
  }
}
