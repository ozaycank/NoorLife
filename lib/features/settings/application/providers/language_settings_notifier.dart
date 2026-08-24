import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/storage/secure_storage_service.dart';

class LanguageState {
  final Locale locale;
  const LanguageState(this.locale);
}

final languageSettingsNotifierProvider =
    NotifierProvider<LanguageSettingsNotifier, LanguageState>(
  LanguageSettingsNotifier.new,
);

class LanguageSettingsNotifier extends Notifier<LanguageState> {
  static const _languageKey = 'app_language_preference';
  late final SecureStorageService _storage;

  @override
  LanguageState build() {
    _storage = getIt<SecureStorageService>();
    _loadLanguage();
    return const LanguageState(Locale('en'));
  }

  Future<void> _loadLanguage() async {
    try {
      final savedCode = await _storage.read(key: _languageKey);
      if (savedCode != null && (savedCode == 'en' || savedCode == 'tr')) {
        state = LanguageState(Locale(savedCode));
      }
    } catch (_) {
      // Fallback
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (state.locale == newLocale) return;
    state = LanguageState(newLocale);
    try {
      await _storage.write(
        key: _languageKey,
        value: newLocale.languageCode,
      );
    } catch (_) {}
  }
}
