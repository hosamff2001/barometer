import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_barometer/flutter_barometer.dart';

class Screen extends StatefulWidget {
  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  double bottomPressure = 0.0;
  double surfacePressure = 0.0;

  Future<void> MeasureSurfacePressure() async {
    await for (final event in flutterBarometerEvents) {
      if (event.pressure != null) {
        setState(() {
          surfacePressure = event.pressure;
        });
        break;
      }
    }
  }

  Future<void> MeasureBottomPressure() async {
    await for (final event in flutterBarometerEvents) {
      if (event.pressure != null) {
        setState(() {
          bottomPressure = event.pressure;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barometer Example'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Color.fromARGB(255, 47, 129, 224))),
                    onPressed: MeasureSurfacePressure,
                    child: const Text(
                      'Measure Surface Pressure',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Icon(
                  Icons.home,
                  size: 140,
                ),
                SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Color.fromARGB(255, 47, 129, 224))),
                    onPressed: MeasureBottomPressure,
                    child: const Text(
                      'Measure Bottom Pressure',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            VerticalDivider(
              thickness: 4,
              color: Colors.black,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Color.fromARGB(255, 47, 129, 224))),
                    onPressed: () => _calculateHeight(context),
                    child: const Text(
                      'Calculate Building Height',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                surfacePressure != 0.0
                    ? Text(
                        'Surface pressure: \n ${surfacePressure.toStringAsFixed(10)}')
                    : const Text('Surface pressure: \n 0'),
                bottomPressure != 0.0
                    ? Text(
                        'Bottom pressure: \n ${bottomPressure.toStringAsFixed(10)}')
                    : const Text('Bottom pressure: \n 0'),
                SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Color.fromARGB(255, 47, 129, 224))),
                    onPressed: _comparePress,
                    child: const Text(
                      'Compare Bottom Pressure',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _calculateHeight(context) {
    print('Max Pressure : ${surfacePressure.toString()}');
    print('Bottom Pressure: ${bottomPressure.toString()}');
    double PressDifference = (surfacePressure - bottomPressure)
        .abs(); // access _bottomPressure through the class

    final double height =
        (PressDifference / 1013.25) * 8500; // assume 1hPa = 1m height
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(
          'Building height is \n ${height.toStringAsFixed(4)} meters',
          style: TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _comparePress() {
    const double fciPress = 1008.5; // replace with actual value

    String message;
    message = bottomPressure > fciPress
        ? 'FCAI building has lower Pressure'
        : bottomPressure < fciPress
            ? 'FCAI building has higher Pressure'
            : 'Both buildings have the same Pressure';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
