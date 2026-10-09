import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/theme/app_theme.dart';
import 'package:app/src/features/auth/auth_index_feature.dart';
import 'package:app/src/features/home/home_feature.dart';
import 'package:app/src/features/sign_in/sign_in_feature.dart';
import 'package:app/src/features/sign_up/sign_up_feature.dart';
import 'package:app/src/features/tweet_creation/tweet_creation_feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => I18n.of(context).translate('app_title'),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: AuthIndexFeature.route,
      routes: _routes(),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: I18n.languages.map(Locale.new).toList(),
    );
  }

  Map<String, WidgetBuilder> _routes() {
    return {
      ...AuthIndexFeature.generateRoutes(),
      ...SignInFeature.generateRoutes(),
      ...SignUpFeature.generateRoutes(),
      ...HomeFeature.generateRoutes(),
      ...TweetCreationFeature.generateRoutes(),
    };
  }
}
