import 'package:flutter/material.dart';
import 'package:kosan_kan/app/routes/route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kosan_kan/app/di/getIt.dart' as di;
import 'package:kosan_kan/presentation/auth/bloc/auth_bloc.dart';
import 'package:kosan_kan/presentation/profile/bloc/profile_bloc.dart';
import 'package:kosan_kan/presentation/theme/theme.dart';
import 'package:kosan_kan/presentation/common/server_error_page.dart';
import 'package:kosan_kan/app/notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kosan_kan/l10n/app_localizations.dart';
import 'package:kosan_kan/data/provider/api_client.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _wasAvailable;

  @override
  void initState() {
    super.initState();
    _wasAvailable = apiAvailable.value;
    apiAvailable.addListener(_onApiAvailableChanged);
  }

  void _onApiAvailableChanged() {
    final isAvailable = apiAvailable.value;
    if (isAvailable && !_wasAvailable) {
      // only navigate once when transitioning back to available
      try {
        appRouter.go('/auth/login');
      } catch (_) {}
    }
    setState(() {
      _wasAvailable = isAvailable;
    });
  }

  @override
  void dispose() {
    apiAvailable.removeListener(_onApiAvailableChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
        BlocProvider(create: (context) => di.sl<ProfileBloc>()),
      ],
      child: ValueListenableBuilder<Locale>(
        valueListenable: localeNotifier,
        builder: (context, locale, _) => ValueListenableBuilder<bool>(
          valueListenable: apiAvailable,
          builder: (context, isAvailable, _) {
            if (!isAvailable) {
              // Show the server error page while API is unavailable.
              return MaterialApp(
                title: 'Kosan Kan',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme(),
                locale: locale,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('id')],
                home: ServerErrorPage(
                  onRetry: () async {
                    // force re-check API availability
                    try {
                      await di.sl<ApiClient>().checkApiAvailable(force: true);
                    } catch (_) {}
                  },
                ),
              );
            }

            return MaterialApp.router(
              title: 'Kosan Kan',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme(),
              locale: locale,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('id')],
              routerConfig: appRouter,
            );
          },
        ),
      ),
    );
  }
}
