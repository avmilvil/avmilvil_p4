import 'package:flutter/material.dart';
import '../models/register.dart';
import 'package:avmilvil_p4/generated/l10n/app_localizations.dart';

class SummaryScreen extends StatelessWidget {
  final Register register;
  final void Function(Locale) onChangeLanguage;

  const SummaryScreen({super.key, required this.register, required this.onChangeLanguage});

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).summary),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('English'),
                onTap: () {
                  onChangeLanguage(const Locale('en'));
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Español'),
                onTap: () {
                  onChangeLanguage(const Locale('es'));
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Français'),
                onTap: () {
                  onChangeLanguage(const Locale('fr'));
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.summary),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: t.summary,
            onPressed: () => _showLanguageDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile_pic.png'),
            ),
            const SizedBox(height: 20),
            Text('${t.name}: ${register.name}'),
            Text('${t.email}: ${register.email}'),
            Text('${t.eventType}: ${register.eventType}'),
            Text('${t.preference}: ${register.preference}'),
            Text('Date: ${register.date.day}/${register.date.month}/${register.date.year}'),
          ],
        ),
      ),
    );
  }
}
