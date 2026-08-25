import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../widgets/surah_list_tile.dart';
import '../../application/providers/quran_provider.dart';
// DÜZELTME BURADA: QuranState sınıfı import edildi
import '../../application/states/quran_state.dart';

class QuranHomeScreen extends ConsumerWidget {
  const QuranHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final state = ref.watch(quranNotifierProvider);
    final notifier = ref.read(quranNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quranTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: TextField(
                onChanged: notifier.searchSurahs,
                decoration: InputDecoration(
                  hintText: l10n.quranSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  // DÜZELTME BURADA: OutlineBinding.none yerine InputBorder.none kullanıldı
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildBody(context, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, QuranState state) {
    final l10n = context.l10n;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.failure != null) {
      return ErrorStateWidget(
        title: l10n.errorStateDefaultTitle,
        message: state.failure!.message,
        // DÜZELTME BURADA: retryText eklendi
        retryText: l10n.retryButton,
      );
    }

    if (state.surahs.isEmpty) {
      return Center(
        child: Text(
          l10n.quranNoSurahFound,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: state.surahs.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        return SurahListTile(surah: state.surahs[index]);
      },
    );
  }
}
