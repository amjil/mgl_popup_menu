import 'package:flutter/material.dart';
import 'package:mongol/mongol.dart' hide MongolPopupMenuButton; // Make sure to add mongol package dependency
import 'package:mgl_popup_menu/mgl_popup_menu.dart'; // Import your component file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mongolian Popup Menu Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  // Handle menu item selection event
  void _onMenuSelected(MongolMenuItem item) {
    debugPrint('Selected menu item: ${item.label}');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mongolian Popup Menu'),
        actions: [
          MongolPopupMenuButton(
            items: [
              MongolMenuItem(
                icon: Icons.edit,
                label: 'ᠪᠢᠴᠢᠯᠭᠡ', // Edit
              ),
              MongolMenuItem.divider(),
              MongolMenuItem.groupTitle('ᠲᠣᠷᠢᠭᠤ'), // Group title - Options
              MongolMenuItem(
                icon: Icons.copy,
                label: 'ᠬᠡᠴᠡᠯ', // Copy
              ),
              MongolMenuItem(
                icon: Icons.delete,
                label: 'ᠰᠠᠩᠬᠤ', // Delete
              ),
            ],
            onSelected: _onMenuSelected,
          ),
        ],
      ),
      body: Center(
        child: MongolText(
          'ᠮᠣᠩᠭᠣᠯ ᠳᠡᠭᠡᠷ', // Mongolian text example
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
