import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kosan_kan/l10n/app_localizations.dart';

class HelpFaqPage extends StatelessWidget {
  const HelpFaqPage({Key? key}) : super(key: key);

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
        title: Text(loc.t('help_faq_title')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExpansionTile(
            title: Text(loc.t('help_faq_q1')),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(loc.t('help_faq_a1')),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(loc.t('help_faq_q2')),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(loc.t('help_faq_a2')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
