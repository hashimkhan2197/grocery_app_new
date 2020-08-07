import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryapp/grocerry_kit/store_package/stores_list_screen.dart';

class SignInPage extends StatefulWidget {
  static const routeName = "signInPage";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _scacffoldKey = GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  bool _isObscured = true;
  Color _eyeButtonColor = Colors.grey[700];
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scacffoldKey,
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height - 50,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Welcome!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 28,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
                        validator: (val) {
                          return val.trim().isEmpty
                              ? "email cannot be empty."
                              : null;
                        },
                        onSaved: (val) {
                          _email = val.trim();
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'E-Mail Address',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
                        validator: (String val) {
                          if (val.trim().isEmpty) {
                            return "Password cannot be empty";
                          } else if (val.trim().length < 8) {
                            return "Password must be 8 characters.";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _password = val.trim();
                        },
                        obscureText: _isObscured,
                        style: TextStyle(fontSize: 18),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (_isObscured) {
                                setState(() {
                                  _isObscured = false;
                                  _eyeButtonColor =
                                      Theme.of(context).primaryColor;
                                });
                              } else {
                                setState(() {
                                  _isObscured = true;
                                  _eyeButtonColor = Colors.grey;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: _eyeButtonColor,
                            ),
                          ),
                          hintText: 'Password',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, right: 12),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    _formKey.currentState.save();
                    _resetPassword(_email, context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                CircularProgressIndicator(),
              if (!_isLoading)
                Container(
                  margin: EdgeInsets.only(top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 250,
                  child: FlatButton(
                    child: Text('Sign In',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //Only gets here if the fields pass
                        _formKey.currentState.save();
                        _login(_email, _password, context);
                      }
                    },
                  ),
                ),

//                    SizedBox(
//                      height: 20,
//                    )
            ],
          ),
        ),
      )),
    );
  }

  void _login(email, password, BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(authResult.user.uid);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return StoresListPage();
      }));
    } on PlatformException catch (err) {
      var message = "An error has occured, please check your credentials.";

      if (err.message != null) {
        message = err.message;
      }

      _scacffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);

      setState(() {
        _isLoading = false;
      });
    }
  }
  void _resetPassword(String email, BuildContext ctx) async {
    try {
      await _auth.sendPasswordResetEmail(
          email: email);
      _scacffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "A recovery email has been sent to you.",
        ),
        backgroundColor: Theme.of(ctx).primaryColor,
      ));


    } on PlatformException catch (err) {
      var message = "An error has occured, please check your credentials.";

      if (err.message != null) {
        message = err.message;
      }

      if(email == null || email.isEmpty){
        message = "Please enter your registered email";
      }

      _scacffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);

      setState(() {
        _isLoading = false;
      });
    }
  }
}
