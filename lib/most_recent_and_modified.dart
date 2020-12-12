import 'package:battery_saver_final/model/lesson.dart';
import 'package:flutter/material.dart';
import 'package:battery_saver_final/detail_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:battery/battery.dart';
import 'package:nice_button/nice_button.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0), fontFamily: 'Poppins'),
      home: new DetailPage(),
      // home: DetailPage(),
    );
  }
}


class DetailPage extends StatefulWidget {
  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  final Battery _battery = Battery();

  BatteryState _batteryState;
  int _batteryLevel;

  //@override
  void initState() {
    super.initState();

    _battery.batteryLevel.then((level) {
      this.setState(() {
        _batteryLevel = level;
        debugPrint(level.toString());
        debugPrint(_batteryLevel.toString());
        //debugPrint(level.toString());
      });
    });

    _battery.onBatteryStateChanged.listen((BatteryState state) {
      _battery.batteryLevel.then((level) {
        this.setState(() {
          _batteryLevel = level;
          _batteryState = state;
        });
      });
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: 23.0,
            //value: lesson.indicatorValue,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final coursePrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "\$20",
        //"\$" + lesson.price.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 25.0,
          width: 100.0,
          child: CustomPaint(
            painter: _BatteryLevelPainter(_batteryLevel, _batteryState),
            child: _batteryState == BatteryState.charging
                ? Icon(Icons.flash_on)
                : Container(),
          ),
        ),
        Container(
          width: 90.0,
          child: new Divider(
            color: Colors.green,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          _batteryLevel.toString() + "%",
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: levelIndicator),
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "REPLACE",
                      style: TextStyle(color: Colors.white),
                    ))),
            Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/lightning_bw.png"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
      ],
    );

    final bottomContentText = Text(
      "Tips",
      style: TextStyle(fontSize: 18.0),
    );
    final readButton = GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) =>
            _onHorizontalDrag(details),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 60.0),
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              onPressed: () => {},
              color: Color.fromRGBO(58, 66, 86, 1.0),
              child: Text("TAKE THIS LESSON",
                  style: TextStyle(color: Colors.white)),
            )));
    final bottomContent = Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText, readButton],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }
}
Widget _onHorizontalDrag(DragEndDetails details) {
  if(details.primaryVelocity == 0) return Text("Bro what is this in between"); // user have just tapped on screen (no dragging)

  if (details.primaryVelocity.compareTo(0) == -1) {
    return Text(
      "Right Screen",
      style: TextStyle(fontSize: 18.0),
    );
  }
  else
  {
    return Text(
      "Left Screen",
      style: TextStyle(fontSize: 18.0),
    );
  }
}


class _BatteryLevelPainter extends CustomPainter {
  final int _batteryLevel;
  final BatteryState _batteryState;

  _BatteryLevelPainter(this._batteryLevel, this._batteryState);

  @override
  void paint(Canvas canvas, Size size) {
    Paint getPaint(
        {Color color = Colors.black,
          PaintingStyle style = PaintingStyle.stroke}) {
      return Paint()
        ..color = color
        ..strokeWidth = 3.0
        ..style = style;
    }

    final double batteryRight = size.width;
    //MAIN RECTANGLE
    debugPrint(size.height.toString()); //25
    debugPrint(size.width.toString()); //100

    final RRect batteryOutline = RRect.fromLTRBR(
        0.47 * size.width,
        /*batteryRight,*/ size.height * 1.5,
        1.20 * size.width,
        2.5 * size.height,
        Radius.circular(3.0));
    // Battery body
    canvas.drawRRect(
      batteryOutline,
      getPaint(),
    );

    // Battery nub
    canvas.drawRect(
      Rect.fromLTWH(
          1.20 * batteryRight,
          (2 * size.height - 5.0),
          0.04 * size.width,
          0.4 * size.height), //LITTLE TAB ON THE RIGHT OF THE BATTERY
      getPaint(style: PaintingStyle.fill),
    );

    // Fill rect
    //canvas.clipRect(Rect.fromLTWH(0.47 * size.width, size.height * 1.5, 0.47 * size.width + 1 * batteryRight * _batteryLevel / 100.0, -3 * size.height));
    //canvas.clipRect();

    Color indicatorColor;
    if (_batteryLevel < 40) {
      indicatorColor = Colors.red;
    } else if (_batteryLevel > 80) {
      indicatorColor = Colors.red;
    } else {
      indicatorColor = Colors.green;
    }

    canvas.drawRRect(
      //RRect.fromLTRBR(0.5, 0.5, 1 * batteryRight - 0.5, -3 * size.height , Radius.circular(3.0)),
      //RRect.fromLTRBR(-0.25 * batteryRight, 0.5, 0.75 * batteryRight, -3 * size.height , Radius.circular(3.0)),

        RRect.fromLTRBR(
            0.47 * size.width + 1,
            (size.height * 1.5) - 1,
            0.47 * size.width + size.width * 0.62,
            2.5 * size.height - 1,
            Radius.circular(3.0)),

        //0, 0, 50, 50),

        /*
            -0.25 * batteryRight + 1,
            -1,
            -0.25 * batteryRight + batteryRight * _batteryLevel * 0.01,
            -3 * size.height + 1,
            Radius.circular(3.0)),
            */
        getPaint(style: PaintingStyle.fill, color: indicatorColor));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _BatteryLevelPainter old = oldDelegate as _BatteryLevelPainter;
    return old._batteryLevel != _batteryLevel ||
        old._batteryState != _batteryState;
  }
}
