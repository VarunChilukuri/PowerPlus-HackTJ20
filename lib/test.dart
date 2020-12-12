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
