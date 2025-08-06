import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lexilearnai/common/di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class ApplicationInitialize {
  ApplicationInitialize._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _initializeLocalization();
    await _initializeSupabase();
    await initializeDependencies();
  }

  static Future<void> _initializeLocalization() async {
    await EasyLocalization.ensureInitialized();
  }

  static Future<void> _initializeSupabase() async {
    await Supabase.initialize(
      url: "https://mqwpfvagapksnfbroiaq.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1xd3BmdmFnYXBrc25mYnJvaWFxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQzOTkxNDUsImV4cCI6MjA2OTk3NTE0NX0.itX1LJ6TbTbUA_mTHoKUfAnashMbheSPUoN44iH8ixg",
    );
  }
}
