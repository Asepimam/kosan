import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kosan_kan/l10n/app_localizations.dart';

class HelpContactPage extends StatelessWidget {
  const HelpContactPage({Key? key}) : super(key: key);

  Future<void> _openEmail(BuildContext context, String email) async {
    final uri = Uri.parse('mailto:$email?subject=Help%20Request');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).t('help_email_failed')),
        ),
      );
    }
  }

  Future<void> _callNumber(BuildContext context, String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).t('help_call_failed')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).canPop()
              ? Navigator.of(context).pop()
              : context.go('/app?tab=profile'),
        ),
        title: Text(loc.t('help_contact_title')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text(loc.t('help_contact_title')),
              subtitle: Text(loc.t('help_contact_email')),
              onTap: () => _openEmail(context, loc.t('help_contact_email')),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: Text(loc.t('help_contact_call')),
              subtitle: Text(loc.t('help_contact_phone')),
              onTap: () => _callNumber(context, loc.t('help_contact_phone')),
            ),
          ],
        ),
      ),
    );
  }
}
