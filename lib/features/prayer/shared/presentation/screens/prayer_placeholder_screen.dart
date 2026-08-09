import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../widgets/prayer_empty_widget.dart';

class PrayerPlaceholderScreen extends StatelessWidget {
  const PrayerPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.prayerTitle)),
      body: const SafeArea(child: PrayerEmptyWidget()),
    );
  }
}
