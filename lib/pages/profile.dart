// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_local_variable, unused_field, unnecessary_this, avoid_print, prefer_typing_uninitialized_variables, TODO

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:proyek_uas_guider/pages/profilemodal.dart';
import 'package:proyek_uas_guider/userdata.dart';
import 'package:proyek_uas_guider/widgets/tween.dart';
import 'package:proyek_uas_guider/dbservices.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );

  String sub_state = '';
  List<String> cek_sub = [];

  void getUserData() {
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    final userData = Database.getData(uid: userUID);
    userData.then(
      (DocumentSnapshot docSnap) {
        if (docSnap.exists) {
          String temp = '';
          sub_state = docSnap.get('userSubs').toString();
          filterIsiSubscriptionDatabase();
          _controllerName.text = docSnap.get('userName').toString();
          _controllerEmail.text = docSnap.get('userEmail').toString();
          for(int i=1;i<sub_state.length;i++) {
            temp = temp + sub_state[i];
          }_controllerSubs.text = temp;
          if (_controllerSubs.text == '') {
            _controllerSubs.text = 'No Subs';
          }
          if (mounted) {
            setState(() {
              _tempImg = docSnap.get('userPic').toString();
            });
          }
        } else {
          print('Not Found');
        }
      },
    );
  }

  Future getImage() async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (res == null) {
    } else {
      final path = res.files.single.path;

      FireStorage.updateProfilePic(
              filepath: path, uid: FirebaseAuth.instance.currentUser!.uid)
          .then(
        (value) async {
          final userUID = FirebaseAuth.instance.currentUser!.uid;
          final _UserData = Database.getData(uid: userUID);
          FirebaseStorage storage = FirebaseStorage.instance;
          String url =
              (await storage.ref('users/$userUID').getDownloadURL()).toString();
          _UserData.then(
            (DocumentSnapshot docSnap) {
              if (docSnap.exists) {
                final userData = userDatabase(
                    userName: docSnap.get('userName').toString(),
                    userEmail: docSnap.get('userEmail').toString(),
                    userSubs: docSnap.get('userSubs').toString(),
                    userPic: url);
                Database.updateData(user: userData, uid: userUID)
                    .whenComplete(() {
                  getUserData();
                });
              }
            },
          );
        },
      );
    }
  }

  final _controllerName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerSubs = TextEditingController();
  var _tempImg = '';

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerSubs.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getUserData();
    // TODO: implement initState

    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    var height_stack = MediaQuery.of(context).size.height;
    var width_stack = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              //TODO SignOut Auth
              onTap: () {
                Auth.signOut();
              },
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(40, 255, 255, 255),
                ),
                child: Icon(
                  LineIcons.doorOpen,
                  size: 25,
                  color: Color.fromARGB(225, 255, 255, 255),
                ),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFF171717),
      body: SafeArea(
        bottom: true,
        top: false,
        child: Expanded(
          child: Stack(
            children: [
              //TODO Bg Image
              CachedNetworkImage(
                cacheManager: customCacheManager,
                key: UniqueKey(),
                imageUrl: imageChecker(),
                imageBuilder: (context, imageProvider) => Container(
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.0),
                      ),
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Color.fromARGB(100, 23, 23, 23),
                      Color(0xFF171717),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 125),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  getImage();
                                },
                                //TODO Profile Pic
                                child: CachedNetworkImage(
                                  cacheManager: customCacheManager,
                                  key: UniqueKey(),
                                  imageUrl: imageChecker(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ShakesAnimation(
                          axis: Axis.vertical,
                          offset: 70,
                          curve: Curves.ease,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            //TODO Username
                            child: TextField(
                              focusNode: AlwaysDisabledFocusNode(),
                              readOnly: true,
                              controller: _controllerName,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                      context: context,
                                      builder: (context) => EditProfile(),
                                      bounce: true,
                                      expand: true,
                                      duration: Duration(milliseconds: 1000),
                                    ).then(
                                      (value) {
                                        if (mounted) {
                                          setState(() {
                                            getUserData();
                                          });
                                        }
                                      },
                                    );
                                  },
                                  child: Icon(LineIcons.edit),
                                ),
                                suffixIconColor: Color(0xFF171717),
                                filled: true,
                                fillColor: Color(0xFFe0e0e0),
                                hintText: 'Name',
                                hintStyle: TextStyle(fontSize: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ShakesAnimation(
                          axis: Axis.vertical,
                          offset: 170,
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 1000),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            //TODO Email
                            child: TextField(
                              focusNode: AlwaysDisabledFocusNode(),
                              readOnly: true,
                              controller: _controllerEmail,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFe0e0e0),
                                hintText: 'Email',
                                hintStyle: TextStyle(fontSize: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ShakesAnimation(
                          axis: Axis.vertical,
                          offset: 270,
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 1000),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: TextField(
                              //TODO Subs
                              focusNode: AlwaysDisabledFocusNode(),
                              readOnly: true,
                              controller: _controllerSubs,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFe0e0e0),
                                hintText: 'Subscription',
                                hintStyle: TextStyle(fontSize: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  imageChecker() {
    if (_tempImg != '') {
      return _tempImg;
    } else {
      return 'https://cdn.shopify.com/s/files/1/2198/0277/products/GPW-PW-029_2400x.jpg?v=1649783764';
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
