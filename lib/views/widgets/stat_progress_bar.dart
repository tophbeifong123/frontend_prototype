import 'package:flutter/material.dart';

/// Reusable progress bar row for displaying Pokémon base stats with vibrant color highlights.
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

  Color _getStatColor(String statName) {
    final lower = statName.toLowerCase().trim();
    if (lower.contains('hp')) return const Color(0xFF10B981); // Emerald Green
    if (lower.contains('attack') && !lower.contains('special')) {
      return const Color(0xFFEF4444); // Vibrant Red
    }
    if (lower.contains('defense') && !lower.contains('special')) {
      return const Color(0xFF3B82F6); // Blue
    }
    if (lower.contains('special-attack') || lower.contains('sp. atk') || lower.contains('special attack')) {
      return const Color(0xFF8B5CF6); // Purple
    }
    if (lower.contains('special-defense') || lower.contains('sp. def') || lower.contains('special defense')) {
      return const Color(0xFFEC4899); // Pink
    }
    if (lower.contains('speed')) return const Color(0xFFF59E0B); // Amber

    return const Color(0xFF0C60A1);
  }

  String _formatStatLabel(String statName) {
    final lower = statName.toLowerCase().trim();
    if (lower == 'hp') return 'HP';
    if (lower == 'attack') return 'Attack';
    if (lower == 'defense') return 'Defense';
    if (lower.contains('special-attack') || lower == 'special attack') return 'Sp. Atk';
    if (lower.contains('special-defense') || lower == 'special defense') return 'Sp. Def';
    if (lower == 'speed') return 'Speed';
    return statName.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (value / maxStat).clamp(0.0, 1.0);
    final statColor = _getStatColor(label);
    final displayLabel = _formatStatLabel(label);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              displayLabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0A1C2C),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: statColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: statColor,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: statColor.withValues(alpha: 0.35),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 36,
            alignment: Alignment.centerRight,
            child: Text(
              '$value',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: statColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
