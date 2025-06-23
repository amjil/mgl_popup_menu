import 'package:flutter/material.dart';
import 'package:mongol/mongol.dart';

class MongolMenuItem {
  final IconData? icon;
  final String label;
  final VoidCallback? onSelected;
  final Widget? customWidget;
  final bool isDivider;
  final bool isGroupTitle;

  const MongolMenuItem({
    this.icon,
    required this.label,
    this.onSelected,
    this.customWidget,
    this.isDivider = false,
    this.isGroupTitle = false,
  });

  static MongolMenuItem divider() => const MongolMenuItem(label: '', isDivider: true);

  static MongolMenuItem groupTitle(String label) => MongolMenuItem(label: label, isGroupTitle: true);
}

class MongolPopupMenuButton extends StatelessWidget {
  final List<MongolMenuItem> items;
  final Widget? icon;
  final void Function(MongolMenuItem)? onSelected;
  final Color? menuBackgroundColor;
  final double menuBorderRadius;
  final List<BoxShadow>? menuBoxShadow;
  final Color? dividerColor;
  final EdgeInsetsGeometry menuItemPadding;
  final double iconSize;

  const MongolPopupMenuButton({
    super.key,
    required this.items,
    this.icon,
    this.onSelected,
    this.menuBackgroundColor,
    this.menuBorderRadius = 12,
    this.menuBoxShadow,
    this.dividerColor,
    this.menuItemPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ?? const Icon(Icons.more_vert),
      onPressed: () => _showMenu(context),
    );
  }

  void _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
    final Offset buttonOffset = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Size buttonSize = button.size;
    final Size screenSize = overlay.size;

    // Preferred position: below the button
    double left = buttonOffset.dx;
    double top = buttonOffset.dy + buttonSize.height;

    // Estimated menu size
    const double menuWidth = 300;
    const double menuHeight = 250;

    // Adjust horizontal position if menu overflows right edge
    if (left + menuWidth > screenSize.width) {
      left = screenSize.width - menuWidth - 10; // 10px margin
      if (left < 10) left = 10; // prevent overflow left
    }

    // Adjust vertical position if menu overflows bottom edge
    if (top + menuHeight > screenSize.height) {
      top = buttonOffset.dy - menuHeight;
      if (top < 10) top = 10; // top margin
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              width: menuWidth,
              height: menuHeight,
              child: _PopupContent(
                items: items,
                onItemSelected: (item) {
                  item.onSelected?.call();
                  onSelected?.call(item);
                },
                backgroundColor: menuBackgroundColor,
                borderRadius: menuBorderRadius,
                boxShadow: menuBoxShadow,
                dividerColor: dividerColor,
                menuItemPadding: menuItemPadding,
                iconSize: iconSize,
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );
  }
}

class _PopupContent extends StatelessWidget {
  final List<MongolMenuItem> items;
  final void Function(MongolMenuItem item) onItemSelected;
  final Color? backgroundColor;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? dividerColor;
  final EdgeInsetsGeometry menuItemPadding;
  final double iconSize;

  const _PopupContent({
    required this.items,
    required this.onItemSelected,
    this.backgroundColor,
    this.borderRadius = 12,
    this.boxShadow,
    this.dividerColor,
    this.menuItemPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = backgroundColor ?? (isDark ? Colors.grey[900] : Colors.white);
    final divColor = dividerColor ?? (isDark ? Colors.grey[700] : Colors.grey[300]);
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final groupTitleColor = isDark ? Colors.white54 : Colors.black54;
    final iconColor = isDark ? Colors.white70 : Colors.black54;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(borderRadius),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: boxShadow,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300, minWidth: 80),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items.map((item) {
                  if (item.isDivider) {
                    return VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: divColor,
                    );
                  } else if (item.isGroupTitle) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: MongolText(
                          item.label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: groupTitleColor,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        onItemSelected(item);
                      },
                      child: Container(
                        padding: menuItemPadding,
                        child: item.customWidget ??
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (item.icon != null)
                                  Icon(item.icon, size: iconSize, color: iconColor),
                                const SizedBox(height: 4),
                                MongolText(
                                  item.label,
                                  style: TextStyle(color: textColor),
                                ),
                              ],
                            ),
                      ),
                    );
                  }
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
