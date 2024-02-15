import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:undo/undo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  final UndoHistoryController _undoController = UndoHistoryController();

  bool _isDropped = false;

  static Color value = Colors.black;
  final List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.pink,
    Colors.purple,
    Colors.brown
  ];

  var changes = new ChangeStack();

  static String userPost = ' ';
  var _Fonts = ['Fonts', 'Honk-Regular', 'ProtestRevolution', 'ProtestStrike'];
  var _Size = [
    '10',
    '12',
    '4',
    '16',
    '20',
    '22',
    '24',
    '26',
    '28',
    '30',
    '32',
    '34'
  ];

  double _xPosition = 0;
  double _yPosition = 0;

  static String _currentItemSelected = 'Fonts';
  static String _currentSize = '10';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  FloatingActionButton(
                    heroTag: "Undo",
                    onPressed: () {
                      _undoController.undo();
                    },
                    child: const Icon(
                      Icons.undo_sharp,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.grey[800],
                    shape: CircleBorder(eccentricity: 1),
                    splashColor: Colors.amber[500],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    heroTag: "Redo",
                    onPressed: () {
                      _undoController.redo();
                    },
                    child: const Icon(
                      Icons.redo_sharp,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.grey[800],
                    shape: CircleBorder(eccentricity: 1),
                    splashColor: Colors.amber[500],
                  )
                ],
              ),
              Expanded(
                child: Container(
                  child: MoveText(),
                ),
              ),
              TextField(
                  controller: _textController,
                  undoController: _undoController,
                  decoration: InputDecoration(
                    hintText: "Whats on your Mind",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          _textController.clear();
                        },
                        icon: const Icon(Icons.clear_rounded)),
                  )),
              Row(
                children: [
                  DropdownButton<String>(
                    items: _Fonts.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String? newValueSelected) {
                      setState(() {
                        _HomePageState._currentItemSelected = newValueSelected!;
                      });
                    },
                    underline: Container(
                      height: 2,
                      color: Colors.grey[900],
                    ),
                    value: _currentItemSelected,
                  ),
                  const SizedBox(width: 110),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        userPost = _textController.text;
                      });
                    },
                    color: Colors.grey[900],
                    child: Text(
                      "Add Text",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  DropdownButton<String>(
                    items: _Size.map((String dropDownItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownItem,
                        child: Text(dropDownItem),
                      );
                    }).toList(),
                    onChanged: (String? newSizeSelected) {
                      setState(() {
                        _HomePageState._currentSize = newSizeSelected!;
                      });
                    },
                    underline: Container(
                      height: 2,
                      color: Colors.grey[900],
                    ),
                    value: _currentSize,
                  ),
                  const SizedBox(width: 70),
                  DropdownButton<Color>(
                    items: colors
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: e,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (color) {
                      setState(() => value = color!);
                    },
                    value: value,
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}

class MoveText extends StatefulWidget {
  const MoveText({super.key});
  @override
  State<MoveText> createState() => _MoveTextState();
}

class _MoveTextState extends State<MoveText> {
  double _xPosition = 0;
  double _yPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: _xPosition,
          top: _yPosition,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _xPosition += details.delta.dx;
                _yPosition += details.delta.dy;
              });
            },
            child: Center(
              child: Text(
                _HomePageState.userPost,
                style: TextStyle(
                    fontFamily: _HomePageState._currentItemSelected,
                    fontSize: double.parse(_HomePageState._currentSize),
                    color: _HomePageState.value),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
