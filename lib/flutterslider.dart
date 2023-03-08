library flutterslider;

import 'package:flutter/material.dart';



class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double height = 0;
  GlobalKey key = GlobalKey();
  Size size = Size.zero;
  Offset offset=Offset.zero;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Size size = getSizes(key);
      Offset offset = getPositions(key);

      setState(() {
        this.size = size;
        height - size.height;
        this.offset=offset;
      });
    });
  }

  getSizes(GlobalKey key) {
    final RenderBox? renderBoxRed =
        key.currentContext!.findRenderObject() as RenderBox;
    final sizeRed = renderBoxRed!.size;
    // print("SIZE: $sizeRed");
    return sizeRed;
  }

  getPositions(GlobalKey key) {
    final RenderBox? renderBoxRed =
        (key.currentContext!.findRenderObject() as RenderBox);
    final positionRed = renderBoxRed!.localToGlobal(Offset.zero);
    // print("POSITION: $positionRed ");
    return Offset(positionRed.dx, positionRed.dy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Expanded(
            child: CustomPaint(
              key: key,
              foregroundPainter: LinePainter(
                height,
                offset.dy == 0 ? 0 : offset.dy,
                onSelectedValue: (p0) {
                },
              ),
              child: GestureDetector(
                onVerticalDragUpdate: (value) {
                  setState(() {
                    if ((size.height - value.globalPosition.dy) < 0) {
                      height = (size.height - value.globalPosition.dy).abs();
                    }
                     
                  });
                },
              ),
            ),
          ),
        SizedBox(
          height: 10,
        ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  double height;
  double division = 10;
  double maxHeight;
  List<String> labeles;
  bool showLeftLabel = false;
  bool showPointer = false;
  bool showRightLabel = false;
  Function(int)? onSelectedValue;
  LinePainter(this.height, this.maxHeight,
      {this.division = 10,
      this.showPointer = true,
      this.labeles = const [],
      this.showLeftLabel = false,
      this.onSelectedValue,
      this.showRightLabel = false});

  @override
  void paint(Canvas canvas, Size size) {
    double separated = maxHeight / division;
    double currentPos = height;
    double maxPosition = maxHeight;
    double percentage = 0;
    int currentMarker = 0;
    if (maxHeight != 0) {
      percentage =(100 * currentPos / maxHeight);
      currentMarker = percentage.toInt() ~/ division;
    }
    Paint paint_0 = new Paint()
      ..color = Colors.blue.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    Path path_0 = Path();

    path_0.moveTo(size.width * 0.50, 0);
    path_0.lineTo(size.width * 0.50, maxHeight);

    Paint paint_1 = new Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    Path path_1 = Path();
    path_1.moveTo(size.width * 0.50, size.height);
    canvas.drawPath(path_0, paint_0);

    //can not go above max height
    // if (percentage > 0 && percentage < 101) {

    //   path_1.lineTo(size.width * 0.50, roundvalue.toDouble());
    // } else {
    //   if (percentage == 0) {
    //     path_1.lineTo(size.width * 0.50, maxHeight);
    //   }
    //   if (percentage >= 100) {
    //     var roundvalue = size.height - (currentMarker * separated).round();
    //     path_1.lineTo(size.width * 0.50, roundvalue);
    //   }
    // }
    if (percentage.toInt()==100) {
      path_1.lineTo(size.width * 0.50, maxHeight);
    canvas.drawPath(path_1, paint_1);

    } else if(percentage.toInt()>100) {
      path_1.lineTo(size.width * 0.50, maxHeight);
    canvas.drawPath(path_1, paint_1);
      
    }else{
var roundvalue = (separated*currentMarker).roundToDouble();
      path_1.lineTo(size.width * 0.50, roundvalue);
       canvas.drawPath(path_1, paint_1);

    }

    onSelectedValue?.call(percentage ~/ division); //

    for (int i = 0; i < division; i++) {
      if (showPointer) {
        var paint = Paint();
        paint.color = Colors.blue;
        canvas.drawCircle(Offset(size.width * 0.50, separated * i), 2, paint);
      }
      if (showLeftLabel) {
        TextSpan leftText = TextSpan(text: "index ${i + 1}");
        TextPainter leftPainter =
            TextPainter(text: leftText, textDirection: TextDirection.ltr);
        leftPainter.layout();
        leftPainter.paint(
            canvas, Offset(size.width * 0.42, (separated * i) - 10));
      }
      if (showRightLabel) {
        TextSpan rightText = TextSpan(text: "index ${i + 1}");
        TextPainter rightPainter =
            TextPainter(text: rightText, textDirection: TextDirection.ltr);
        rightPainter.layout();
        rightPainter.paint(
            canvas, Offset(size.width * 0.52, (separated * i) - 10));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
