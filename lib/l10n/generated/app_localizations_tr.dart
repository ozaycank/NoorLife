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
}
