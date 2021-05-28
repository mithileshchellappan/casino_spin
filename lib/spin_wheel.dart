import 'dart:async';
import 'dart:math';

import 'package:casino_spin/util/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

bool isDisabled = false;
final Map<int, String> labels = {
  1: '1',
  2: '2',
  3: '3',
  4: '4',
  5: '5',
  6: '6',
  7: '7',
  8: '8',
  9: '9',
  10: '10'
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
  DateTime dtr;
  Duration duration;
  String selectedNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDDC3FF),
      body: Center(
        child: FutureBuilder(
            future: Network().nextShow(),
            builder: (context, stream) {
              if(stream.data!='No Show'){
                
              print(stream.data);
              dtr = DateTime.parse(stream.data);
              duration = dtr.difference(DateTime.now());
              print(dtr.toString()+'dt2');
              print(duration);
              switch (stream.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());

                case ConnectionState.done:
                  return StreamBuilder(
                      stream: _timeController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<DateTime> snapshot) {

                        DateTime currTime = snapshot.data;
                        if (currTime==dtr) {
                          print('spinning');
                          _wheelNotifier.sink.add(_generateRandomVelocity());
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                    color: Color(0xFF8360c3)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Next Show: ${dtr.hour}:${dtr.minute}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.yellowAccent
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    border: Border.all(
                                                        color: Colors.yellow)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('Coins:260',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20)),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SlideCountdownClock(
                                        onDone: () {
                                          print('done');
                                        },
                                        slideDirection: SlideDirection.Up,
                                        separator: '-',
                                        padding: EdgeInsets.all(13),
                                        decoration: BoxDecoration(
                                            color: Colors.green[200],
                                            shape: BoxShape.circle),
                                        duration: duration)
                                  ],
                                )),
                            SizedBox(height: 60),
                            Expanded(
                              child: Column(
                                children: [
                                  SpinningWheel(
                                    Image.asset('spinner2.png'),
                                    width: 310,
                                    height: 310,
                                    initialSpinAngle: _generateRandomAngle(),
                                    spinResistance: 0.6,
                                    canInteractWhileSpinning: false,
                                    dividers: 10,
                                    secondaryImage:
                                        Image.asset('roulette-center-300.png'),
                                    onUpdate: (val) {
                                      _dividerController.add(val);
                                    },
                                    onEnd: _dividerController.add,
                                    shouldStartOrStop: _wheelNotifier.stream,
                                    secondaryImageHeight: 110,
                                    secondaryImageWidth: 110,
                                  ),
                                  SizedBox(height: 30),
                                  StreamBuilder(
                                      stream: _dividerController.stream,
                                      builder: (context, snapshot) {
                                        var dt2 = DateTime.now().minute;

                                        if (!(dt2 % 15 == 0)) {
                                          return snapshot.hasData
                                              ? RouletteScore(snapshot.data)
                                              : Container();
                                        } else {
                                          return Container();
                                        }
                                      }),
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
                                                        print('val' +
                                                            snapshot.data
                                                                .toString());
                                                        Alert(
                                                            context: context,
                                                            title:
                                                                'Confirm ${labels[snapshot.data]}',
                                                            buttons: [
                                                              DialogButton(
                                                                  child: Text(
                                                                      'Yes'),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      selectedNumber =
                                                                          labels[
                                                                              snapshot.data];
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                    Alert(
                                                                        context:
                                                                            context,
                                                                        title:
                                                                            'Enter coins to bet',
                                                                        content:
                                                                            TextFormField(
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                        )).show();
                                                                  })
                                                            ]).show();
                                                        print('val crossed');
                                                      });
                                          });
                                    }
                                    return Container();
                                  })
                                ],
                              ),
                            )
                          ],
                        );
                      });
                default:
                  return Center(child: Text('Error!'));
              }
              }else{
                return Center(child: Container(child:Text('No show')));
              }
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
    1: '8',
    2: '9',
    3: '10',
    4: '1',
    5: '2',
    6: '3',
    7: '4',
    8: '5',
    9: '6',
    10: '7'
  };

  RouletteScore(this.selected);

  @override
  Widget build(BuildContext context) {
    return isDisabled
        ? Text('')
        : Text('Your selected number is ${labels[selected]}',
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0));
  }
}
