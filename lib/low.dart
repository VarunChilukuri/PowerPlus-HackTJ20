import 'package:flutter/material.dart';
import 'package:battery/battery.dart';
import 'package:nice_button/nice_button.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battery Display',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BatteryLevelPage(),
      routes: <String, WidgetBuilder>{
        //'/': (BuildContext context) => new BatteryLevelPage(),
      },
    );
  }
}

class BatteryLevelPage extends StatefulWidget {
  @override
  _BatteryLevelPageState createState() => _BatteryLevelPageState();
}

class _BatteryLevelPageState extends State<BatteryLevelPage> {
  final Battery _battery = Battery();

  BatteryState _batteryState;
  int _batteryLevel;

  //@override
  void initState() {
    super.initState();

    _battery.batteryLevel.then((level) {
      this.setState(() {
        _batteryLevel = level;
        _batteryLevel = 32;
        //debugPrint(level.toString());
      });
    });

    _battery.onBatteryStateChanged.listen((BatteryState state) {
      _battery.batteryLevel.then((level) {
        this.setState(() {
          _batteryLevel = level;
          _batteryLevel = 32;
          _batteryState = state;
        });
      });
    });
  }

  Widget getBatteryAndText() {
    if (_batteryLevel >= 80) {
      return Text(
        "" + _batteryLevel.toString() + "%" + "\n" + "Action Needed",
        style: TextStyle(color: Colors.red, fontSize: 45.0),
      );
    }
    if (_batteryLevel < 40) {
      return Text(
        "" + _batteryLevel.toString() + "%" + "\n" + "Action Needed",
        style: TextStyle(color: Colors.red, fontSize: 45.0),
      );
    } else {
      return Text(
        "" + _batteryLevel.toString() + "%" + "\n" + "Optimal State",
        style: TextStyle(color: Colors.green, fontSize: 45.0),
      );
    }
  }

  Widget getButtonBorder() {
    if (_batteryLevel < 40 || _batteryLevel > 80) {
      return Container(
        padding: const EdgeInsets.all(7.0),
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(5.0)),
        child: getCheckOrX(),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(7.0),
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(5.0)),
        child: getCheckOrX(),
      );
    }
  }

  Widget getCheckOrX() {
    if (_batteryLevel < 40 || _batteryLevel > 80) {
      return Icon(
        Icons.battery_alert,
        color: Colors.red,
        //size: 24.0,
        //semanticLabel: 'Text to announce in accessibility modes',
      );
    } else {
      return Icon(
        Icons.check,
        color: Colors.green,
        //size: 24.0,
        //semanticLabel: 'Text to announce in accessibility modes',
      );
    }
  }

  Widget getTextWidget(int x) {
    if (x < 40) {
      return Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                  "Your current battery level is under 40%.\nTo preserve your battery lifespan, consistently maintain a battery level between 40-80%.\nTry to charge your device as soon as possible.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ))));
    }
    if (x > 80) {
      return Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                  "Your current battery level is above 80%.\n\nTo preserve your battery lifespan, consistently maintain a battery level between 40-80%.\n\nTry to stop charging your device as soon as possible.",
                  style: TextStyle(
                    //fontFamily: 'Poppins',
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ))));
    } else {
      return Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                  "Your current battery level is in the optimal range between 40-80%.",
                  style: TextStyle(
                    //fontFamily: 'Poppins',
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ))));
    }
  }

  @override
  Widget build(BuildContext context) {
    //final levelIndicator = Container();

    final coursePrice = getButtonBorder();

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 110.0),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.white),
        ),
        getBatteryAndText(),
        //SizedBox(height: 10.0),
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
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Expanded(flex: 1, child: levelIndicator),
            getTextWidget(_batteryLevel),
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
    final bottomContentText1 = Text(
      "Battery Lifespan:",
      style: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        //color: Color.fromRGBO(58, 86, 86, 1.0),
      ),
    );

    final bottomContentText2 = Text(
      "\nBattery lifespan represents the amount of time the battery lasts until it needs to be replaced. This is in contrast to battery life, which represents how long the battery can last before it needs to be charged again. \n\nHere are some general tips to preserve your battery lifespan: \n\n• Keep battery levels on your device between 40 and 80%.\n• Avoid plugging in your device and leaving it to charge for an extended period of time (overnight).\n• Minimize the use of off-brand or generic chargers. In the long run, this will prove to be more expensive as third-party chargers often damage the battery.\n• Avoid extreme temperatures, as they cause irreversible damage to your battery.\n• Charge your device to 50% before putting it away for long-term storage.",
      style: TextStyle(
        fontSize: 18.0,
        //color: Colors.purple,
        //color: Color.fromRGBO(58, 86, 86, 1.0),
      ),
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () => {},
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child:
          Text("TAKE THIS LESSON", style: TextStyle(color: Colors.white)),
        ));
    final bottomContent = Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText1,
            bottomContentText2, /*readButton*/
          ],
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

    final double batteryRight = 2 * size.width;
    final RRect batteryOutline = RRect.fromLTRBR(4.0, -8 * size.height,
        0.4 * batteryRight, -6 * size.height, Radius.circular(3.0));

    // Battery body
    canvas.drawRRect(
      batteryOutline,
      getPaint(),
    );

    // Battery nub
    canvas.drawRect(
      Rect.fromLTWH(0.4 * batteryRight, (-7 * size.height) - 5.0, 6.0,
          15.0), //LITTLE TAB ON THE RIGHT OF THE BATTERY
      getPaint(style: PaintingStyle.fill),
    );

    // Fill rect
    //canvas.clipRect(Rect.fromLTWH(0.0, 0.0, 1 * batteryRight * _batteryLevel / 100.0, -3 * size.height));

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

      /*
        RRect.fromLTRBR(4.0, -8 * size.height,
        0.4 * batteryRight, -6 * size.height, Radius.circular(3.0));
        */

        RRect.fromLTRBR(
            6.0,
            -8.15 * size.height + 5,
            -1 + 0.4 * batteryRight * _batteryLevel * 0.01,
            -6 * size.height - 3,
            Radius.circular(3.0)),
        getPaint(style: PaintingStyle.fill, color: indicatorColor));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _BatteryLevelPainter old = oldDelegate as _BatteryLevelPainter;
    return old._batteryLevel != _batteryLevel ||
        old._batteryState != _batteryState;
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // set the paint color to be white
    paint.color = Colors.white;

    // Create a rectangle with size and width same as the canvas
    var rect = Rect.fromLTWH(0, 0, size.width * 0.75, size.height * 0.5);

    // draw the rectangle using the paint
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
