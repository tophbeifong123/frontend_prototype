import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_badge.dart';

class ItemDetailScreen extends StatelessWidget {
  final String itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Metric Details: $itemId'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundDark,
              AppColors.surfaceDark,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StatusBadge(
                        label: 'Active Monitored Parameter',
                        color: AppColors.primaryLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Detailed Telemetry ($itemId)',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'This screen demonstrates GoRouter dynamic path parameter handling and clean separation of detail screens.',
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Back to Dashboard',
                        icon: Icons.arrow_back_rounded,
                        onPressed: () => context.pop(),
                      ),
                    ],
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
