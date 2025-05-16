import 'package:meno_fe_v1/meno.dart';

class HorizontalPopupMenu extends StatefulWidget {
  const HorizontalPopupMenu({
    required this.items,
    required this.icon,
    super.key,
  });

  final List<Widget> items;
  final Widget icon;

  @override
  State<HorizontalPopupMenu> createState() => _HorizontalPopupMenuState();
}

class _HorizontalPopupMenuState extends State<HorizontalPopupMenu> {
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPopupMenu,
      child: widget.icon,
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _closePopupMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isMenuOpen = false;
  }

  void _showPopupMenu() {
    if (_isMenuOpen) {
      _closePopupMenu();
      return;
    }

    final button = context.findRenderObject()! as RenderBox;
    final overlay = Navigator.of(context, rootNavigator: true)
        .overlay!
        .context
        .findRenderObject()! as RenderBox;

    // Calculate the position for the popup
    final buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
    final popupTop = buttonPosition.dy - 160 - 8;
    final popupLeft =
        overlay.size.width - buttonPosition.dx - button.size.width - 16;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closePopupMenu,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            Positioned(
              top: popupTop,
              right: popupLeft,
              child: Material(
                elevation: 4,
                borderRadius: Corners.circle,
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.all(Insets.sm),
                  decoration: BoxDecoration(
                    color: MColorScheme.of(context).background,
                    borderRadius: Corners.circle,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: widget.items,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isMenuOpen = true;
  }
}
