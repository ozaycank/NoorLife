// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'NoorLife';

  @override
  String get splashLoading => 'Uygulama yükleniyor...';

  @override
  String get generalError =>
      'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get loginTitle => 'Tekrar Hoş Geldiniz';

  @override
  String get loginSubtitle =>
      'Günlük manevi yolculuğunuza devam etmek için giriş yapın.';

  @override
  String get emailLabel => 'E-posta Adresi';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get confirmPasswordLabel => 'Şifreyi Onayla';

  @override
  String get rememberMe => 'Beni hatırla';

  @override
  String get forgotPassword => 'Şifremi Unuttum?';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get guestLoginButton => 'Misafir Olarak Devam Et';

  @override
  String get noAccountText => 'Hesabınız yok mu? ';

  @override
  String get registerLink => 'Kayıt Ol';

  @override
  String get registerTitle => 'Hesap Oluştur';

  @override
  String get registerSubtitle =>
      'NoorLife\'a katılın ve İslami yaşamınızı planlayın.';

  @override
  String get registerButton => 'Hesap Oluştur';

  @override
  String get alreadyHaveAccountText => 'Zaten hesabınız var mı? ';

  @override
  String get loginLink => 'Giriş Yap';

  @override
  String get forgotPasswordTitle => 'Şifre Sıfırla';

  @override
  String get forgotPasswordSubtitle =>
      'Şifre sıfırlama bağlantısı almak için e-posta adresinizi girin.';

  @override
  String get sendResetLinkButton => 'Sıfırlama Bağlantısı Gönder';

  @override
  String get resetEmailSentSuccess =>
      'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.';

  @override
  String get emailVerificationTitle => 'E-postanızı Doğrulayın';

  @override
  String get emailVerificationSubtitle =>
      'Adresinize bir doğrulama e-postası gönderdik. Devam etmek için lütfen hesabınızı doğrulayın.';

  @override
  String get checkVerificationButton => 'Doğruladım';

  @override
  String get resendEmailButton => 'Doğrulama E-postasını Tekrar Gönder';

  @override
  String resendCooldownText(int seconds) {
    return '$seconds sn sonra tekrar gönderilebilir';
  }

  @override
  String get verificationEmailSent =>
      'Doğrulama e-postası başarıyla gönderildi.';

  @override
  String get emailNotVerifiedYet =>
      'E-posta adresiniz henüz doğrulanmadı. Lütfen kutunuzu kontrol edin.';

  @override
  String get logoutButton => 'Çıkış Yap';

  @override
  String get validationEmailEmpty => 'Lütfen bir e-posta adresi girin.';

  @override
  String get validationEmailInvalid =>
      'Lütfen geçerli bir e-posta adresi girin.';

  @override
  String get validationPasswordEmpty => 'Lütfen bir şifre girin.';

  @override
  String get validationPasswordLength =>
      'Şifre 8 ile 64 karakter arasında olmalıdır.';

  @override
  String get validationPasswordStrength =>
      'Şifre en az bir büyük harf, küçük harf ve rakam içermelidir.';

  @override
  String get validationConfirmPasswordEmpty => 'Lütfen şifrenizi onaylayın.';

  @override
  String get validationPasswordMismatch => 'Şifreler eşleşmiyor.';

  @override
  String get validationNoWhitespace => 'Bu alan boşluk içeremez.';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navPrayer => 'Namaz';

  @override
  String get navQuran => 'Kur\'an';

  @override
  String get navActivity => 'İbadetim';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeTitle => 'Ana Sayfa';

  @override
  String get homeDesc =>
      'NoorLife\'a hoş geldiniz. Günlük manevi özetiniz burada görüntülenecektir.';

  @override
  String get prayerTitle => 'Namaz Vakitleri';

  @override
  String get prayerDesc =>
      'Doğru namaz vakitleri ve kıble yönü burada gösterilecektir.';

  @override
  String get quranTitle => 'Kur\'an-ı Kerim';

  @override
  String get quranDesc =>
      'Kur\'an okuma, sesli tilavetler ve yer işaretleri burada yer alacaktır.';

  @override
  String get activityTitle => 'İbadet Takibi';

  @override
  String get activityDesc =>
      'Günlük namaz, zikir ve oruç ibadetlerinizi buradan takip edin.';

  @override
  String get profileTitle => 'Kullanıcı Profili';

  @override
  String get profileDesc =>
      'NoorLife hesabınızı, tercihlerinizi ve kişisel istatistiklerinizi yönetin.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsDesc =>
      'Bildirimleri, hesaplama yöntemlerini ve uygulama temalarını yapılandırın.';

  @override
  String get openSettingsButton => 'Ayarları Aç';

  @override
  String get emptyStateDefaultTitle => 'İçerik Bulunmuyor';

  @override
  String get emptyStateDefaultDesc =>
      'Bu modül gelecekteki fazlar için geliştirme aşamasındadır.';

  @override
  String get errorStateDefaultTitle => 'Bir Hata Oluştu';

  @override
  String get retryButton => 'Tekrar Dene';

  @override
  String get prayerFajr => 'İmsak';

  @override
  String get prayerSunrise => 'Güneş';

  @override
  String get prayerDhuhr => 'Öğle';

  @override
  String get prayerAsr => 'İkindi';

  @override
  String get prayerMaghrib => 'Akşam';

  @override
  String get prayerIsha => 'Yatsı';

  @override
  String get prayerNextPrayer => 'Sıradaki Vakit';

  @override
  String get prayerRemainingTime => 'Kalan Süre';

  @override
  String get prayerCalculationMethod => 'Hesaplama Yöntemi';

  @override
  String get prayerMadhab => 'Mezhep';

  @override
  String get prayerLocationHeader => 'Konum';

  @override
  String get prayerRefreshButton => 'Vakitleri Yenile';

  @override
  String get prayerSettingsTitle => 'Namaz Ayarları';

  @override
  String get prayerSettingsDesc =>
      'Hesaplama yöntemlerini ve mezhep tercihlerinizi düzenleyin.';

  @override
  String get locationTitle => 'Konum Ayarları';

  @override
  String get currentLocation => 'Mevcut Konum';

  @override
  String get refreshLocation => 'Konumu Güncelle';

  @override
  String get locationUnavailable => 'Konum Bulunamadı';

  @override
  String get locationPermissionDenied => 'Konum izni gerekiyor.';

  @override
  String get locationServiceDisabled => 'Konum servisleri kapalı.';

  @override
  String get locationGeocodingFailed => 'Adres çözümlenemedi.';

  @override
  String get timezoneLabel => 'Zaman Dilimi';

  @override
  String get coordinatesLabel => 'Koordinatlar';

  @override
  String get unknownCountry => 'Bilinmiyor';

  @override
  String get prayerCalculationTitle => 'Hesaplama Yöntemleri';

  @override
  String get calculationMethodLabel => 'Hesaplama Yöntemi';

  @override
  String get madhabLabel => 'Mezhep';

  @override
  String get highLatitudeStrategyLabel => 'Yüksek Enlem Kuralı';

  @override
  String get calculationMethodSaved => 'Ayarlar başarıyla kaydedildi.';

  @override
  String get settingsSaveFailed => 'Ayarlar kaydedilirken hata oluştu.';

  @override
  String get angleBasedLabel => 'Açı Tabanlı';

  @override
  String get oneSeventhLabel => 'Yedide Bir';

  @override
  String get nightMiddleLabel => 'Gecenin Yarısı';

  @override
  String get noneLabel => 'Yok';

  @override
  String get qiblaTitle => 'Kıble Yönü';

  @override
  String get qiblaDirection => 'Yön';

  @override
  String get qiblaBearing => 'Açı';

  @override
  String get qiblaLocation => 'Konum';

  @override
  String get qiblaUnavailable =>
      'Kıble yönü hesaplanamıyor. Lütfen konumunuzun ayarlı olduğundan emin olun.';

  @override
  String get qiblaCalculationError =>
      'Kıble yönü hesaplanırken bir hata oluştu.';

  @override
  String get dirNorth => 'K';

  @override
  String get dirNorthEast => 'KD';

  @override
  String get dirEast => 'D';

  @override
  String get dirSouthEast => 'GD';

  @override
  String get dirSouth => 'G';

  @override
  String get dirSouthWest => 'GB';

  @override
  String get dirWest => 'B';

  @override
  String get dirNorthWest => 'KB';

  @override
  String get qiblaDisclaimer =>
      'Konumunuza göre hesaplanmıştır. Telefon pusulası ile yönlendirme henüz etkin değildir.';

  @override
  String get qiblaUndefinedAtKaaba => 'Kâbe\'desiniz. Kıble yönü tanımsızdır.';

  @override
  String get qiblaCompass => 'Kıble Pusulası';

  @override
  String get qiblaHeading => 'Cihaz Yönü';

  @override
  String get qiblaRelativeAngle => 'Göreceli Açı';

  @override
  String turnLeft(String degrees) {
    return '$degrees° sola dönün';
  }

  @override
  String turnRight(String degrees) {
    return '$degrees° sağa dönün';
  }

  @override
  String get qiblaAligned => 'Kıble yönündesiniz';

  @override
  String get compassUnavailable => 'Pusula Kullanılamıyor';

  @override
  String get compassSensorUnavailable =>
      'Cihazınızda pusula sensörü bulunmuyor.';

  @override
  String get compassUnsupportedPlatform =>
      'Pusula bu platformda desteklenmiyor.';

  @override
  String get compassError => 'Pusula sensörü okunamadı.';

  @override
  String get languageLabel => 'Uygulama Dili';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get methodMWL => 'Müslüman Dünya Birliği';

  @override
  String get methodISNA => 'Kuzey Amerika İslam Cemiyeti';

  @override
  String get methodEgypt => 'Mısır Genel Araştırma Kurumu';

  @override
  String get methodMakkah => 'Ümmül Kura Üniversitesi, Mekke';

  @override
  String get methodKarachi => 'İslam Bilimleri Üniversitesi, Karaçi';

  @override
  String get methodTehran => 'Tahran Üniversitesi Jeofizik Enstitüsü';

  @override
  String get methodShia => 'Şia İsna Aşeri';

  @override
  String get methodGulf => 'Körfez Bölgesi';

  @override
  String get methodKuwait => 'Kuveyt';

  @override
  String get methodQatar => 'Katar';

  @override
  String get methodSingapore => 'Singapur İslam Diyanet Meclisi';

  @override
  String get methodFrance => 'Fransa İslami Kuruluşlar Birliği';

  @override
  String get methodTurkey => 'Diyanet Yaklaşım Profili';

  @override
  String get methodRussia => 'Rusya Müslümanları Dini İdaresi';

  @override
  String get methodMoonsighting => 'Küresel Hilal Gözlem Komitesi';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodJakim => 'Malezya İslam Gelişim Departmanı';

  @override
  String get methodTunisia => 'Tunus Din İşleri Bakanlığı';

  @override
  String get methodAlgeria => 'Cezayir Din İşleri Bakanlığı';

  @override
  String get methodKemenag => 'Endonezya Din İşleri Bakanlığı';

  @override
  String get methodMorocco => 'Fas Vakıflar ve İslam İşleri Bakanlığı';

  @override
  String get methodPortugal => 'Paris Büyük Camii';

  @override
  String get methodJafari => 'Şia İsna Aşeri (Caferi)';

  @override
  String get madhabStandard => '1 Katı Gölge Boyu (Cumhur)';

  @override
  String get madhabHanafi => '2 Katı Gölge Boyu (Hanefi)';

  @override
  String get hijriMuharram => 'Muharrem';

  @override
  String get hijriSafar => 'Safer';

  @override
  String get hijriRabiAlAwwal => 'Rebiülevvel';

  @override
  String get hijriRabiAlThani => 'Rebiülahir';

  @override
  String get hijriJumadaAlAwwal => 'Cemaziyelevvel';

  @override
  String get hijriJumadaAlThani => 'Cemaziyelahir';

  @override
  String get hijriRajab => 'Recep';

  @override
  String get hijriShaaban => 'Şaban';

  @override
  String get hijriRamadan => 'Ramazan';

  @override
  String get hijriShawwal => 'Şevval';

  @override
  String get hijriDhuAlQiDah => 'Zilkade';

  @override
  String get hijriDhuAlHijjah => 'Zilhicce';

  @override
  String get asrConventionDesc => 'İkindi vakti hesaplama kuralı';

  @override
  String get homeGreeting => 'Selamun Aleyküm';

  @override
  String get homeToday => 'Bugünün Vakitleri';

  @override
  String get nextPrayerHeader => 'Sıradaki Vakit';

  @override
  String get viewQibla => 'Kıble Yönü';

  @override
  String get openSettings => 'Uygulama Ayarları';

  @override
  String get homePrayerError => 'Namaz vakitleri yüklenemedi.';

  @override
  String get homePrayerRetry => 'Konumu Yenile';

  @override
  String get homeComingSoon => 'Yakında';

  @override
  String get quranSearchHint => 'Sure Ara';

  @override
  String get quranNoSurahFound => 'Sure bulunamadı.';

  @override
  String get quranMeccan => 'Mekkî';

  @override
  String get quranMedinan => 'Medenî';

  @override
  String quranAyahCount(int count) {
    return '$count Ayet';
  }

  @override
  String get quranDetailPlaceholderText =>
      'Kur\'an metni okuyucusu sonraki fazda eklenecektir.';

  @override
  String get quranContinueReading => 'Okumaya Devam Et';

  @override
  String get quranLastRead => 'Son Okunan';

  @override
  String get quranAyah => 'Ayet';

  @override
  String get quranContinue => 'Devam Et';

  @override
  String get quranNoHistory => 'Henüz okuma geçmişi yok.';

  @override
  String get quranBookmarks => 'Yer İmleri';

  @override
  String get quranBookmarkAdd => 'Yer İmine Ekle';

  @override
  String get quranBookmarkRemove => 'Yer İmini Kaldır';

  @override
  String get quranNoBookmarksYet => 'Henüz yer imi yok.';

  @override
  String get quranReaderSettings => 'Okuyucu Ayarları';

  @override
  String get quranTextSize => 'Metin Boyutu';

  @override
  String get quranResetDefault => 'Varsayılana Sıfırla';

  @override
  String get quranShowTranslation => 'Meali Göster';

  @override
  String get quranTranslationUnavailable => 'Meal bulunamadı.';

  @override
  String get homeDailyOverview => 'Günün Özeti';

  @override
  String get homeNextPrayer => 'Sıradaki Vakit';

  @override
  String get homeRemaining => 'kaldı';

  @override
  String get homePrayerTimes => 'Namaz Vakitleri';

  @override
  String get homeContinueReading => 'Okumaya Devam Et';

  @override
  String get homeBookmarks => 'Yer İmleri';

  @override
  String homeSavedAyahs(int count) {
    return '$count kayıtlı ayet';
  }

  @override
  String get homeQibla => 'Kıble';

  @override
  String get homeSettings => 'Ayarlar';

  @override
  String get homeLocationUnavailable => 'Konum bulunamadı';

  @override
  String get homePrayerFajr => 'İmsak';

  @override
  String get homePrayerSunrise => 'Güneş';

  @override
  String get homePrayerDhuhr => 'Öğle';

  @override
  String get homePrayerAsr => 'İkindi';

  @override
  String get homePrayerMaghrib => 'Akşam';

  @override
  String get homePrayerIsha => 'Yatsı';

  @override
  String get descDiyarTurk =>
      'Diyanet Başkanlığı standart namaz ve temkin profili.';

  @override
  String get descMwl =>
      'Avrupa ve Asya\'da yaygın olarak kullanılan standart yöntem.';

  @override
  String get descIsna => 'Kuzey Amerika için standart hesaplama yöntemi.';

  @override
  String get descEgypt => 'Afrika ve Orta Doğu\'daki standart yöntem.';

  @override
  String get descMakkah => 'Arap Yarımadası\'ndaki standart yöntem.';
}
