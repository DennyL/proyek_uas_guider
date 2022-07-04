// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, TODO, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyek_uas_guider/dbservices.dart';

import '../userdata.dart';
import '../widgets/ytdisplay.dart';

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final CollectionReference _colRefContentSubs =
      FirebaseFirestore.instance.collection('contents');
  String sub_state = '';
  List<String> cek_sub = [];

  @override
  void initState() {
    // TODO: implement initState

    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void filterIsiSubscriptionDatabase() {
    String temp = "";
    cek_sub = [];

    for (int i = 1; i < sub_state.length; i++) {
      if (sub_state[i] != ',') {
        temp = temp + sub_state[i];
      } else {
        cek_sub.add(temp);
        temp = "";
      }
      if (i == (sub_state.length) - 1) {
        cek_sub.add(temp);
      }
    }

    print("hai fungsi $cek_sub");
  }

  void getUserData() {
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    final userData = Database.getData(uid: userUID);
    userData.then(
      (DocumentSnapshot docsnap) {
        if (docsnap.exists) {
          if (mounted) {
            setState(
              () {
                sub_state = docsnap.get('userSubs');
                filterIsiSubscriptionDatabase();
              },
            );
          }
        } else {
          print('Not Found');
        }
      },
    );
  }

  Stream<QuerySnapshot<Object?>> Data(
      CollectionReference<Object?> colRefContentSubs, String Path) {
    setState(() {});
    return Database.getContent(
      colRefContentSubs.doc('subscriptions').collection(Path),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width_halaman = MediaQuery.of(context).size.width;

    print("$sub_state hai");
    print("$cek_sub hai cek sub");

    return Scaffold(
      backgroundColor: Color(0xFF171717),
      body: SafeArea(
        child: PageView(
          children: [
            //TODO: NON SUB
            cek_sub.length < 3
                ? SingleChildScrollView(
                    child: Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Visibility(
                                visible: cek_sub.contains('beginners')
                                    ? false
                                    : true,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green,
                                  ),
                                  width: width_halaman,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Text(
                                          "Beginner",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        width: width_halaman,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 16),
                                                child: Text(
                                                    "In this subcription plan, you will get beginner class video tutorials."),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 10),
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: RawMaterialButton(
                                                    onPressed: () {
                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                            "Beginner Subscription",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          content: Text(
                                                              "Would you like to buy Beginner Subscription for \$29.99 ?"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel');
                                                              },
                                                              child: Text(
                                                                  "Cancel"),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                final userUID =
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid;

                                                                final userData =
                                                                    Database.getData(
                                                                        uid:
                                                                            userUID);
                                                                userData.then(
                                                                  (DocumentSnapshot
                                                                      docsnap) {
                                                                    if (docsnap
                                                                        .exists) {
                                                                      final updateUserData =
                                                                          userDatabase(
                                                                        userName: docsnap
                                                                            .get('userName')
                                                                            .toString(),
                                                                        userEmail: docsnap
                                                                            .get('userEmail')
                                                                            .toString(),
                                                                        userSubs:
                                                                            '$sub_state,beginners',
                                                                        userPic: docsnap
                                                                            .get('userPic')
                                                                            .toString(),
                                                                      );
                                                                      Database.updateData(
                                                                              user: updateUserData,
                                                                              uid: userUID)
                                                                          .whenComplete(() {})
                                                                          .then(
                                                                        (value) {
                                                                          if (mounted) {
                                                                            setState(
                                                                              () {
                                                                                getUserData();
                                                                              },
                                                                            );
                                                                          }
                                                                        },
                                                                      );
                                                                    }
                                                                  },
                                                                );

                                                                Navigator.pop(
                                                                    context,
                                                                    'Buy');
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        "Thank you for buying Beginner Subscription (\$29.99)"),
                                                                  ),
                                                                );
                                                              },
                                                              child:
                                                                  Text("Buy"),
                                                            ),
                                                          ],
                                                        ),
                                                      ).then(
                                                        (value) {
                                                          if (mounted) {
                                                            setState(
                                                              () {
                                                                getUserData();
                                                              },
                                                            );
                                                          }
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .currency_exchange_rounded,
                                                      size: 25,
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(15.0),
                                                    shape: CircleBorder(),
                                                    fillColor: Colors.green,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //TODO: Intermediates
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Visibility(
                                visible: cek_sub.contains('intermediates')
                                    ? false
                                    : true,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.lightBlueAccent,
                                  ),
                                  width: width_halaman,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Text(
                                          "Intermediate",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        width: width_halaman,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 16),
                                                child: Text(
                                                    "In this subcription plan, you will get intermediate class video tutorials."),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 10),
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: RawMaterialButton(
                                                    onPressed: () {
                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                            "Intermediate Subscription",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          content: Text(
                                                              "Would you like to buy Intermediate Subscription for \$39.99 ?"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel');
                                                              },
                                                              child: Text(
                                                                  "Cancel"),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                final userUID =
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid;

                                                                final userData =
                                                                    Database.getData(
                                                                        uid:
                                                                            userUID);
                                                                userData.then(
                                                                  (DocumentSnapshot
                                                                      docsnap) {
                                                                    if (docsnap
                                                                        .exists) {
                                                                      final updateUserData =
                                                                          userDatabase(
                                                                        userName: docsnap
                                                                            .get('userName')
                                                                            .toString(),
                                                                        userEmail: docsnap
                                                                            .get('userEmail')
                                                                            .toString(),
                                                                        userSubs:
                                                                            '$sub_state,intermediates',
                                                                        userPic: docsnap
                                                                            .get('userPic')
                                                                            .toString(),
                                                                      );
                                                                      Database.updateData(
                                                                              user: updateUserData,
                                                                              uid: userUID)
                                                                          .whenComplete(() {})
                                                                          .then(
                                                                        (value) {
                                                                          if (mounted) {
                                                                            setState(
                                                                              () {
                                                                                getUserData();
                                                                              },
                                                                            );
                                                                          }
                                                                        },
                                                                      );
                                                                    }
                                                                  },
                                                                );

                                                                Navigator.pop(
                                                                    context,
                                                                    'Buy');
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        "Thank you for buying Intermediate Subscription (\$39.99)"),
                                                                  ),
                                                                );
                                                              },
                                                              child:
                                                                  Text("Buy"),
                                                            ),
                                                          ],
                                                        ),
                                                      ).then(
                                                        (value) {
                                                          if (mounted) {
                                                            setState(
                                                              () {
                                                                getUserData();
                                                              },
                                                            );
                                                          }
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .currency_exchange_rounded,
                                                      size: 25,
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(15.0),
                                                    shape: CircleBorder(),
                                                    fillColor:
                                                        Colors.lightBlueAccent,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //TODO: Advanced
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Visibility(
                                visible: cek_sub.contains('advanceds')
                                    ? false
                                    : true,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 212, 195, 42),
                                  ),
                                  width: width_halaman,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Text(
                                          "Advanced",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        width: width_halaman,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 16),
                                                child: Text(
                                                    "In this subcription plan, you will get advanced class video tutorials."),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 10),
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: RawMaterialButton(
                                                    onPressed: () {
                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                            "Advanced Subscription",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          content: Text(
                                                              "Would you like to buy Advanced Subscription for \$49.99 ?"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel');
                                                              },
                                                              child: Text(
                                                                  "Cancel"),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                final userUID =
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid;

                                                                final userData =
                                                                    Database.getData(
                                                                        uid:
                                                                            userUID);
                                                                userData.then(
                                                                  (DocumentSnapshot
                                                                      docsnap) {
                                                                    if (docsnap
                                                                        .exists) {
                                                                      final updateUserData =
                                                                          userDatabase(
                                                                        userName: docsnap
                                                                            .get('userName')
                                                                            .toString(),
                                                                        userEmail: docsnap
                                                                            .get('userEmail')
                                                                            .toString(),
                                                                        userSubs:
                                                                            '$sub_state,advanceds',
                                                                        userPic: docsnap
                                                                            .get('userPic')
                                                                            .toString(),
                                                                      );
                                                                      Database.updateData(
                                                                              user: updateUserData,
                                                                              uid: userUID)
                                                                          .whenComplete(() {})
                                                                          .then(
                                                                        (value) {
                                                                          if (mounted) {
                                                                            setState(
                                                                              () {
                                                                                getUserData();
                                                                              },
                                                                            );
                                                                          }
                                                                        },
                                                                      );
                                                                    }
                                                                  },
                                                                );

                                                                Navigator.pop(
                                                                    context,
                                                                    'Buy');
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        "Thank you for buying Advanced Subscription (\$49.99)"),
                                                                  ),
                                                                );
                                                              },
                                                              child:
                                                                  Text("Buy"),
                                                            ),
                                                          ],
                                                        ),
                                                      ).then(
                                                        (value) {
                                                          if (mounted) {
                                                            setState(
                                                              () {
                                                                getUserData();
                                                              },
                                                            );
                                                          }
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .currency_exchange_rounded,
                                                      size: 25,
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(15.0),
                                                    shape: CircleBorder(),
                                                    fillColor: Color.fromARGB(
                                                        255, 212, 195, 42),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      "Thanks For Buying Our Subscription",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),

            //TODO: HAL BEGINNER
            cek_sub.isNotEmpty && cek_sub.contains('beginners')
                ? Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Data(_colRefContentSubs, 'beginners'),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error');
                        } else if (snapshot.hasData || snapshot.data != null) {
                          return Expanded(
                            child: ListView.separated(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot contentDs =
                                    snapshot.data!.docs[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: YtDisplay(ytid: contentDs),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      "Belum Subscribe Beginner",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),

            //TODO: HAL INTERMEDIATE
            cek_sub.isNotEmpty && cek_sub.contains('intermediates')
                ? Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Data(_colRefContentSubs, 'intermediates'),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error');
                        } else if (snapshot.hasData || snapshot.data != null) {
                          return Expanded(
                            child: ListView.separated(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot contentDs =
                                    snapshot.data!.docs[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: YtDisplay(ytid: contentDs),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      "Belum Subscribe Intermediate",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),

            //TODO: HAL ADVANCED
            cek_sub.isNotEmpty && cek_sub.contains('advanceds')
                ? Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Data(_colRefContentSubs, 'advanceds'),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error');
                        } else if (snapshot.hasData || snapshot.data != null) {
                          return Expanded(
                            child: ListView.separated(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot contentDs =
                                    snapshot.data!.docs[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: YtDisplay(ytid: contentDs),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      "Belum Subscribe Advanced",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
