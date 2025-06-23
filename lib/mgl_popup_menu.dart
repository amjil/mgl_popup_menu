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

  const MongolPopupMenuButton({
    super.key,
    required this.items,
    this.icon,
    this.onSelected,
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

    // Button's global offset relative to the Overlay
    final Offset buttonOffset = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Size buttonSize = button.size;
    final Size screenSize = overlay.size;

    // Calculate menu position, preferably below the button
    double left = buttonOffset.dx;
    double top = buttonOffset.dy + buttonSize.height;

    // Estimated menu width and height (can be dynamically calculated)
    const double menuWidth = 300;
    const double menuHeight = 250;

    // Adjust left position if menu overflows the right edge of the screen
    if (left + menuWidth > screenSize.width) {
      left = screenSize.width - menuWidth - 10; // 10 is margin
    }

    // Adjust top position if menu overflows the bottom edge of the screen, show above button
    if (top + menuHeight > screenSize.height) {
      top = buttonOffset.dy - menuHeight;
      if (top < 0) top = 10; // top margin
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

  const _PopupContent({
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(12),
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
                    color: theme.dividerColor,
                  );
                } else if (item.isGroupTitle) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: MongolText(
                        item.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
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
                    onHover: (hovering) {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: item.customWidget ?? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item.icon != null)
                            Icon(item.icon, size: 24),
                          const SizedBox(height: 4),
                          MongolText(
                            item.label,
                            style: theme.textTheme.bodySmall,
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
    );
  }
}
