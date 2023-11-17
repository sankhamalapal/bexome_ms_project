import 'package:flutter/cupertino.dart';
import 'demo_localization.dart';

class Translation {
  String getTranslation(BuildContext context, String key) {
    return DemoLocalizations.of(context).getTranslatedValues(key);
  }
}
