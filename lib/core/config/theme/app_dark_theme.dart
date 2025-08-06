import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';
import 'package:lexilearnai/core/config/theme/app_theme.dart';

final class AppDarkTheme extends AppTheme {
  @override
  ThemeData get themeData => ThemeData(
      colorScheme: AppColorScheme.darkColorScheme,
      useMaterial3: true,
      fontFamily: fontFamily);

  @override
  String get fontFamily => GoogleFonts.roboto().fontFamily!;
}
