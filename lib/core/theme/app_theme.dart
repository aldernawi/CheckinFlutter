import 'package:checkin_flutter/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color _primary = Color(0xFFDC2626);

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      primaryColor: _primary,
      colorScheme: base.colorScheme.copyWith(
        primary: _primary,
        secondary: const Color(0xFF1F2937),
      ),
      textTheme: base.textTheme.apply(fontFamily: AppConstants.fontFamily),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}
