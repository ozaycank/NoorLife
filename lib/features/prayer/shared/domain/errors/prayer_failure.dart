import '../../../../../core/errors/failure.dart';

class PrayerFailure extends Failure {
  const PrayerFailure(super.message, {super.code});
}

class PrayerLocationFailure extends PrayerFailure {
  const PrayerLocationFailure(super.message, {super.code});
}

class PrayerCalculationFailure extends PrayerFailure {
  const PrayerCalculationFailure(super.message, {super.code});
}
