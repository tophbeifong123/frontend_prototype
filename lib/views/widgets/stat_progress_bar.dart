import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Reusable progress bar row for displaying Pokémon base stats.
class StatProgressBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxStat;

  const StatProgressBar({
    super.key,
    required this.label,
    required this.value,
    this.maxStat = 255,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (value / maxStat).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: ShadTheme.of(context).colorScheme.muted,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ShadTheme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
