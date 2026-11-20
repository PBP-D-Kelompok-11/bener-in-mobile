import 'package:flutter/material.dart';

import '../data/benerin_api.dart';
import '../widgets/module_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
    required this.api,
    required this.account,
    required this.onAccountChanged,
  });

  final BenerinApi api;
  final ApiAccount? account;
  final ValueChanged<ApiAccount?> onAccountChanged;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final signedIn = widget.account != null;
    if (!signedIn && !_form.currentState!.validate()) return;

    setState(() {
      _busy = true;
      _error = null;
    });
    final onAccountChanged = widget.onAccountChanged;
    try {
      if (signedIn) {
        await widget.api.logout();
        onAccountChanged(null);
      } else {
        final account = await widget.api.login(
          _username.text.trim(),
          _password.text,
        );
        if (mounted) _password.clear();
        onAccountChanged(account);
      }
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account;

    return ModulePage(
      title: 'Autentikasi & Profil',
      description: account == null
          ? 'Masuk dengan akun Customer atau Mitra dari web bener.in.'
          : '${account.name} · ${account.role == 'customer' ? 'Customer' : 'Mitra Reparasi'}',
      children: [
        if (account == null)
          Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(labelText: 'Username'),
                  textInputAction: TextInputAction.next,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Masukkan username.'
                      : null,
                ),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: 'Kata sandi'),
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Masukkan kata sandi.'
                      : null,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        if (_error != null) Text(_error!),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: Text(account == null ? 'Masuk' : 'Keluar'),
        ),
      ],
    );
  }
}
