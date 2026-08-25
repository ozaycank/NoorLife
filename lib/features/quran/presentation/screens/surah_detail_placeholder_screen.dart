import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';

class SurahDetailPlaceholderScreen extends StatefulWidget {
  final int surahNumber;

  const SurahDetailPlaceholderScreen({
    super.key,
    required this.surahNumber,
  });

  @override
  State<SurahDetailPlaceholderScreen> createState() =>
      _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailPlaceholderScreen> {
  Surah? _surah;
  String? _error;
  bool _isLoading = true;

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
            // Bismillah Header (Tevbe suresi 9. sure hariç genelde bismillah vardır,
            // AlQuran API'si Fatiha'nın 1. ayetini bismillah sayar, diğerlerinde ayrı tutar)
            if (widget.surahNumber != 9 && widget.surahNumber != 1)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                  style: textTheme.headlineMedium?.copyWith(
                    fontFamily: 'Amiri', // Arapça font varsa uygulanır
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: ayahs.length,
                itemBuilder: (context, index) {
                  final ayah = ayahs[index];
                  // AlQuran API Bismillah'ı Fatiha hariç metnin başına yapıştırabilir.
                  // Bunu filtrelemek istenirse replace ile yapılabilir ama "dokunma" kuralı gereği ham basıyoruz.

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Arapça Metin (RTL ZORUNLU)
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            '${ayah.text} ﴿${ayah.numberInSurah}﴾',
                            style: textTheme.headlineSmall?.copyWith(
                              height: 2.0, // Okunabilir satır yüksekliği
                              color: colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Divider(color: colorScheme.surfaceContainerHighest),
                      ],
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
