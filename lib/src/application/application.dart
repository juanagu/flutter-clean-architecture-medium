import 'package:app/src/features/home/presentation/home_feature.dart';
import 'package:app/src/features/sign_up/sign_up_feature.dart';
import 'package:app/src/features/tweet_creation/tweet_creation_feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/src/features/auth/auth_index_feature.dart';
import 'package:app/src/features/sign_in/sign_in_feature.dart';

import 'localizations/i18n.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AuthIndexFeature.Route,
      onGenerateTitle: (context) => I18n.of(context).translate('app_title'),
      themeMode: ThemeMode.system,
      routes: generateRoutes(),
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales:
          I18n.Languages.map((language) => Locale(language)).toList(),
    );
  }

  Map<String, WidgetBuilder> generateRoutes() {
    return {
      ...AuthIndexFeature.generateRoutes(),
      ...SignInFeature.generateRoutes(),
      ...SignUpFeature.generateRoutes(),
      ...HomeFeature.generateRoutes(),
      ...TweetCreationFeature.generateRoutes(),
    };
  }
}
