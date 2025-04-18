import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String currentModule;
  final List<DrawerItem> items;
  final Function(String) onItemSelected;

  const AppDrawer({
    super.key,
    required this.currentModule,
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Center(
              child: Text(
                currentModule,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildDrawerItem(context, item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, DrawerItem item) {
    final isSelected = item.id == currentModule;
    return ExpansionTile(
      leading: Icon(
        item.icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      initiallyExpanded: isSelected,
      children: item.subItems.map((subItem) {
        return ListTile(
          leading: const SizedBox(width: 24),
          title: Text(subItem.title),
          selected: subItem.id == currentModule,
          onTap: () => onItemSelected(subItem.id),
        );
      }).toList(),
    );
  }
}

class DrawerItem {
  final String id;
  final String title;
  final IconData icon;
  final List<DrawerSubItem> subItems;

  const DrawerItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.subItems,
  });
}

class DrawerSubItem {
  final String id;
  final String title;

  const DrawerSubItem({
    required this.id,
    required this.title,
  });
}
