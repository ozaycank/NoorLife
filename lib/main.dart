import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart';
import 'core/routing/app_router.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/dark_theme.dart';

import 'features/settings/application/providers/language_settings_notifier.dart';
import 'l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(
    const ProviderScope(
      child: NoorLifeApp(),
    ),
  );
}

class NoorLifeApp extends ConsumerWidget {
  const NoorLifeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter.createRouter(ref);
    final localeState = ref.watch(languageSettingsNotifierProvider);

    return MaterialApp.router(
      title: 'NoorLife',
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
      ],
      locale: localeState.locale,
      debugShowCheckedModeBanner: false,
    );
  }
}
