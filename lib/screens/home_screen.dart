import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_park/constants/constants.dart';
import 'package:quick_park/screens/login_screen.dart';
import 'package:quick_park/screens/register_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 60.0, left: 80.0, right: 80.0, bottom: 0),
                    child: Image.asset(
                      'images/car.png',
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Quick Park',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    padding: const EdgeInsets.all(10.0),
                    color: kdark,
                    textColor: Colors.white,
                    child: const Text(
                      'Login',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.grey,
                            width: 3,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(50)),
                    padding: const EdgeInsets.all(10.0),
                    color: Colors.transparent,
                    textColor: Colors.black,
                    child: const Text(
                      'Register',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                  ),
                  const SizedBox(
                    height: 50.0,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
