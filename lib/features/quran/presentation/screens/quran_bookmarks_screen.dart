import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../application/providers/quran_bookmark_provider.dart';
import '../../application/providers/quran_provider.dart';

class QuranBookmarksScreen extends ConsumerWidget {
  const QuranBookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final state = ref.watch(quranBookmarkNotifierProvider);
    final quranState = ref.watch(quranNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quranBookmarks),
      ),
      body: SafeArea(
        child: state.isLoading || quranState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.bookmarks.isEmpty
                ? Center(
                    child: Text(
                      l10n.quranNoBookmarksYet,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: state.bookmarks.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final bookmark = state.bookmarks[index];
                      // Find localized name securely
                      final surah = quranState.surahs.firstWhere(
                        (s) => s.number == bookmark.surahNumber,
                        orElse: () => quranState.surahs.first,
                      );
                      final surahName = l10n.localeName == 'tr'
                          ? surah.nameTurkish
                          : surah.nameTransliteration;

                      return ListTile(
                        tileColor: colorScheme.surfaceContainerHighest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading:
                            Icon(Icons.bookmark, color: colorScheme.primary),
                        title: Text(
                          surahName,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle:
                            Text('${l10n.quranAyah} ${bookmark.ayahNumber}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Jump directly to exact ayah
                          context.push(
                            '/quran/surah/${bookmark.surahNumber}?ayah=${bookmark.ayahNumber}',
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
