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

  // Assuming PrayerName is accessible now via prayer_schedule or domain entities
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
