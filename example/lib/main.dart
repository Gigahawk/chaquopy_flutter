import 'package:flutter/material.dart';
import 'dart:async';

import 'package:chaquopy/chaquopy.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller;
  FocusNode _focusNode;

  String _output = "", _error = "";

  Map<String, dynamic> data = Map();
  bool loadImageVisibility = true;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void addIntendation() {
    TextEditingController _updatedController = TextEditingController();

    int currentPosition = _controller.selection.start;

    String controllerText = _controller.text;
    String text = controllerText.substring(0, currentPosition) +
        "    " +
        controllerText.substring(currentPosition, controllerText.length);

    _updatedController.value = TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: _controller.text.length + 4,
        extentOffset: _controller.text.length + 4,
      ),
    );

    setState(() {
      _controller = _updatedController;
    });
  }

  // to run PythonCode, just use executeCode function, which will return map with following format
  // {
  // "textOutput" : output of the code,
  // "error" : error generated while running the code
  // }
  Future<void> runPythonCode(String pythonCode) async {
    Map<String, dynamic> _result = Map<String, dynamic>();
    // Platform messages may fail, so we use a try/catch PlatformException.
    _result = await Chaquopy.executeCode('print("Hello")');

    setState(() {
      _output = _result['textOutput'].toString();
      _error = _result['error'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      minimum: EdgeInsets.only(top: 4),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  focusNode: _focusNode,
                  controller: _controller,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(
                    'This is the output code : $_output',
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    'This is the error generated : $_error',
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        color: Colors.green,
                        onPressed: () => addIntendation(),
                        child: Icon(
                          Icons.arrow_right_alt,
                          size: 50,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        height: 50,
                        color: Colors.green,
                        child: Text(
                          'run Code',
                        ),
                        onPressed: () => runPythonCode(_controller.text),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}