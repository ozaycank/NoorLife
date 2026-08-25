import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extensions.dart';

class PresentationLocalizer {
  PresentationLocalizer._();

  static String localizePrayerNameRaw(BuildContext context, String rawName) {
    final nameLower = rawName.toLowerCase();
    switch (nameLower) {
      case 'fajr':
        return context.l10n.prayerFajr;
      case 'sunrise':
        return context.l10n.prayerSunrise;
      case 'dhuhr':
        return context.l10n.prayerDhuhr;
      case 'asr':
        return context.l10n.prayerAsr;
      case 'maghrib':
        return context.l10n.prayerMaghrib;
      case 'isha':
        return context.l10n.prayerIsha;
      default:
        return rawName;
    }
  }

  static String localizePrayerName(BuildContext context, dynamic name) {
    return localizePrayerNameRaw(context, name.toString().split('.').last);
  }

  static String localizeHijriMonth(BuildContext context, int monthIndex) {
    final l10n = context.l10n;
    switch (monthIndex) {
      case 1:
        return l10n.hijriMuharram;
      case 2:
        return l10n.hijriSafar;
      case 3:
        return l10n.hijriRabiAlAwwal;
      case 4:
        return l10n.hijriRabiAlThani;
      case 5:
        return l10n.hijriJumadaAlAwwal;
      case 6:
        return l10n.hijriJumadaAlThani;
      case 7:
        return l10n.hijriRajab;
      case 8:
        return l10n.hijriShaaban;
      case 9:
        return l10n.hijriRamadan;
      case 10:
        return l10n.hijriShawwal;
      case 11:
        return l10n.hijriDhuAlQiDah;
      case 12:
        return l10n.hijriDhuAlHijjah;
      default:
        return '-';
    }
  }

  // Akıllı Hicri ayrıştırıcı (e.g., "11 Safar 1445" veya "1445-02-11" hepsini anlar)
  static String formatSmartHijri(BuildContext context, String? rawHijri) {
    if (rawHijri == null || rawHijri.isEmpty) return '-';

    // "1445-02-11" gibi YYYY-MM-DD formatı mı?
    if (rawHijri.contains('-')) {
      final parts = rawHijri.split('-');
      if (parts.length >= 3) {
        final year = parts[0];
        final monthIdx = int.tryParse(parts[1]);
        final day = parts[2];
        if (monthIdx != null) {
          final localizedMonth = localizeHijriMonth(context, monthIdx);
          return '$day $localizedMonth $year';
        }
      }
    }
    // "11 Safar 1445" gibi metin tabanlı (Adhan paketi bazen bu şekilde dönüyor) format mı?
    else {
      final parts = rawHijri.split(' ');
      if (parts.length >= 3) {
        final day = parts[0];
        final year = parts.last;
        // Ay ismini eşleştirmeye çalış (İngilizce dönebiliyor)
        final rawMonthStr =
            parts.sublist(1, parts.length - 1).join(' ').toLowerCase();

        int monthIdx = 0;
        if (rawMonthStr.contains('muharram')) {
          monthIdx = 1;
        } else if (rawMonthStr.contains('safar')) {
          monthIdx = 2;
        } else if (rawMonthStr.contains('rabi') &&
            rawMonthStr.contains('awwal')) {
          monthIdx = 3;
        } else if (rawMonthStr.contains('rabi') &&
            rawMonthStr.contains('thani')) {
          monthIdx = 4;
        } else if (rawMonthStr.contains('jumada') &&
            rawMonthStr.contains('awwal')) {
          monthIdx = 5;
        } else if (rawMonthStr.contains('jumada') &&
            rawMonthStr.contains('thani')) {
          monthIdx = 6;
        } else if (rawMonthStr.contains('rajab')) {
          monthIdx = 7;
        } else if (rawMonthStr.contains('sha')) {
          monthIdx = 8; // Sha'ban
        } else if (rawMonthStr.contains('ramadan')) {
          monthIdx = 9;
        } else if (rawMonthStr.contains('shawwal')) {
          monthIdx = 10;
        } else if (rawMonthStr.contains('dhu') && rawMonthStr.contains('qi')) {
          monthIdx = 11;
        } else if (rawMonthStr.contains('dhu') &&
            rawMonthStr.contains('hijjah')) {
          monthIdx = 12;
        }

        if (monthIdx > 0) {
          final localizedMonth = localizeHijriMonth(context, monthIdx);
          return '$day $localizedMonth $year';
        }
      }
    }
    // Hiç ayrıştıramadıysan geldiği gibi göster (Fallback)
    return rawHijri;
  }

  static String formatLocation({
    required BuildContext context,
    String? cityName,
    String? subAdminArea,
    String? countryName,
  }) {
    if (cityName == null && subAdminArea == null && countryName == null) {
      return context.l10n.unknownCountry;
    }

    final parts = <String>[];

    if (cityName != null && cityName.isNotEmpty) {
      parts.add(cityName);
    }
    if (subAdminArea != null &&
        subAdminArea.isNotEmpty &&
        subAdminArea != cityName) {
      parts.add(subAdminArea);
    }
    if (countryName != null &&
        countryName.isNotEmpty &&
        countryName != cityName &&
        countryName != subAdminArea) {
      parts.add(countryName);
    }

    if (parts.isEmpty) return context.l10n.unknownCountry;
    return parts.join(', ');
  }

  static String localizeCalculationMethod(BuildContext context, String id) {
    final l10n = context.l10n;
    switch (id) {
      case 'diyar_turk':
        return l10n.methodTurkey;
      case 'mwl':
        return l10n.methodMWL;
      case 'isna':
        return l10n.methodISNA;
      case 'egypt':
        return l10n.methodEgypt;
      case 'makkah':
        return l10n.methodMakkah;
      case 'karachi':
        return l10n.methodKarachi;
      default:
        return id;
    }
  }

  static String localizeMadhab(BuildContext context, String id) {
    final l10n = context.l10n;
    switch (id) {
      case 'shafi_hanbali_maliki':
        return l10n.madhabStandard;
      case 'hanafi':
        return l10n.madhabHanafi;
      default:
        return id;
    }
  }
}
