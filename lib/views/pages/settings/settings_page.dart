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
  static const _blue = Color(0xFF0C60A1);
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF1F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF1F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0A1C2C),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        physics: const BouncingScrollPhysics(),
        children: [
          _section('Appearance', [
            _row(
              Icons.dark_mode_outlined,
              'Dark Mode',
              trailing: Switch(
                value: _darkMode,
                activeThumbColor: Colors.white,
                activeTrackColor: _blue,
                onChanged: (value) => setState(() => _darkMode = value),
              ),
            ),
            _divider(),
            _row(
              Icons.language_outlined,
              'Language',
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'English',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A6E7F),
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.chevron_right_rounded, color: Color(0xFF8A9BA8)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _section('Preferences', [
            _row(
              Icons.notifications_none_rounded,
              'Notifications',
              trailing: Switch(
                value: _notifications,
                activeThumbColor: Colors.white,
                activeTrackColor: _blue,
                onChanged: (value) => setState(() => _notifications = value),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _section('Storage', [
            _row(
              Icons.heart_broken_outlined,
              'Clear Favorites',
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: _clearFavorites,
              ),
            ),
            _divider(),
            _row(
              Icons.cleaning_services_outlined,
              'Clear Cache',
              subtitle: '124 MB used',
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: _clearCache,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _section('Information', [
            _row(
              Icons.info_outline_rounded,
              'About Pokédex Explorer',
              trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF8A9BA8)),
            ),
            _divider(),
            _row(
              Icons.policy_outlined,
              'Privacy Policy',
              trailing: const Icon(Icons.open_in_new_rounded, size: 18, color: Color(0xFF8A9BA8)),
            ),
            _divider(),
            _row(
              Icons.terminal_rounded,
              'Version Info',
              trailing: const Text(
                'v4.12.0 (Build 2026)',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5A6E7F),
                  fontSize: 13,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 32),
          Center(
            child: TextButton.icon(
              onPressed: _signOut,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFE53935),
              ),
              label: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF0A1C2C),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.8),
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(children: children),
          ),
        ],
      );

  Widget _row(
    IconData icon,
    String title, {
    String? subtitle,
    required Widget trailing,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _blue, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0A1C2C),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF5A6E7F),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing,
          ],
        ),
      );

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Divider(height: 1, color: Color(0xFFE2E8F0)),
      );

  void _clearFavorites() => _toast('Favorites cleared');
  void _clearCache() => _toast('Cache cleared');

  void _toast(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  void _signOut() {
    context.read<AuthBloc>().add(AuthLogoutRequested());
    context.go('/login');
  }
}
