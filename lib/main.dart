import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SliderWidget(),
    );
  }
}

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double height = 0;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   setState(() {
    //     height = MediaQuery.of(context).size.height / 2;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        child: CustomPaint(
          size: Size(
             90,
              MediaQuery.of(context).size.height ), //You can Replace this with your desired WIDTH and HEIGHT

          foregroundPainter: LinePainter(
            height,
            MediaQuery.of(context).size.height-10,
            onSelectedValue: (p0) {},
          ),
          child: GestureDetector(
            onVerticalDragUpdate: (value) {
              setState(() {
                height = (MediaQuery.of(context).size.height-10) -
                    value.globalPosition.dy;
              });
            },
          ),
        ),
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
    double separated = size.height / division;
    double currentPos = size.height - height;
    double maxPosition = size.height - maxHeight;
    double percentage = 0;
    percentage = 100 - (100 * currentPos / maxHeight);
    int currentMarker = percentage.toInt() ~/ division;
    Paint paint_0 = new Paint()
      ..color = Colors.blue.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    Path path_0 = Path();

    path_0.moveTo(size.width * 0.50, 0);
    path_0.lineTo(size.width * 0.50, size.height);

    Paint paint_1 = new Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    Path path_1 = Path();
    path_1.moveTo(size.width * 0.50, size.height);
    canvas.drawPath(path_0, paint_0);

    //can not go above max height
    if (percentage > 0 && percentage < 101) {
      var roundvalue= size.height - (currentMarker * separated).round(); 
      
      path_1.lineTo(size.width * 0.50, roundvalue.toDouble());
    } else {
      if (percentage == 0) {
        path_1.lineTo(size.width * 0.50, maxHeight);
      }
      if (percentage >= 100) {
        
      var roundvalue= size.height - (currentMarker * separated).round();
        path_1.lineTo(size.width * 0.50, roundvalue);
      }
    }
    onSelectedValue?.call(currentMarker); //
    canvas.drawPath(path_1, paint_1);

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
