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
  static const _blue = Color(0xFF0C60A1);
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
      backgroundColor: const Color(0xFFEAF1F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF1F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Trainer Profile',
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
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: const Color(0xFFE0EFFB),
                      backgroundImage: _profilePhoto == null
                          ? null
                          : MemoryImage(_profilePhoto!),
                      child: _profilePhoto == null
                          ? Text(
                              _initials(_nameController.text),
                              style: const TextStyle(
                                color: _blue,
                                fontWeight: FontWeight.w900,
                                fontSize: 32,
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
                        elevation: 4,
                        child: IconButton(
                          tooltip: 'Choose profile photo',
                          onPressed: _choosePhoto,
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _choosePhoto,
                  icon: const Icon(Icons.upload_outlined, size: 18, color: _blue),
                  label: const Text(
                    'Upload photo',
                    style: TextStyle(
                      color: _blue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _section('Trainer Info', [
            _editableRow(
              Icons.badge_outlined,
              'Profile Name',
              _nameController,
              TextInputType.name,
            ),
            _divider(),
            _editableRow(
              Icons.mail_outline,
              'Email Address',
              _emailController,
              TextInputType.emailAddress,
            ),
            _divider(),
            _infoRow(
              Icons.calendar_today_outlined,
              'Member Since',
              'August 2026',
            ),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              onPressed: _saveProfile,
              icon: const Icon(Icons.check_rounded, color: Colors.white),
              label: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _section('Pokédex Activity', [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(value: '0', label: 'Favorites'),
                  _Stat(value: '151', label: 'Discovered'),
                  _Stat(value: 'Master', label: 'Rank'),
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
        content: Text('Profile changes saved successfully.'),
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

  Widget _editableRow(
    IconData icon,
    String label,
    TextEditingController controller,
    TextInputType type,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0C60A1), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: type,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A1C2C),
                ),
                decoration: InputDecoration(
                  labelText: label,
                  isDense: true,
                  border: InputBorder.none,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5A6E7F),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _infoRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0C60A1), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5A6E7F),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0A1C2C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Divider(height: 1, color: Color(0xFFE2E8F0)),
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
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0C60A1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5A6E7F),
            ),
          ),
        ],
      );
}
