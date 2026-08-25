import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/empty_state_widget.dart';

class SurahDetailPlaceholderScreen extends StatelessWidget {
  final int surahNumber;

  const SurahDetailPlaceholderScreen({
    super.key,
    required this.surahNumber,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.quranTitle} - $surahNumber'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: EmptyStateWidget(
            icon: Icons.menu_book,
            title: '${l10n.quranTitle} $surahNumber',
            // DÜZELTME BURADA: message yerine description isimli parametre varmış EmptyStateWidget'da
            description: l10n.quranDetailPlaceholderText,
          ),
        ),
      ),
    );
  }
}
