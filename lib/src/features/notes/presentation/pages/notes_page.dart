import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context);

    return MScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: MHeader(title: 'My Notes'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 120.h,
              width: 1.sw,
              padding: const EdgeInsets.fromLTRB(0, 24, 0, MCore.small).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 88.h,
                    padding: const EdgeInsets.all(MCore.large).r,
                    decoration: ShapeDecoration(
                      color: colorScheme?.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20).r,
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MText('Notes', style: MTextStyle.captionMedium),
                        MText('0', style: MTextStyle.heading2Medium),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 94.h,
                    width: 167.w,
                    child: CustomPaint(
                      painter: FolderPainter(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FolderPainter extends CustomPainter {
  FolderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 20.0;
    final Paint paint = Paint()
      ..color = Colors.red // Set your desired color
      ..style = PaintingStyle.fill;

    final Path path = Path();

    // Start at top-left corner
    path.moveTo(0, radius);

    // // Top-left corner (line)
    // path.lineTo(radius, size.height);

    // Top-right corner (quadratic curve)
    path.quadraticBezierTo(radius, 0, radius, 0);

    path.lineTo(size.width - radius, 0);

    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - radius);

    path.lineTo(size.width, size.height - radius);

    // // Bottom-right corner (line)
    // path.lineTo(size.width, size.height - radius);

    // Bottom-left corner (quadratic curve)
    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);

    // Top-left corner (line)
    path.lineTo(radius, size.height);

    // Back to the start with a quadratic curve
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    path.close(); // Complete the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
