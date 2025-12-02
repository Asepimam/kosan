import 'package:flutter/material.dart';
import 'package:kosan_kan/data/local/app_prefrence.dart';

// Simple app-wide notifier for new booking badge
final ValueNotifier<bool> hasNewBooking = ValueNotifier<bool>(false);
// Notifier for API availability/network state. True = API reachable.
final ValueNotifier<bool> apiAvailable = ValueNotifier<bool>(true);
// App-wide locale notifier. UI can listen and rebuild when the user changes language.
final ValueNotifier<Locale> localeNotifier = ValueNotifier<Locale>(
  Locale(AppPrefrence.languageCode),
);
