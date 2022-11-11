import 'package:anime_wallpaper_hd/Pages/display_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;

  //
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-1229485860316774/1080644894',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myBanner.load();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        bottomNavigationBar: Container(
          child: AdWidget(ad: myBanner),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[800],
          elevation: 0.0,
          actions: [
            IconButton(
                onPressed: () {
                  Share.share(
                      'https://play.google.com/store/apps/details?id=com.example.anime_wallpaper_hd');
                },
                icon: const Icon(
                  Icons.share,
                  color: Colors.white,
                ))
          ],
          title: const Text(
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
  //
  InterstitialAd? interstitialAd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        InterstitialAd.load(
            adUnitId: "ca-app-pub-1229485860316774/1080644894",
            request: AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (ad) {
                interstitialAd = ad;
                interstitialAd!.show();
                interstitialAd!.fullScreenContentCallback =
                    FullScreenContentCallback(
                        onAdFailedToShowFullScreenContent: ((ad, error) {
                  ad.dispose();
                  interstitialAd!.dispose();
                  debugPrint(error.message);
                }), onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                  interstitialAd!.dispose();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DisplayPage(
                                image: widget.image.toString(),
                              )));
                });
              },
              onAdFailedToLoad: (err) {
                debugPrint(err.message);
              },
            ));
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
