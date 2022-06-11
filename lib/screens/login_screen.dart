import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:quick_park/constants/constants.dart';
import 'package:quick_park/screens/parking_overview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
} 

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;

  late String username;

  late String password;

  bool isLoading = false;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  bool isEmailEmpty = false;
  bool isPasswordEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 80.0,
                                left: 100.0,
                                right: 100.0,
                                bottom: 10),
                            child: Image.asset(
                              'images/car.png',
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              username = value;
                            },
                            cursorColor: kdark,
                            style: const TextStyle(
                              color: kdark,
                              fontSize: 18.0,
                              fontFamily: 'Poppins',
                            ),
                            decoration: InputDecoration(
                              errorText: isEmailEmpty
                                  ? 'Email must not be empty'
                                  : null,
                              errorStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                color: Colors.red,
                              ),
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                color: kdark,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: kdark, width: 2.0),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: kdark, width: 2.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            controller: passwordController,
                            onChanged: (value) {
                              password = value;
                            },
                            cursorColor: kdark,
                            style: const TextStyle(
                              color: kdark,
                              fontSize: 18.0,
                              fontFamily: 'Poppins',
                            ),
                            decoration: InputDecoration(
                              errorText: isPasswordEmpty
                                  ? 'Password must not be empty'
                                  : null,
                              errorStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.red,
                                  fontSize: 16.0),
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                color: kdark,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: kdark, width: 2.0),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: kdark, width: 2.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            padding: const EdgeInsets.all(10.0),
                            color: kdark,
                            textColor: Colors.white,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 20.0),
                            ),
                            onPressed: () async {
                              if (emailController.text.isEmpty) {
                                setState(() {
                                  isEmailEmpty = true;
                                });
                              } else {
                                setState(() {
                                  isEmailEmpty = false;
                                });
                              }

                              if (passwordController.text.isEmpty) {
                                setState(() {
                                  isPasswordEmpty = true;
                                });
                              } else {
                                setState(() {
                                  isPasswordEmpty = false;
                                });
                              }

                              if (emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final user =
                                      await auth.signInWithEmailAndPassword(
                                          email: username, password: password);

                                  //if success, redirect to parking overview page
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ParkingOverview()));

                                  setState(() {
                                    isLoading = false;
                                  });
                                } on Exception catch (exception) {
                                  //print('Exception eeeeeeeeeeeeeeeeeeeeee: ');
                                  var errorSep =
                                      exception.toString().split(']');
                                  errorSep.removeAt(0);
                                  var errorText = errorSep.join(' ').trim();

                                  _onAlertButtonPressed(context,
                                      'Login Failure', errorText.toString());

                                  setState(() {
                                    isLoading = false;
                                  });
                                } catch (e) {
                                  //print('Error eeeeeeeeeeeeeeeeeeeeeeeeeeee: ');

                                  _onAlertButtonPressed(context, 'Login Failed',
                                      'Something went wrong, try again!');

                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var alertStyle = const AlertStyle(
  titleStyle: TextStyle(
      fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold),
  descStyle: TextStyle(
    fontFamily: 'Poppins',
    fontSize: 15,
  ),
);

_onAlertButtonPressed(context, title, desc) {
  Alert(
    context: context,
    type: AlertType.error,
    style: alertStyle,
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
        color: kdark,
        child: const Text(
          "OK",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: 'Poppins'),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}
