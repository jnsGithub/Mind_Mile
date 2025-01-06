import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

class HornCircleWithImage extends StatefulWidget {
  final ui.Image? imagePath;
  HornCircleWithImage({required this.imagePath});
  @override
  _HornCircleWithImageState createState() => _HornCircleWithImageState();
}

class _HornCircleWithImageState extends State<HornCircleWithImage> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.imagePath;
    // loadImage(widget.imagePath);  // 이미지 경로를 여기에 입력하세요
  }

  Future<void> loadImage(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    final List<int> bytes = data.buffer.asUint8List();
    final Uint8List uint8List = Uint8List.fromList(bytes);

    ui.decodeImageFromList(uint8List, (ui.Image img) {
      setState(() {
        _image = img;  // 이미지를 로드한 후 상태 갱신
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(60, 65),
      painter: HornCirclePainter(image: _image),
    );
  }
}

class HornCirclePainter extends CustomPainter {
  final ui.Image? image;
  HornCirclePainter({this.image});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xff133C6B)
      ..style = PaintingStyle.fill;

    // 동그라미 그리기
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 17, paint);

    if (image != null) {
      double padding = 10.0;
      Rect rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2 + 2), radius: size.width / 2 - padding);
      canvas.drawImageRect(image!, Rect.fromLTWH(0, 0, image!.width.toDouble(), image!.height.toDouble()), rect, paint);
    }

    // 뿔 그리기
    Paint hornPaint = Paint()
      ..color = Color(0xff133C6B)
      ..style = PaintingStyle.fill;

    // 왼쪽 뿔
    Path leftHornPath = Path()
      ..moveTo(size.width / 2 - 50 / 3 + 3, size.height / 2 - 40 / 3 + 3)
      ..lineTo(size.width / 2 - 30 / 3 + 5, size.height / 2 - 60 / 3 + 5)
      ..lineTo(size.width / 2 - 60 / 3 + 5, size.height / 2 - 70 / 3 + 5)
      ..close();
    canvas.drawPath(leftHornPath, hornPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
