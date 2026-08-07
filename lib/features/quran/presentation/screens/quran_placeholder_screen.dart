import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';

class QuranPlaceholderScreen extends StatelessWidget {
  const QuranPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quranTitle),
      ),
      body: SafeArea(
        child: EmptyStateWidget(
          icon: Icons.menu_book_outlined,
          title: l10n.quranTitle,
          description: l10n.quranDesc,
        ),
      ),
    );
  }
}
