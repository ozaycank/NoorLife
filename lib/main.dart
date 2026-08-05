import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/config/environment_config.dart';
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvironmentConfig.init();
  await Firebase.initializeApp();
  await configureDependencies();

  runApp(
    const ProviderScope(
      child: NoorLifeApp(),
    ),
  );
}
