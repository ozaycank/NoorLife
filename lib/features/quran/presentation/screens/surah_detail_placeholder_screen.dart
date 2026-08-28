import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/surah.dart';
import '../../domain/entities/quran_reading_progress.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../application/providers/quran_progress_provider.dart';
import '../../application/providers/quran_bookmark_provider.dart';
import '../widgets/quran_surah_header.dart';
import '../widgets/quran_ayah_view.dart';
import '../widgets/quran_reader_settings_sheet.dart';
import '../constants/quran_reader_typography.dart';

class SurahDetailPlaceholderScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final int? jumpToAyah;

  const SurahDetailPlaceholderScreen({
    super.key,
    required this.surahNumber,
    this.jumpToAyah,
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
        _calculateAndJump();
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

  void _calculateAndJump() {
    int? targetAyah;

    if (widget.jumpToAyah != null) {
      targetAyah = widget.jumpToAyah;
    } else {
      final progressState = ref.read(quranProgressNotifierProvider);
      if (progressState.lastRead != null &&
          progressState.lastRead!.surahNumber == widget.surahNumber) {
        targetAyah = progressState.lastRead!.ayahNumber;
      }
    }

    if (targetAyah != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_itemScrollController.isAttached) {
          int targetIndex = targetAyah! > 1 ? targetAyah - 1 : 0;
          targetIndex += 1;
          if (widget.surahNumber != 1 && widget.surahNumber != 9) {
            targetIndex += 1;
          }
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

  void _showSettingsSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const QuranReaderSettingsSheet(),
    );
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
    final bool showBismillah =
        widget.surahNumber != 1 && widget.surahNumber != 9;
    final int totalItems = 1 + (showBismillah ? 1 : 0) + ayahs.length;

    final bookmarkState = ref.watch(quranBookmarkNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.localeName == 'tr'
              ? _surah!.nameTurkish
              : _surah!.nameTransliteration,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size),
            tooltip: l10n.quranReaderSettings,
            onPressed: _showSettingsSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: QuranReaderTypography.maxReaderWidth,
            ),
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemCount: totalItems,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return QuranSurahHeader(surah: _surah!);
                }

                if (showBismillah && index == 1) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(
                      'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize: QuranReaderTypography.bismillahFontSize,
                        color: colorScheme.primary,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final ayahIndex = index - 1 - (showBismillah ? 1 : 0);
                final ayah = ayahs[ayahIndex];

                final isBookmarked = bookmarkState.bookmarks.any(
                  (b) =>
                      b.surahNumber == widget.surahNumber &&
                      b.ayahNumber == ayah.numberInSurah,
                );

                return VisibilityDetector(
                  key: Key('ayah-${ayah.numberInSurah}'),
                  onVisibilityChanged: (info) {
                    if (info.visibleFraction > 0.4) {
                      _updateProgress(ayah.numberInSurah);
                    }
                  },
                  child: QuranAyahView(
                    ayah: ayah,
                    isBookmarked: isBookmarked,
                    onBookmarkToggle: () {
                      ref
                          .read(quranBookmarkNotifierProvider.notifier)
                          .toggleBookmark(
                            surahNumber: widget.surahNumber,
                            ayahNumber: ayah.numberInSurah,
                          );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
