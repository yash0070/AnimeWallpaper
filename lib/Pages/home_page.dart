import 'package:anime_wallpaper_hd/Pages/display_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[800],
          elevation: 0.0,
          title: Text(
            "Anime HD Wallpapers",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('wallpapers').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            childAspectRatio: 0.75),
                    itemBuilder: (context, index) {
                      return WallpaerCart(
                        image: snapshot.data!.docs[index]['url'],
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}

class WallpaerCart extends StatefulWidget {
  String? title, image;

  WallpaerCart({this.title, this.image});

  @override
  State<WallpaerCart> createState() => _WallpaerCartState();
}

class _WallpaerCartState extends State<WallpaerCart> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayPage(
                      image: widget.image.toString(),
                    )));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.image.toString()),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
