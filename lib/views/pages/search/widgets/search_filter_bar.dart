import 'package:flutter/material.dart';
import 'search_type_card.dart';

class TypeFilterBar extends StatelessWidget {
  const TypeFilterBar({
    super.key,
    required this.selectedTypes,
    required this.onRemove,
    required this.onToggle,
  });

  final List<String> selectedTypes;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...selectedTypes.map(
              (type) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SelectedTypeChip(
                  type: type,
                  onRemove: () => onRemove(type),
                ),
              ),
            ),
            AddTypeMenu(selectedTypes: selectedTypes, onToggle: onToggle),
          ],
        ),
      );
}

class AddTypeMenu extends StatefulWidget {
  const AddTypeMenu({
    super.key,
    required this.selectedTypes,
    required this.onToggle,
  });

  final List<String> selectedTypes;
  final ValueChanged<String> onToggle;

  @override
  State<AddTypeMenu> createState() => _AddTypeMenuState();
}

class _AddTypeMenuState extends State<AddTypeMenu> {
  final _menuController = MenuController();

  @override
  Widget build(BuildContext context) => MenuAnchor(
        controller: _menuController,
        menuChildren: [
          SizedBox(
            width: 200,
            height: 276,
            child: ListView.builder(
              primary: false,
              padding: EdgeInsets.zero,
              itemCount: typeOptions.length,
              itemBuilder: (context, index) {
                final option = typeOptions[index];
                final selected = widget.selectedTypes.contains(option.name);
                final color = typeColor(option.name);
                return InkWell(
                  key: ValueKey('add-type-${option.name}'),
                  onTap: () {
                    widget.onToggle(option.name);
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    child: Row(
                      children: [
                        Icon(typeIcon(option.name), color: color, size: 19),
                        const SizedBox(width: 12),
                        Expanded(child: Text(displayType(option.name))),
                        Icon(
                          selected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        builder: (context, controller, child) => OutlinedButton.icon(
          key: const ValueKey('add-type-filter'),
          onPressed: () =>
              controller.isOpen ? controller.close() : controller.open(),
          icon: const Icon(Icons.add_circle_outline, size: 18),
          label: const Text('Add'),
        ),
      );
}

class SelectedTypeChip extends StatelessWidget {
  const SelectedTypeChip({
    super.key,
    required this.type,
    required this.onRemove,
  });

  final String type;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final color = typeColor(type);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 12),
          Icon(typeIcon(type), size: 17, color: Colors.white),
          const SizedBox(width: 7),
          Text(
            displayType(type),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            key: ValueKey('remove-type-$type'),
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 17),
            color: Colors.white,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
