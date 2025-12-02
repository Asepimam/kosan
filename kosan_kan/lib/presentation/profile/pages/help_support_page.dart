import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kosan_kan/l10n/app_localizations.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  // Navigation-only landing page for Help & Support; actions live in subpages.

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
        title: Text(loc.t('help_title')),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            loc.t('help_heading'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(loc.t('help_intro')),
          const SizedBox(height: 20),

          // Contact (navigates to contact page)
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(loc.t('help_contact_title')),
            subtitle: Text(loc.t('help_contact_email')),
            onTap: () => Navigator.of(context).pushNamed('/help/contact'),
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: Text(loc.t('help_contact_call')),
            subtitle: Text(loc.t('help_contact_phone')),
            onTap: () => Navigator.of(context).pushNamed('/help/contact'),
          ),

          const SizedBox(height: 16),
          Text(
            loc.t('help_faq_title'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // FAQs (go to FAQ page)
          ListTile(
            leading: const Icon(Icons.question_answer_outlined),
            title: Text(loc.t('help_faq_title')),
            onTap: () => Navigator.of(context).pushNamed('/help/faq'),
          ),

          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.bug_report_outlined),
            label: Text(loc.t('help_report_issue')),
            onPressed: () => Navigator.of(context).pushNamed('/help/report'),
          ),
        ],
      ),
    );
  }
}
