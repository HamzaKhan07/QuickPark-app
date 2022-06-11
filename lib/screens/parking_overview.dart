import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:quick_park/constants/constants.dart';
import 'package:quick_park/widgets/park_block.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ParkingOverview extends StatefulWidget {
  const ParkingOverview({Key? key}) : super(key: key);

  @override
  _ParkingOverviewState createState() => _ParkingOverviewState();
}

class _ParkingOverviewState extends State<ParkingOverview> {
  final auth = FirebaseAuth.instance;
  late User loggedInUser;
  final firestore = FirebaseFirestore.instance;
  // 0 indicates filled space and 1 indicates empty space
  List<int> list = List.filled(65, 0);
  List<String> index = [];
  late StreamSubscription<QuerySnapshot> streamSub;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    try {
      dataTest();
    } on Exception catch (e) {
      print('Exception in init: ' + e.toString());
    } catch (e) {
      print('Error in init: ' + e.toString());
    }
  }

  Future<void> deleteData() async {
    await firestore.collection('empty-spaces').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    print('data deleted');
  }

  void dataTest() {
    CollectionReference reference = firestore.collection('empty-spaces');
    streamSub = reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        // Do something with change

        //collect all the empty-spaces index into a list
        index = change.doc
            .data()
            .toString()
            .replaceAll('{', '')
            .replaceAll('}', '')
            .replaceAll('data:', '')
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll(',', '')
            .split(' ');

        //print(index);

        //empty the list
        list = [];
        list = List.filled(64, 0);

        //put 1 on the appropriate index indicating empty-space
        for (int i = 0; i < index.length; i++) {
          if (index[i] != '') {
            list[int.parse(index[i])] = 1;
          }
        }

        setState(() {});
      });
    });
  }

  void getDataStatic() async {
    final messages = await firestore.collection('empty-spaces').get();

    for (var message in messages.docs) {
      print(message.data());
    }
  }

  void getDataRealTime() async {
    await for (var snapshot
        in firestore.collection('empty-spaces').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
        //message.reference.delete();
      }
    }
  }

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } on Exception catch (exception) {
      //print('Exception eeeeeeeeeeeeeeeeeeeeeeee: ');
      print(exception);
    } catch (e) {
      //print('Error eeeeeeeeeeeeeeeeeeeeeeee: ');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                await streamSub.cancel();
                await deleteData();
                try {
                  await auth.signOut();
                } on Exception catch (e) {
                  print('Exception in signOut: ' + e.toString());
                } catch (e) {
                  print('Error in signOut: ' + e.toString());
                }

                Navigator.pop(context);
              },
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'Parking Overview',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 6.0,
            ),
            Row(
              children: [
                Flexible(
                  child: Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: klightYellow,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 6.0),
                      child: const Text(
                        'A',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: klightYellow,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 6.0),
                      child: const Text(
                        'B',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                //color: Colors.blue,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        //color: Colors.red,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                //color: Colors.teal,
                                //blocks A
                                child: Column(
                                  children: [
                                    ParkBlock(
                                      colorBack: list[0] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[0] == 1 ? kdark : Colors.white,
                                      number: '1',
                                    ),
                                    ParkBlock(
                                      colorBack: list[1] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[1] == 1 ? kdark : Colors.white,
                                      number: '2',
                                    ),
                                    ParkBlock(
                                      colorBack: list[2] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[2] == 1 ? kdark : Colors.white,
                                      number: '3',
                                    ),
                                    ParkBlock(
                                      colorBack: list[3] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[3] == 1 ? kdark : Colors.white,
                                      number: '4',
                                    ),
                                    ParkBlock(
                                      colorBack: list[4] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[4] == 1 ? kdark : Colors.white,
                                      number: '5',
                                    ),
                                    ParkBlock(
                                      colorBack: list[5] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[5] == 1 ? kdark : Colors.white,
                                      number: '6',
                                    ),
                                    ParkBlock(
                                      colorBack: list[6] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[6] == 1 ? kdark : Colors.white,
                                      number: '7',
                                    ),
                                    ParkBlock(
                                      colorBack: list[7] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[7] == 1 ? kdark : Colors.white,
                                      number: '8',
                                    ),
                                    ParkBlock(
                                      colorBack: list[8] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[8] == 1 ? kdark : Colors.white,
                                      number: '9',
                                    ),
                                    ParkBlock(
                                      colorBack: list[9] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[9] == 1 ? kdark : Colors.white,
                                      number: '10',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[10] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[10] == 1 ? kdark : Colors.white,
                                      number: '11',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[11] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[11] == 1 ? kdark : Colors.white,
                                      number: '12',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[12] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[12] == 1 ? kdark : Colors.white,
                                      number: '13',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[13] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[13] == 1 ? kdark : Colors.white,
                                      number: '14',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[14] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[14] == 1 ? kdark : Colors.white,
                                      number: '15',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[15] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[15] == 1 ? kdark : Colors.white,
                                      number: '16',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[16] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[16] == 1 ? kdark : Colors.white,
                                      number: '17',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                //color: Colors.pink,
                                child: Column(
                                  //block A
                                  children: [
                                    ParkBlock(
                                      colorBack:
                                          list[17] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[17] == 1 ? kdark : Colors.white,
                                      number: '18',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[18] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[18] == 1 ? kdark : Colors.white,
                                      number: '19',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[19] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[19] == 1 ? kdark : Colors.white,
                                      number: '20',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[20] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[20] == 1 ? kdark : Colors.white,
                                      number: '21',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[21] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[21] == 1 ? kdark : Colors.white,
                                      number: '22',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[22] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[22] == 1 ? kdark : Colors.white,
                                      number: '23',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[23] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[23] == 1 ? kdark : Colors.white,
                                      number: '24',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[24] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[24] == 1 ? kdark : Colors.white,
                                      number: '25',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[25] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[25] == 1 ? kdark : Colors.white,
                                      number: '26',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[26] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[26] == 1 ? kdark : Colors.white,
                                      number: '27',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[27] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[27] == 1 ? kdark : Colors.white,
                                      number: '28',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[28] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[28] == 1 ? kdark : Colors.white,
                                      number: '29',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[29] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[29] == 1 ? kdark : Colors.white,
                                      number: '30',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[30] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[30] == 1 ? kdark : Colors.white,
                                      number: '31',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[31] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[31] == 1 ? kdark : Colors.white,
                                      number: '32',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[32] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[32] == 1 ? kdark : Colors.white,
                                      number: '33',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[33] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[33] == 1 ? kdark : Colors.white,
                                      number: '34',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        //color: Colors.yellow,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                //color: Colors.teal,
                                //blocks B
                                child: Column(
                                  children: [
                                    ParkBlock(
                                      colorBack:
                                          list[34] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[34] == 1 ? kdark : Colors.white,
                                      number: '1',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[35] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[35] == 1 ? kdark : Colors.white,
                                      number: '2',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[36] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[36] == 1 ? kdark : Colors.white,
                                      number: '3',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[37] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[37] == 1 ? kdark : Colors.white,
                                      number: '4',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[38] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[38] == 1 ? kdark : Colors.white,
                                      number: '5',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[39] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[39] == 1 ? kdark : Colors.white,
                                      number: '6',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[40] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[40] == 1 ? kdark : Colors.white,
                                      number: '7',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[41] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[41] == 1 ? kdark : Colors.white,
                                      number: '8',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[42] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[42] == 1 ? kdark : Colors.white,
                                      number: '9',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[43] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[43] == 1 ? kdark : Colors.white,
                                      number: '10',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[44] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[44] == 1 ? kdark : Colors.white,
                                      number: '11',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[45] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[45] == 1 ? kdark : Colors.white,
                                      number: '12',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[46] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[46] == 1 ? kdark : Colors.white,
                                      number: '13',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[47] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[47] == 1 ? kdark : Colors.white,
                                      number: '14',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[48] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[48] == 1 ? kdark : Colors.white,
                                      number: '15',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                //color: Colors.pink,
                                child: Column(
                                  //block B
                                  children: [
                                    ParkBlock(
                                      colorBack:
                                          list[49] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[49] == 1 ? kdark : Colors.white,
                                      number: '16',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[50] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[50] == 1 ? kdark : Colors.white,
                                      number: '17',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[51] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[51] == 1 ? kdark : Colors.white,
                                      number: '18',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[52] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[52] == 1 ? kdark : Colors.white,
                                      number: '19',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[53] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[53] == 1 ? kdark : Colors.white,
                                      number: '20',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[54] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[54] == 1 ? kdark : Colors.white,
                                      number: '21',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[55] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[55] == 1 ? kdark : Colors.white,
                                      number: '22',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[56] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[56] == 1 ? kdark : Colors.white,
                                      number: '23',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[57] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[57] == 1 ? kdark : Colors.white,
                                      number: '24',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[58] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[58] == 1 ? kdark : Colors.white,
                                      number: '25',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[59] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[59] == 1 ? kdark : Colors.white,
                                      number: '26',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[60] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[60] == 1 ? kdark : Colors.white,
                                      number: '27',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[61] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[61] == 1 ? kdark : Colors.white,
                                      number: '28',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[62] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[62] == 1 ? kdark : Colors.white,
                                      number: '29',
                                    ),
                                    ParkBlock(
                                      colorBack:
                                          list[63] == 1 ? kyellow : kdark,
                                      colorFore:
                                          list[63] == 1 ? kdark : Colors.white,
                                      number: '30',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
