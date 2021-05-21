import 'package:casino_spin/spin_wheel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _email, _password;
  bool authorized = false;
  bool isAuthenticating = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      emailbutton(),
                      Container(padding: EdgeInsets.only(bottom: 20.0)),
                      passwordbutton(),
                      Container(
                        padding: EdgeInsets.all(10.0),
                      ),
                      finalsignin(context),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailbutton() {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
          keyboardType: TextInputType.number,
          validator: (input) {
            if (input.length < 5) {
              return 'Invalid username';
            }
            return null;
          },
          onSaved: (input) {
            setState(() {
              _email = input;
            });
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: 'User ID',
            labelStyle:
                TextStyle(fontFamily: 'Montserrat', color: Colors.black),
            prefixIcon: Icon(Icons.email, color: Colors.black),
          ),
        ));
  }

  Widget passwordbutton() {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
          obscureText: true,
          validator: (input) {
            if (input.length < 7) {
              return 'Wrong password.';
            }
            return null;
          },
          onSaved: (input) {
            setState(() {
              _password = input;
            });
          },
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 1.0),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              labelText: 'Password',
              labelStyle:
                  TextStyle(fontFamily: 'Montserrat', color: Colors.black),
              prefixIcon: Icon(Icons.lock, color: Colors.black)),
        ));
  }

  Widget finalsignin(BuildContext context) {
    return Container(
        height: 53.00,
        // width: 130.00,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(27.00),
        ),
        child: FlatButton(
            onPressed: () async {
              final form = _formkey.currentState;
              if (form.validate()) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              }
            },
            child: Text('Authenticate',
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                  color: Color(0xffffffff),
                ))));
  }

  void showSnackBar(BuildContext context, String status) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(new SnackBar(
        content: Text(status),
        action: SnackBarAction(
            label: 'Close', onPressed: scaffold.hideCurrentSnackBar)));
  }
}
