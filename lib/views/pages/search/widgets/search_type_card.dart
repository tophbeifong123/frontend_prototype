import 'package:flutter/material.dart';
import '../../../../core/utils/pokemon_type_helper.dart';

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
    final typeInfo = PokemonTypeHelper.getTypeInfo(option.name);
    final color = typeInfo.color;

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
                child: Icon(typeInfo.icon, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                typeInfo.displayName,
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

String displayType(String type) => PokemonTypeHelper.getDisplayName(type);

Color typeColor(String type) => PokemonTypeHelper.getTypeColor(type);

IconData typeIcon(String type) => PokemonTypeHelper.getTypeIcon(type);
