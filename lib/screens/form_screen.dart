import 'package:flutter/material.dart';
import '../models/register.dart';
import 'summary_screen.dart';
import 'package:avmilvil_p4/generated/l10n/app_localizations.dart';

class FormScreen extends StatefulWidget {
  final void Function(Locale) onChangeLanguage;

  const FormScreen({super.key, required this.onChangeLanguage});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? email;
  String eventType = 'hackathon';
  String preference = 'salaA';
  DateTime date = DateTime.now();
  bool acceptTerms = false;
  String? checkboxError;

  double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 200 : 16;
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => date = picked);
  }

  void _showDialog() {
    final t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.confirmMessage),
        content: Text(t.confirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final register = Register(
                name: name!,
                email: email!,
                date: date,
                eventType: eventType,
                preference: preference,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SummaryScreen(
                    register: register,
                    onChangeLanguage: widget.onChangeLanguage,
                  ),
                ),
              );
            },
            child: Text(t.accept),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).appTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('English'),
                onTap: () {
                  widget.onChangeLanguage(const Locale('en'));
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Español'),
                onTap: () {
                  widget.onChangeLanguage(const Locale('es'));
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Français'),
                onTap: () {
                  widget.onChangeLanguage(const Locale('fr'));
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
        title: Text(t.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: t.appTitle,
            onPressed: _showLanguageDialog,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: t.name),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return t.fieldRequired;
                    return null;
                  },
                  onSaved: (value) => name = value,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: t.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return t.fieldRequired;
                    return null;
                  },
                  onSaved: (value) => email = value,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: eventType,
                  decoration: InputDecoration(labelText: t.eventType),
                  items: [
                    DropdownMenuItem(value: 'hackathon', child: Text(t.hackathon)),
                    DropdownMenuItem(value: 'festival', child: Text(t.festival)),
                    DropdownMenuItem(value: 'concierto', child: Text(t.concierto)),
                    DropdownMenuItem(value: 'seminario', child: Text(t.seminario)),
                  ],
                  onChanged: (v) => setState(() => eventType = v!),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: preference,
                  decoration: InputDecoration(labelText: t.preference),
                  items: [
                    DropdownMenuItem(value: 'salaA', child: Text(t.salaA)),
                    DropdownMenuItem(value: 'salaB', child: Text(t.salaB)),
                    DropdownMenuItem(value: 'salaC', child: Text(t.salaC)),
                  ],
                  onChanged: (v) => setState(() => preference = v!),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text('${t.selectDate}: ${date.day}/${date.month}/${date.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _pickDate,
                ),
                CheckboxListTile(
                  title: Text(t.acceptTerms),
                  value: acceptTerms,
                  onChanged: (v) => setState(() {
                      acceptTerms = v!;
                      checkboxError = null;
                  }),
                ),
                if (checkboxError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Text(
                      checkboxError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && acceptTerms) {
                        _formKey.currentState!.save();
                        _showDialog();
                      } else{
                        setState(() {
                          checkboxError = t.acceptTermsWarning;
                        }); 
                      }
                    },
                    child: Text(t.send),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
