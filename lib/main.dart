import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:otlob_gas/common/constants/providers.dart';
import 'package:otlob_gas/common/routes/routes.dart';
import 'package:otlob_gas/features/on_boarding/presentation/provider/splash_provider.dart';
import 'package:otlob_gas/firebase_options.dart';
import 'package:otlob_gas/injection.dart' as di;
import 'package:provider/provider.dart';

import 'common/constants/theme_manager.dart';

// todo change in pod file =>  platform :ios, '9.0'

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.providers,
      child: Builder(builder: (context) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: Routes.router,
          title:
              '${AppLocalizations.of(context)?.appTitleR ?? ''} ${AppLocalizations.of(context)?.appTitleL ?? ''}',
          theme: applicationTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(context.watch<SplashProvider>().language),
        );
      }),
    );
  }
}
