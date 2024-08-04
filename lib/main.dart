import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.center,
            child: Text(
              "Xylophone",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: const SafeArea(child: XylophoneLayout()),
      ),
    );
  }
}

/// This class is to set Xylophone Bar properties
/// Properties:
/// - color
/// - note name that each bar is expected to play
/// - how high /tall each bar should be, normally xylophone bar are in
///   descending order of height
///
/// These properties are directly set in constructor
class XylophoneBarProperties {
  final Color color;
  final String note;
  final double heightFactor;

  const XylophoneBarProperties(
      {required this.color, required this.note, required this.heightFactor});
}

/// This class is responsible to build Xylophone layout
///
/// Properties:
/// xylophoneConfig - this is a Map of Xylophone properties, defining position
///  and, bar properties namely, colour , note and height
///
/// members:
/// - _buildXylophone: member function to build tap-able/playable XylophoneBars
/// using xylophoneBarConfig
class XylophoneLayout extends StatelessWidget {
  final Map<int, XylophoneBarProperties> xylophoneConfig = const {
    1: XylophoneBarProperties(color: Colors.red, note: "A", heightFactor: 1.0),
    2: XylophoneBarProperties(
        color: Colors.orange, note: "B", heightFactor: 0.96),
    3: XylophoneBarProperties(
        color: Color(0xFFFFEB3B),
        note: "C",
        heightFactor: 0.92), //hex value for Colors.yellow.shade700
    4: XylophoneBarProperties(
        color: Colors.green, note: "D", heightFactor: 0.88),
    5: XylophoneBarProperties(
        color: Colors.teal, note: "E", heightFactor: 0.84),
    6: XylophoneBarProperties(
        color: Colors.blue, note: "F", heightFactor: 0.80),
    7: XylophoneBarProperties(
        color: Colors.purple, note: "G", heightFactor: 0.76),
  };

  const XylophoneLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _buildXylophone(),
    );
  }

  List<Widget> _buildXylophone() {
    final List<Widget> xylophoneBars = [];

    xylophoneConfig.forEach((key, value) {
      xylophoneBars.add(
        XylophoneBar(
          key: ValueKey(key),
          colorValue: value.color,
          note: value.note,
          heightFactor: value.heightFactor,
        ),
      );
    });
    return xylophoneBars;
  }
}

/// Xylophone Bar, which creates actual playable bars with notes
///
/// properties:
/// - colorValue: defines colour of the bar
/// - note: note that Bar plays
/// - heightFactor: how tall/high bar would be
///
/// members:
/// - playNote: this function initializes individual AudioPlayer for each key
/// and this is by design, so we can tap multiple keys
class XylophoneBar extends StatelessWidget {
  final Color colorValue;
  final String note;
  final double heightFactor;

  const XylophoneBar(
      {required this.colorValue,
      required this.note,
      required this.heightFactor,
      super.key});

  void playNote() async {
    final audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource("notes/$note.wav"));
    await audioPlayer.seek(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FractionallySizedBox(
        heightFactor: heightFactor,
        child: InkWell(
          splashColor: Colors.white.withOpacity(0.7),
          highlightColor: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          onTap: playNote,
          child: Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: colorValue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  note,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
