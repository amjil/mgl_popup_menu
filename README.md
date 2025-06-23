# MongolPopupMenuButton

A Flutter popup menu button component designed specifically for Mongolian vertical script support. This widget displays a horizontally scrollable popup menu with Mongolian vertical text, icons, menu grouping, animations, and theme adaptability.

## Features

* **Mongolian vertical text support:** Uses the `MongolText` widget for proper vertical script rendering.
* **Icon + text vertical layout:** Menu items display icons above Mongolian text.
* **Horizontal scrolling:** Supports horizontally scrollable menu when items overflow.
* **Animated popup:** Smooth fade and scale transition when showing/hiding the menu.
* **Menu grouping & dividers:** Support for group titles and vertical dividers.
* **Custom menu items:** Supports passing custom widgets as menu items.
* **Click outside to dismiss:** Popup closes when tapping outside the menu.
* **Keyboard navigation (optional):** Can be extended for keyboard navigation.
* **Dark mode support:** Uses theme colors to adapt to light and dark modes.
* **Performance optimizations:** Uses lazy building for menu items.

## Installation

Add this package to your Flutter project, and add the [mongol](https://pub.dev/packages/mongol) package as a dependency:

```yaml
dependencies:
  flutter:
    sdk: flutter
  mongol: ^0.2.0
```

Copy the `mongol_popup_menu_button.dart` file into your project and import it where needed.

## Usage

Example usage in a Flutter app:

```dart
MongolPopupMenuButton(
  items: [
    MongolMenuItem(
      icon: Icons.edit,
      label: 'ᠪᠢᠴᠢᠯᠭᠡ', // Edit
    ),
    MongolMenuItem.divider(),
    MongolMenuItem.groupTitle('ᠲᠣᠷᠢᠭᠤ'), // Group title
    MongolMenuItem(
      icon: Icons.copy,
      label: 'ᠬᠡᠴᠡᠯ', // Copy
    ),
    MongolMenuItem(
      icon: Icons.delete,
      label: 'ᠰᠠᠩᠬᠤ', // Delete
    ),
  ],
  onSelected: (item) {
    print('Selected menu item: ${item.label}');
  },
)
```

## API

### MongolPopupMenuButton

* `items` (List<MongolMenuItem>): List of menu items to display.
* `icon` (Widget?): Optional icon widget for the button.
* `onSelected` (Function(MongolMenuItem)?): Callback invoked when a menu item is selected.

### MongolMenuItem

* `icon` (IconData?): Optional icon displayed above the label.
* `label` (String): Mongolian vertical text label.
* `onSelected` (VoidCallback?): Optional per-item selection callback.
* `customWidget` (Widget?): Optional custom widget to replace default item layout.
* `isDivider` (bool): Marks the item as a vertical divider.
* `isGroupTitle` (bool): Marks the item as a group title.

## Customization

* Provide custom widgets via `customWidget` to fully customize menu items.
* Adjust popup menu width, height, and animation duration by modifying the source code.
* Extend keyboard navigation and focus handling as needed.

## License

MIT License