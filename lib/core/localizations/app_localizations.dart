import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lexilearnai/core/config/constants/enums/locales.dart';

final class AppLocalizations extends EasyLocalization {
  AppLocalizations({
    super.key,
    required super.child,
  }) : super(
          supportedLocales: _supportedLocales,
          path: _translationPath,
          useOnlyLangCode: true,
        );
  static final List<Locale> _supportedLocales = [
    Locales.tr.locale,
    Locales.en.locale,
  ];
  static const String _translationPath = 'assets/translations';
  static Future<void> updateLanguage({
    required BuildContext context,
    required Locales value,
  }) {
    return context.setLocale(value.locale);
  }
}
