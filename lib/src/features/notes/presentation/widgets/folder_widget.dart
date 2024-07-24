import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class FolderWidget extends StatelessWidget {
  const FolderWidget({
    super.key,
    this.value,
    this.valueStyle,
    this.title,
    this.titleStyle,
    this.onTap,
    this.selected = false,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
  });

  final String? value;
  final TextStyle? valueStyle;
  final String? title;
  final TextStyle? titleStyle;
  final VoidCallback? onTap;
  final bool selected;
  final MColor? backgroundColor;
  final MColor? foregroundColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colors = MColorScheme.of(context)!;

    final background = selected ? colors.primary : colors.inActiveContainer;
    final foreground = selected ? colors.onPrimary : colors.onInActiveContainer;

    return RawMaterialButton(
      onPressed: onTap,
      shape: const _FolderBorder(),
      fillColor: backgroundColor ?? background,
      elevation: 0.0,
      hoverElevation: 0.0,
      focusElevation: 0.0,
      highlightElevation: 0.0,
      child: Container(
        height: height ?? 94.toScale,
        width: size.width,
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 16).radius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MText(
              title ?? 'Folders',
              style: titleStyle ?? $styles.text.captionMedium,
              color: foregroundColor ?? foreground,
            ),
            if (value != null)
              MText(
                value!,
                style: valueStyle ?? $styles.text.heading2Medium,
                color: foregroundColor ?? foreground,
              )
            else
              BlocBuilder<FolderListBloc, FolderListState>(
                builder: (context, state) => MText(
                  state.maybeWhen(
                    orElse: () => '0',
                    success: (folders) => folders.length.toString(),
                  ),
                  style: valueStyle ?? $styles.text.heading2Medium,
                  color: foreground,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FolderBorder extends OutlinedBorder {
  const _FolderBorder({super.side});

  Path customBorderPath(Rect rect) {
    final double r = 20.0.toScale;

    final Path path = Path();

    // Bottom left
    path.moveTo(0, rect.height - r);
    path.quadraticBezierTo(0, rect.height, r, rect.height);

    // Bottom right
    path.lineTo(rect.width - r, rect.height);
    path.quadraticBezierTo(
        rect.width, rect.height, rect.width, rect.height - r);

    // Top right (notch)
    path.lineTo(rect.width, 6 + r);
    path.quadraticBezierTo(rect.width, 6, rect.width - r, 6);
    path.lineTo((rect.width * 0.55) + 6, 6);
    path.lineTo((rect.width * 0.55) + 3, 3);
    path.quadraticBezierTo(rect.width * 0.55, 0, rect.width * 0.55 - r, 0);
    path.lineTo(r, 0);
    path.quadraticBezierTo(0, 0, 0, r);
    path.close();
    return path;
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) =>
      _FolderBorder(side: side ?? this.side);

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
  ShapeBorder scale(double t) => _FolderBorder(side: side.scale(t));
}
