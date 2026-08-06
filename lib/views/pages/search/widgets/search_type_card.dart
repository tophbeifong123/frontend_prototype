import 'package:flutter/material.dart';

class TypeSearchOption {
  const TypeSearchOption(this.name, this.count);
  final String name;
  final int count;
}

const typeOptions = [
  TypeSearchOption('fire', 72),
  TypeSearchOption('water', 133),
  TypeSearchOption('electric', 54),
  TypeSearchOption('grass', 102),
  TypeSearchOption('psychic', 82),
  TypeSearchOption('ghost', 46),
  TypeSearchOption('ice', 38),
  TypeSearchOption('dragon', 50),
  TypeSearchOption('steel', 60),
  TypeSearchOption('normal', 125),
  TypeSearchOption('fighting', 78),
  TypeSearchOption('poison', 92),
  TypeSearchOption('ground', 78),
  TypeSearchOption('flying', 105),
  TypeSearchOption('bug', 86),
  TypeSearchOption('rock', 75),
  TypeSearchOption('dark', 55),
  TypeSearchOption('fairy', 70),
];

class TypeSearchCard extends StatelessWidget {
  const TypeSearchCard({
    super.key,
    required this.option,
    required this.onTap,
  });

  final TypeSearchOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = typeColor(option.name);
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('type-${option.name}'),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color,
                child: Icon(typeIcon(option.name), color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                displayType(option.name),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(
                '${option.count} Pokémon',
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String displayType(String type) => type[0].toUpperCase() + type.substring(1);

Color typeColor(String type) => switch (type) {
  'fire' => const Color(0xffef5350),
  'water' => const Color(0xff42a5f5),
  'grass' => const Color(0xff66bb6a),
  'electric' => const Color(0xffffca28),
  'psychic' => const Color(0xffec407a),
  'ice' => const Color(0xff26c6da),
  'dragon' => const Color(0xff5c6bc0),
  'ghost' => const Color(0xff7e57c2),
  'steel' => const Color(0xff78909c),
  _ => const Color(0xff8d99a6),
};

IconData typeIcon(String type) => switch (type) {
  'fire' => Icons.local_fire_department,
  'water' => Icons.water_drop,
  'grass' => Icons.eco,
  'electric' => Icons.bolt,
  'psychic' => Icons.visibility,
  'ice' => Icons.ac_unit,
  'ghost' => Icons.nightlight_round,
  'dragon' => Icons.pets,
  'flying' => Icons.air,
  _ => Icons.category,
};
