import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Configuration'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GlassCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.palette_outlined, color: AppColors.primaryLight),
                      title: const Text('Theme Mode', style: TextStyle(color: Colors.white)),
                      subtitle: const Text('System Dark Theme', style: TextStyle(color: AppColors.textSecondaryDark)),
                      trailing: Switch(
                        value: true,
                        onChanged: (val) {},
                        activeColor: AppColors.primary,
                      ),
                    ),
                    const Divider(color: AppColors.borderDark),
                    ListTile(
                      leading: const Icon(Icons.notifications_none_outlined, color: AppColors.secondary),
                      title: const Text('Notifications', style: TextStyle(color: Colors.white)),
                      subtitle: const Text('Real-time alerts', style: TextStyle(color: AppColors.textSecondaryDark)),
                      trailing: Switch(
                        value: true,
                        onChanged: (val) {},
                        activeColor: AppColors.secondary,
                      ),
                    ),
                    const Divider(color: AppColors.borderDark),
                    const ListTile(
                      leading: Icon(Icons.info_outline, color: AppColors.accent),
                      title: Text('Architecture Spec', style: TextStyle(color: Colors.white)),
                      subtitle: Text('Clean Feature-First + Riverpod + GoRouter', style: TextStyle(color: AppColors.textSecondaryDark)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
