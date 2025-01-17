import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class FolderWidget extends StatelessWidget {
  const FolderWidget({super.key, this.onTap, this.selected = false});

  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    final background = selected ? colors.primary : colors.inActiveContainer;
    final foreground = selected ? colors.onPrimary : colors.onInActiveContainer;

    return RawMaterialButton(
      onPressed: onTap,
      shape: const FolderWidgetBorder(),
      fillColor: background,
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      child: Container(
        height: 94,
        width: size.width,
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MText('Folders', style: textTheme.captionMedium, color: foreground),
            BlocBuilder<FoldersBloc, FoldersState>(
              builder: (context, state) => Skeletonizer(
                enabled: state is FoldersLoading,
                child: MText(
                  state.maybeWhen(
                    orElse: () => '0',
                    loaded: (folders) => folders.length.toString(),
                  ),
                  style: textTheme.heading2Medium,
                  color: foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FolderWidgetBorder extends OutlinedBorder {
  const FolderWidgetBorder({super.side});

  Path customBorderPath(Rect rect) {
    const r = 20.0;
    final path = Path();
    return path
      ..moveTo(0, rect.height - r)
      ..quadraticBezierTo(0, rect.height, r, rect.height)
      ..lineTo(rect.width - r, rect.height)
      ..quadraticBezierTo(rect.width, rect.height, rect.width, rect.height - r)
      ..lineTo(rect.width, 6 + r)
      ..quadraticBezierTo(rect.width, 6, rect.width - r, 6)
      ..lineTo((rect.width * 0.55) + 6, 6)
      ..lineTo((rect.width * 0.55) + 3, 3)
      ..quadraticBezierTo(rect.width * 0.55, 0, rect.width * 0.55 - r, 0)
      ..lineTo(r, 0)
      ..quadraticBezierTo(0, 0, 0, r)
      ..close();
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) =>
      FolderWidgetBorder(side: side ?? this.side);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return customBorderPath(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return customBorderPath(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawPath(
          customBorderPath(rect),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.transparent
            ..strokeWidth = 0.0,
        );
    }
  }

  @override
  ShapeBorder scale(double t) => FolderWidgetBorder(side: side.scale(t));
}
