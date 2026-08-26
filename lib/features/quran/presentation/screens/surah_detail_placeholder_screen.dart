import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/surah.dart';
import '../../domain/entities/quran_reading_progress.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../application/providers/quran_progress_provider.dart';

class SurahDetailPlaceholderScreen extends ConsumerStatefulWidget {
  final int surahNumber;

  const SurahDetailPlaceholderScreen({
    super.key,
    required this.surahNumber,
  });

  @override
  ConsumerState<SurahDetailPlaceholderScreen> createState() =>
      _SurahDetailScreenState();
}

class _SurahDetailScreenState
    extends ConsumerState<SurahDetailPlaceholderScreen> {
  Surah? _surah;
  String? _error;
  bool _isLoading = true;

  final ItemScrollController _itemScrollController = ItemScrollController();
  int _highestVisibleAyah = 1;

  @override
  void initState() {
    super.initState();
    _loadSurahDetail();
  }

  Future<void> _loadSurahDetail() async {
    try {
      final repository = getIt<QuranRepository>();
      final surah = await repository.getSurahDetail(widget.surahNumber);

      if (mounted) {
        setState(() {
          _surah = surah;
          _isLoading = false;
        });
        _jumpToLastRead();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _jumpToLastRead() {
    final progressState = ref.read(quranProgressNotifierProvider);
    final lastRead = progressState.lastRead;

    if (lastRead != null && lastRead.surahNumber == widget.surahNumber) {
      // Small delay to ensure the list has built
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_itemScrollController.isAttached) {
          // Index is 0-based, ayah is 1-based
          final targetIndex =
              lastRead.ayahNumber > 1 ? lastRead.ayahNumber - 1 : 0;
          _itemScrollController.jumpTo(index: targetIndex);
        }
      });
    }
  }

  void _updateProgress(int ayahNumber) {
    if (ayahNumber > _highestVisibleAyah) {
      _highestVisibleAyah = ayahNumber;
      final progress = QuranReadingProgress(
        surahNumber: widget.surahNumber,
        ayahNumber: _highestVisibleAyah,
        updatedAt: DateTime.now(),
      );
      ref.read(quranProgressNotifierProvider.notifier).saveProgress(progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final l10n = context.l10n;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('${l10n.quranTitle} ${widget.surahNumber}')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _surah == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.errorStateDefaultTitle)),
        body: Center(
          child: Text(
            _error ?? l10n.generalError,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final ayahs = _surah!.ayahs ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.localeName == 'tr'
              ? _surah!.nameTurkish
              : _surah!.nameTransliteration,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (widget.surahNumber != 9 && widget.surahNumber != 1)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                  style: textTheme.headlineMedium?.copyWith(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
            if (widget.surahNumber != 9 && widget.surahNumber != 1)
              Divider(color: colorScheme.outlineVariant),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: _itemScrollController,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: ayahs.length,
                itemBuilder: (context, index) {
                  final ayah = ayahs[index];

                  return VisibilityDetector(
                    key: Key('ayah-${ayah.numberInSurah}'),
                    onVisibilityChanged: (info) {
                      // If at least 50% of the ayah is visible, consider it read
                      if (info.visibleFraction > 0.5) {
                        _updateProgress(ayah.numberInSurah);
                      }
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              '${ayah.text} ﴿${ayah.numberInSurah}﴾',
                              style: textTheme.headlineSmall?.copyWith(
                                height: 2.0,
                                color: colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Divider(color: colorScheme.surfaceContainerHighest),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
