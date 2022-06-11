import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_park/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = FirebaseAuth.instance;

  final snackBar = const SnackBar(
    content: Text('User Registered Successfully!'),
  );

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
                            'Register',
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
                                  ? 'Password must not be empty'
                                  : null,
                              errorStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.red,
                                  fontSize: 16.0),
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
                              'Register',
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
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  final user =
                                      await auth.createUserWithEmailAndPassword(
                                          email: username, password: password);

                                  //show success message
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

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
                                      'Register Failed', errorText.toString());

                                  setState(() {
                                    isLoading = false;
                                  });
                                  //print(errorText);
                                } catch (e) {
                                  //print('Error eeeeeeeeeeeeeeeeeeeeeeeeee');

                                  _onAlertButtonPressed(
                                      context,
                                      'Register Failed',
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
    title: title,
    desc: desc,
    style: alertStyle,
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
