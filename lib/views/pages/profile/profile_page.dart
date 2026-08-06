import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _blue = Color(0xFF005DAC);
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  Uint8List? _profilePhoto;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthBloc>().state;
    final email = auth is Authenticated ? auth.username : 'trainer@pokedex.app';
    if (!_initialized) {
      final username = email.split('@').first;
      _nameController.text = username.isEmpty
          ? 'Pokédex Trainer'
          : '${username[0].toUpperCase()}${username.substring(1)}';
      _emailController.text = email;
      _initialized = true;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FD),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: _blue,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: const Color(0xFFD4E3FF),
                      backgroundImage: _profilePhoto == null
                          ? null
                          : MemoryImage(_profilePhoto!),
                      child: _profilePhoto == null
                          ? Text(
                              _initials(_nameController.text),
                              style: const TextStyle(
                                color: _blue,
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Material(
                        color: _blue,
                        shape: const CircleBorder(),
                        child: IconButton(
                          tooltip: 'Choose profile photo',
                          onPressed: _choosePhoto,
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _choosePhoto,
                  icon: const Icon(Icons.upload_outlined, size: 18),
                  label: const Text('Upload photo'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _section('Trainer profile', [
            _editableRow(
              Icons.badge_outlined,
              'Profile name',
              _nameController,
              TextInputType.name,
            ),
            _divider(),
            _editableRow(
              Icons.mail_outline,
              'Email address',
              _emailController,
              TextInputType.emailAddress,
            ),
            _divider(),
            _infoRow(
              Icons.calendar_today_outlined,
              'Member since',
              'August 2026',
            ),
          ]),
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _saveProfile,
              icon: const Icon(Icons.check),
              label: const Text('Save changes'),
            ),
          ),
          const SizedBox(height: 28),
          _section('Pokédex activity', [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 22, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(value: '0', label: 'Favorites'),
                  _Stat(value: '0', label: 'Viewed'),
                  _Stat(value: 'New', label: 'Level'),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> _choosePhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    final bytes = result?.files.single.bytes;
    if (bytes != null && mounted) setState(() => _profilePhoto = bytes);
  }

  void _saveProfile() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile changes saved for this session.'),
      ),
    );
  }

  String _initials(String text) => text
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0])
      .join()
      .toUpperCase();

  Widget _section(String title, List<Widget> children) => Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 12),
              child: Text(
                title,
                style: const TextStyle(
                  color: _blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x4DC1C6D4)),
              ),
              child: Column(children: children),
            ),
          ],
        ),
      );

  Widget _editableRow(
    IconData icon,
    String label,
    TextEditingController controller,
    TextInputType type,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF303846)),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: type,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: label,
                  isDense: true,
                  border: InputBorder.none,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF717783),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _infoRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF303846)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF717783),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Divider(height: 1, color: Color(0x4DC1C6D4)),
      );
}

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF717783)),
          ),
        ],
      );
}
