// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MediaWipe';

  @override
  String get authorizeWelcome => 'Welcome on MediaWipe!';

  @override
  String get authorizeDescription =>
      'Sort your photos in an easy and convenient way';

  @override
  String get authorizeCTA => 'Authorize';

  @override
  String sortSummaryTitle(num length) {
    final intl.NumberFormat lengthNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String lengthString = lengthNumberFormat.format(length);

    return '$lengthString photos to delete';
  }

  @override
  String get sortSummaryEmptyTitle => 'Nothing to delete!';

  @override
  String get sortSummaryEmptyCTA => 'Go to main screen';

  @override
  String get sortSummaryRefineCTA => 'Refine';

  @override
  String get sortSummaryDeleteCTA => 'Delete';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsToS => 'Terms of Service';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsAuthorizeAccess => 'Authorize access to photos';

  @override
  String get settingsDryRemoval => '[DEBUG] Dry removal';

  @override
  String get settingsRateApp => 'Rate the app!';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get listingYearsTitle => 'Media Wipe';
}
