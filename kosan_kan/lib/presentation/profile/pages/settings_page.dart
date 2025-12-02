import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kosan_kan/data/local/app_prefrence.dart';
import 'package:kosan_kan/l10n/app_localizations.dart';
// Theme state removed: dark-mode toggle has been removed from settings.
import 'package:kosan_kan/app/notifications.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _language = AppPrefrence.languageCode;

  final Map<String, String> _available = {
    'en': 'language_english',
    'id': 'language_indonesian',
  };

  void _onLanguageChanged(String? code) async {
    if (code == null) return;
    await AppPrefrence.setLanguageCode(code);
    if (!mounted) return;
    setState(() => _language = code);
    // update app-wide locale immediately
    try {
      localeNotifier.value = Locale(code);
    } catch (_) {}

    final loc = AppLocalizations.of(context);
    final langKey = _available[code] ?? code;
    final langName = loc.t(langKey);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.t('language_set_to', params: {'lang': langName})),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            // If there is a navigation back stack, pop normally.
            // Otherwise navigate to the app shell with the Profile tab so
            // the bottom navigation is present.
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/app?tab=profile');
            }
          },
        ),
        title: Text(
          AppLocalizations.of(context).t('settings_title'),
          style: TextStyle(color: colorScheme.onSurface),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).t('preferences'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          // Compact language selector: tap to open picker
          Card(
            color: colorScheme.surface,
            child: ListTile(
              title: Text(
                AppLocalizations.of(
                  context,
                ).t('settings_change_language_title'),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                ).t('settings_change_language_subtitle'),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _language == 'id' ? '🇮🇩' : '🇬🇧',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
              onTap: _openLanguagePicker,
            ),
          ),

          const SizedBox(height: 12),

          // Change password card
          Card(
            color: colorScheme.surface,
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: Text(
                AppLocalizations.of(
                  context,
                ).t('settings_change_password_title'),
                style: TextStyle(color: colorScheme.onSurface),
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                ).t('settings_change_password_subtitle'),
              ),
              onTap: () => context.push('/profile/change-password'),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> _openLanguagePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(
                        ctx,
                      ).t('settings_language_picker_title'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ..._available.keys.map((code) {
                final flag = code == 'id' ? '🇮🇩' : '🇬🇧';
                final loc = AppLocalizations.of(ctx);
                final title = loc.t(_available[code]!);
                return ListTile(
                  leading: Text(flag, style: const TextStyle(fontSize: 24)),
                  title: Text(title),
                  trailing: _language == code
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    _onLanguageChanged(code);
                    Navigator.of(ctx).pop();
                  },
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
