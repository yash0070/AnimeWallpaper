import 'package:anime_wallpaper_hd/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class DisplayPage extends StatefulWidget {
  String image;
  DisplayPage({required this.image});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  Future<void> setWallpaer(BuildContext context, String path) async {
    var actionSheet = CupertinoActionSheet(
      title: Text("Set as"),
      actions: [
        CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(context).pop("LOCK");
              Fluttertoast.showToast(msg: "Wallpaper Updated");
              int location = WallpaperManager.HOME_SCREEN;
              var file =
                  await DefaultCacheManager().getSingleFile(widget.image);
              var result = await WallpaperManager.setWallpaperFromFile(
                  file.path, location);
            },
            child: const Text("HOME")),
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.of(context).pop("LOCK");
            Fluttertoast.showToast(msg: "Wallpaper Updated");
            int location = WallpaperManager.LOCK_SCREEN;
            var file = await DefaultCacheManager().getSingleFile(widget.image);
            var result = await WallpaperManager.setWallpaperFromFile(
                file.path, location);
          },
          child: const Text("LOCK"),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.of(context).pop("LOCK");
            Fluttertoast.showToast(msg: "Wallpaper Updated");
            int location = WallpaperManager.BOTH_SCREEN;
            var file = await DefaultCacheManager().getSingleFile(widget.image);
            var result = await WallpaperManager.setWallpaperFromFile(
                file.path, location);
          },
          child: const Text("BOTH"),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.of(context).pop("DOwnload");
            Fluttertoast.showToast(msg: "Succesfully Download");
            String url = widget.image.toString();
            await GallerySaver.saveImage(url);
          },
          child: Text("Download"),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            var url = widget.image.toString();
            await Share.shareFiles([url]);
          },
          child: Text("Share"),
        ),
      ],
    );
    var option = await showCupertinoModalPopup(
        context: context, builder: (context) => actionSheet);
    if (option != null) {
      debugPrint(option);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.image.toString()),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkResponse(
              onTap: () async {
                await setWallpaer(context, widget.image);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Set As",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.deepPurple),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
