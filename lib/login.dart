import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'driver_manual.dart';
import 'induction.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _counter = 0;
  final  _formKey = GlobalKey<FormState>();
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double h = size.height;
    int layout_height = h.round();

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: true,
      body: Form(
      key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
              child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
            Positioned(


                child: SvgPicture.asset('asset/images/background2.svg',
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width,
                    height: size.height,

                    )
                    ),
            Positioned(
                bottom: 0,
                child: SvgPicture.asset('asset/images/logo_road.svg',
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width,
                    height: 150)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                SvgPicture.asset('asset/images/logo.svg'),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width - 60,
                  height: 320,
                  child: Card(
                    color: Color(0xffe1e1e1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10.0,
                    child: Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 0, left: 20.0, right: 0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text("Login",
                                style: Theme.of(context).textTheme.headline5),
                          )),
                      SizedBox(height: 10,),
                      _getInputText(
                          null, "E-Mail Address", "E-Mail Address", "Invalid mail id"),
                     _getInputText(null, "Password", "Password", "Invalid Password Id",obscureText: true),
                      Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Container(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              )),
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey.currentState.validate()) {

                              Map<String, dynamic> data =
                              Map<String, dynamic>();
                              data['cat_id'] = "1";
                              data['cat_name']="test";
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Induction()));
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                            }
                          },
                          child: Text('Login',
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                        )),
                      ),
                    ]),
                  ),
                )
              ],
            ),
          ])),
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  Widget _getInputText(
      TextEditingController controller, String hint, String label, String msg,
      {obscureText = false}) {
    final _minimumPaadding = 5.0;

    return Padding(
        padding: EdgeInsets.only(
            top: _minimumPaadding,
            bottom: _minimumPaadding,
            left: 20.0,
            right: 20.0),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,

          decoration: InputDecoration(
           /* hintStyle: TextStyle(
                color: Theme.of(context).primaryColor),*/
            hintText: hint,

          ),
          validator: (value) {
         /*   if (value.isEmpty) {
              return msg;
            }*/
            return null;
          },
        ));
  }
}
