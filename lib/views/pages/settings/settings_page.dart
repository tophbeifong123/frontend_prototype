import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _blue = Color(0xFF005DAC);
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FD),
        foregroundColor: _blue,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/home')),
        title: const Text('Settings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _blue)),
        actions: const [Padding(padding: EdgeInsets.only(right: 20), child: CircleAvatar(radius: 19, backgroundColor: Color(0xFFD4E3FF), child: Icon(Icons.person, color: _blue)))],
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(24, 32, 24, 32), children: [
        _section('Appearance', [
          _row(Icons.dark_mode_outlined, 'Dark Mode', trailing: Switch(value: _darkMode, activeThumbColor: Colors.white, activeTrackColor: _blue, onChanged: (value) => setState(() => _darkMode = value))),
          _divider(),
          _row(Icons.language_outlined, 'Language', trailing: const Row(mainAxisSize: MainAxisSize.min, children: [Text('English', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF414752))), SizedBox(width: 8), Icon(Icons.chevron_right)])),
        ]),
        _section('Preferences', [
          _row(Icons.notifications_none_rounded, 'Notifications', trailing: Switch(value: _notifications, activeThumbColor: Colors.white, activeTrackColor: _blue, onChanged: (value) => setState(() => _notifications = value))),
        ]),
        _section('Storage', [
          _row(Icons.heart_broken_outlined, 'Clear Favorites', trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: _clearFavorites)),
          _divider(),
          _row(Icons.cleaning_services_outlined, 'Clear Cache', subtitle: '124 MB used', trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: _clearCache)),
        ]),
        _section('Information', [
          _row(Icons.info_outline, 'About App', trailing: const Icon(Icons.chevron_right)),
          _divider(),
          _row(Icons.policy_outlined, 'Privacy Policy', trailing: const Icon(Icons.open_in_new)),
          _divider(),
          _row(Icons.terminal_outlined, 'Version info', trailing: const Text('v. 4.12.0 (Build 2024)', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6D7483)))),
        ]),
        const SizedBox(height: 42),
        Center(child: TextButton.icon(onPressed: _signOut, icon: const Icon(Icons.logout_rounded, color: Color(0xFFBA1A1A)), label: const Text('Sign Out', style: TextStyle(color: Color(0xFFBA1A1A), fontSize: 16, fontWeight: FontWeight.w600)))),
      ]),
    );
  }

  Widget _section(String title, List<Widget> children) => Padding(padding: const EdgeInsets.only(bottom: 28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(left: 5, bottom: 12), child: Text(title, style: const TextStyle(color: _blue, fontSize: 18, fontWeight: FontWeight.w700))),
    Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0x4DC1C6D4)), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 3, offset: Offset(0, 1))]), child: Column(children: children)),
  ]));

  Widget _row(IconData icon, String title, {String? subtitle, required Widget trailing}) => Padding(padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 20), child: Row(children: [
    Icon(icon, color: const Color(0xFF303846), size: 28), const SizedBox(width: 26), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)), if (subtitle != null) ...[const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: Color(0xFF717783), fontSize: 13, fontWeight: FontWeight.w500))]])), trailing,
  ]));

  Widget _divider() => const Padding(padding: EdgeInsets.symmetric(horizontal: 34), child: Divider(height: 1, color: Color(0x4DC1C6D4)));
  void _clearFavorites() => _toast('Favorites cleared');
  void _clearCache() => _toast('Cache cleared');
  void _toast(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  void _signOut() { context.read<AuthBloc>().add(AuthLogoutRequested()); context.go('/login'); }
}
