import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

class TestExample extends StatefulWidget {
  @override
  _TestExampleState createState() => _TestExampleState();
}

class _TestExampleState extends State<TestExample> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sound Example"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Icon(Icons.cancel),
                // mini: true,
                color: Colors.deepOrange,
                onPressed: () {
                  if (_isListening)
                    _speechRecognition.cancel().then(
                          (result) => setState(() {
                            _isListening = result;
                            resultText = "";
                          }),
                        );
                },
              ),
              RaisedButton(
                child: Icon(Icons.mic),
                onPressed: () {
                  print("word print is ongoing");
                  print("_isAvailable =>$_isAvailable");
                  print("_isListening=> $_isListening");
                  print("${(_isAvailable && !_isListening)}");

                  if (_isAvailable && !_isListening)
                    _speechRecognition
                        .listen(locale: "en_US")
                        .then((result) => print('$result'));
                },
                color: Colors.pink,
              ),
              RaisedButton(
                child: Icon(Icons.stop),
                //mini: true,
                color: Colors.deepPurple,
                onPressed: () {
                  if (_isListening)
                    _speechRecognition.stop().then(
                          (result) => setState(() => _isListening = result),
                        );
                },
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.cyanAccent[200],
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            child: Text(
              resultText,
              style: TextStyle(fontSize: 24.0),
            ),
          )
        ],
      ),
    );
  }
}
