import 'package:flutter/material.dart';
import 'package:islamic_app/features/quran/data/models/verse.dart';

/// Overlay popup menu that appears when a user taps on a Quran verse.
///
/// Shows options: التفسير، الترجمة، الاستماع، المفضلة، النشر.
/// Automatically positions itself above or below the tap point.
class VersePopupMenu {
  OverlayEntry? _overlayEntry;

  /// Whether a popup is currently showing.
  bool get isShowing => _overlayEntry != null;

  /// Dismiss the current popup if any.
  void dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Show the popup menu near [tapPosition] for the given [verse].
  ///
  /// [onDismiss] is called when the popup is dismissed (tap outside or action).
  /// [onAction] is called with the action name when an item is tapped.
  void show({
    required BuildContext context,
    required Offset tapPosition,
    required Verse verse,
    required VoidCallback onDismiss,
    required void Function(VerseAction action, Verse verse) onAction,
  }) {
    dismiss();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const double popupWidth = 220.0;
    const double popupHeight = 275.0;

    double left = tapPosition.dx - (popupWidth / 2);
    left = left.clamp(20.0, screenWidth - popupWidth - 20.0);

    final bool showAbove = tapPosition.dy > (screenHeight / 2);
    final double top = showAbove
        ? tapPosition.dy - popupHeight - 15
        : tapPosition.dy + 15;

    _overlayEntry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            // Dismiss on tap outside
            GestureDetector(
              onTap: () {
                dismiss();
                onDismiss();
              },
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),
            // Popup card
            Positioned(
              top: top,
              left: left,
              child: Material(
                color: Colors.transparent,
                child: _VersePopupCard(
                  verse: verse,
                  onAction: (action) {
                    dismiss();
                    onDismiss();
                    onAction(action, verse);
                  },
                ),
              ),
            ),
            // Arrow indicator
            Positioned(
              top: showAbove ? top + popupHeight - 8 : top - 8,
              left: tapPosition.dx - 8,
              child: _PopupArrow(showAbove: showAbove),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
}

/// Available actions in the verse popup menu.
enum VerseAction {
  tafseer,
  translation,
  listen,
  bookmark,
  lastRead,
  share,
}

/// The popup card content with menu items.
class _VersePopupCard extends StatelessWidget {
  final Verse verse;
  final void Function(VerseAction action) onAction;

  const _VersePopupCard({
    required this.verse,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 275,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFBF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD2B48C), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PopupMenuItem(
            title: "التفسير",
            icon: Icons.menu_book_rounded,
            onTap: () => onAction(VerseAction.tafseer),
          ),
          const _PopupDivider(),
          _PopupMenuItem(
            title: "الترجمة",
            icon: Icons.g_translate_rounded,
            onTap: () => onAction(VerseAction.translation),
          ),
          const _PopupDivider(),
          _PopupMenuItem(
            title: "الإستماع للآيات",
            icon: Icons.play_circle_outline_rounded,
            onTap: () => onAction(VerseAction.listen),
          ),
          const _PopupDivider(),
          _PopupMenuItem(
            title: "أضف للمفضلة",
            icon: Icons.bookmark_border_rounded,
            onTap: () => onAction(VerseAction.bookmark),
          ),
          const _PopupDivider(),
          _PopupMenuItem(
            title: "حفظ علامة القراءة",
            icon: Icons.bookmark_added_rounded,
            onTap: () => onAction(VerseAction.lastRead),
          ),
          const _PopupDivider(),
          _PopupMenuItem(
            title: "نشر",
            icon: Icons.share_rounded,
            onTap: () => onAction(VerseAction.share),
          ),
        ],
      ),
    );
  }
}

/// Single menu item row inside the popup.
class _PopupMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _PopupMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723),
              ),
            ),
            Icon(icon, color: const Color(0xFF8B4513), size: 18),
          ],
        ),
      ),
    );
  }
}

/// Thin divider used between popup menu items.
class _PopupDivider extends StatelessWidget {
  const _PopupDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: Color(0xFFE5D5C5), thickness: 0.8);
  }
}

/// Arrow triangle pointing to the tapped verse.
class _PopupArrow extends StatelessWidget {
  final bool showAbove;

  const _PopupArrow({required this.showAbove});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 3.14159 / 4,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: const Color(0xFFFDFBF7),
          border: Border(
            top: BorderSide(
              color: const Color(0xFFD2B48C),
              width: showAbove ? 0 : 1.5,
            ),
            left: BorderSide(
              color: const Color(0xFFD2B48C),
              width: showAbove ? 0 : 1.5,
            ),
            bottom: BorderSide(
              color: const Color(0xFFD2B48C),
              width: showAbove ? 1.5 : 0,
            ),
            right: BorderSide(
              color: const Color(0xFFD2B48C),
              width: showAbove ? 1.5 : 0,
            ),
          ),
        ),
      ),
    );
  }
}
