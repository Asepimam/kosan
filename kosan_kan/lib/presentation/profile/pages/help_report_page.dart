import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kosan_kan/l10n/app_localizations.dart';

class HelpReportPage extends StatelessWidget {
  const HelpReportPage({Key? key}) : super(key: key);

  Future<void> _openEmail(BuildContext context, String email) async {
    final uri = Uri.parse('mailto:$email?subject=Report%20Issue');
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
        title: Text(loc.t('help_report_issue')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.t('help_report_issue'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(loc.t('help_intro')),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.bug_report_outlined),
              label: Text(loc.t('help_report_issue')),
              onPressed: () => _openEmail(context, 'support@kosankan.app'),
            ),
          ],
        ),
      ),
    );
  }
}
