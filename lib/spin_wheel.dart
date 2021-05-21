import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

bool isDisabled = false;
final Map<int, String> labels = {
  1: '1000\$',
  2: '400\$',
  3: '800\$',
  4: '7000\$',
  5: '5000\$',
  6: '300\$',
  7: '2000\$',
  8: '100\$',
};
String selectedNumb = '0';

class _MyHomePageState extends State<MyHomePage> {
  final StreamController _dividerController = StreamController.broadcast();

  final _wheelNotifier = StreamController<double>();
  StreamController<DateTime> _timeController;
  @override
  void initState() {
    _timeController = new StreamController();
    Timer.periodic(Duration(seconds: 1), (_) => addTime());
    super.initState();
  }

  addTime() {
    _timeController.sink.add(DateTime.now());
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDDC3FF),
      body: Center(
        child: StreamBuilder(
            stream: _timeController.stream,
            builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
              print(snapshot.data);

              DateTime currTime = snapshot.data;
              print(currTime.minute % 5);
              print(currTime.minute);
              if (currTime.minute % 15 == 0) {
                print(currTime.minute % 5);
                print('spinning');
                _wheelNotifier.sink.add(_generateRandomVelocity());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height:200,
                  decoration: BoxDecoration(borderRadius:BorderRadius.only(bottomLeft:Radius.circular(15),bottomRight:Radius.circular(15)),color:Color(0xFF8360c3)),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Next Show: 12:00 PM',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:20)),
                      ),Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(color:Colors.yellowAccent.withOpacity(0.4),borderRadius:BorderRadius.all(Radius.circular(10)),border:Border.all(color:Colors.yellow)),
                          child:Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Coins:260',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:20)),
                          )
                        ),
                      )
                    ],
                  )
                  ),
                  SizedBox(height:60),
                  Expanded(child: Column(children: [
                    SpinningWheel(
                    Image.asset('spinner.png'),
                    width: 310,
                    height: 310,
                    initialSpinAngle: _generateRandomAngle(),
                    spinResistance: 0.6,
                    canInteractWhileSpinning: false,
                    dividers: 8,
                    secondaryImage: Image.asset('roulette-center-300.png'),
                    onUpdate: (val) {
                      _dividerController.add(val);
                      print(val);
                    },
                    onEnd: _dividerController.add,
                    shouldStartOrStop: _wheelNotifier.stream,
                    secondaryImageHeight: 110,
                    secondaryImageWidth: 110,
                  ),
                  SizedBox(height: 30),
                  StreamBuilder(
                    stream: _dividerController.stream,
                    builder: (context, snapshot) => snapshot.hasData
                        ? RouletteScore(snapshot.data)
                        : Container(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Builder(builder: (context) {
                    var dt = DateTime.now().minute;
                    if (!(dt % 15 == 0)) {
                      return StreamBuilder(
                          stream: _dividerController.stream,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                                child: new Text("Submit?"),
                                onPressed: isDisabled
                                    ? null
                                    : () async {
                                        print('val' + snapshot.data.toString());
                                        Alert(
                                            context: context,
                                            title:
                                                'Confirm ${labels[snapshot.data]}',
                                            buttons: [
                                              DialogButton(
                                                  child: Text('Yes'),
                                                  onPressed: () {})
                                            ]).show();
                                        print('val crossed');
                                      });
                          });
                    }
                    return Container();
                  })
                  ],),)
                ],
              );
            }),
      ),
    );
  }

  double _generateRandomVelocity() => 65000;

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;
}

class RouletteScore extends StatelessWidget {
  final int selected;

  final Map<int, String> labels = {
    1: '1000\$',
    2: '400\$',
    3: '800\$',
    4: '7000\$',
    5: '5000\$',
    6: '300\$',
    7: '2000\$',
    8: '100\$',
  };

  RouletteScore(this.selected);

  @override
  Widget build(BuildContext context) {
    return isDisabled
        ? Text('')
        : Text('Your selected amount is ${labels[selected]}',
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0));
  }
}
