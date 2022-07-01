// ignore_for_file: prefer_const_constructors, TODO, non_constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyek_uas_guider/dbservices.dart';

import '../widgets/ytdisplay.dart';

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  bool hasPressed1 = true;
  bool hasPressed2 = false;
  Timer? _debounce;

  final searchTitle = TextEditingController();

  @override
  void initState() {
    searchTitle.addListener(onSearch);
    super.initState();
  }

  @override
  void dispose() {
    searchTitle.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Stream<QuerySnapshot<Object?>> Data(
      CollectionReference<Object?> colRefContentSearch) {
    if (mounted) {
      setState(() {});
    }
    return Database.getContent(colRefContentSearch);
  }

  Stream<QuerySnapshot<Object?>> onSearch() {
    if (mounted) {
      setState(() {});
    }
    return Database.getSearch(searchTitle.text, hasPressed1, hasPressed2);
  }

  Color fungsiWarna1(Set<MaterialState> states) {
    if (hasPressed1 == false) {
      return Colors.black.withOpacity(.1);
    } else {
      return Color.fromARGB(15, 224, 224, 224);
    }
  }

  Color fungsiWarna2(Set<MaterialState> states) {
    if (hasPressed2 == false) {
      return Colors.black.withOpacity(.1);
    } else {
      return Color.fromARGB(15, 224, 224, 224);
    }
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (mounted) {
          setState(
            () {
              onSearch();
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171717),
      appBar: AppBar(
        title: Text('Search for Videos'),
        centerTitle: true,
        backgroundColor: Color(0xFF171717),
      ),
      body: SafeArea(
        child: Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables

              //Label Search
              children: [
                //TODO: SearchBar
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextField(
                    onChanged: _onSearchChanged,
                    autofocus: false,
                    controller: searchTitle,
                    decoration: InputDecoration(
                      labelText: "Search For Songs",
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffix: GestureDetector(
                        onTap: () {
                          searchTitle.clear();
                        },
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                //Filter
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Row(
                    children: [
                      //TODO: Filter Title
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (mounted) {
                              setState(
                                () {
                                  hasPressed1 = !hasPressed1;
                                  hasPressed2 = !hasPressed2;
                                },
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(fungsiWarna1),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "Title",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      //TODO: Filter Difficulty
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: ElevatedButton(
                            onPressed: () {
                              if (mounted) {
                                setState(
                                  () {
                                    hasPressed2 = !hasPressed2;
                                    hasPressed1 = !hasPressed1;
                                  },
                                );
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        fungsiWarna2),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                )),
                            child: Text(
                              "Difficulty",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
                //TODO: StreamBuilder
                StreamBuilder<QuerySnapshot>(
                  stream: onSearch(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error');
                    } else if (snapshot.hasData || snapshot.data != null) {
                      // print(snapshot.data!.docs.length);
                      return Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            DocumentSnapshot contentDs =
                                snapshot.data!.docs[index];

                            return YtDisplay(ytid: contentDs);
                          },
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(height: 10);
                          },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// //Empty background
//               Container(
//                 child: Center(
//                   child: Column(
//                     children: [
//                       Image.asset("lib/assets/images/search.png",
//                       width: 200, height: 200),
//                       Text("No videos found", 
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                       Text("Try searching for a different video",
//                       style: TextStyle(color: Colors.white))
//                       ] 
//                     ),
//                 )
//               )