import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TranslationsHelper {
  TranslationsHelper._();
  static getDeviceLanguage(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    var _deviceLanguage = context.deviceLocale.languageCode;
    switch (_deviceLanguage) {
      case 'tr':
        return LocaleType.tr;
      case 'en':
        return LocaleType.en;

      default:
        return LocaleType.en;
    }
  }
}
