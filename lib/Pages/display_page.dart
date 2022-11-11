import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';

class DisplayPage extends StatefulWidget {
  String image;
  DisplayPage({required this.image});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
//
  bool isSet = false;

  Future<void> setWallpaer(BuildContext context, String path) async {
    var actionSheet = CupertinoActionSheet(
      title: const Text("Set as"),
      actions: [
        CupertinoActionSheetAction(
            onPressed: () async {
              setState(() {
                isSet = false;
              });
              Navigator.of(context).pop("Home");
              Fluttertoast.showToast(msg: "Wallpaper Updated as Home Screen");
              int location = WallpaperManager.HOME_SCREEN;
              var file =
                  await DefaultCacheManager().getSingleFile(widget.image);
              var result = await WallpaperManager.setWallpaperFromFile(
                  file.path, location);
            },
            child: const Text("HOME")),

        //
        CupertinoActionSheetAction(
          onPressed: () async {
            setState(() {
              isSet = false;
            });
            Navigator.of(context).pop("Lock");
            Fluttertoast.showToast(msg: "Wallpaper Updated as Lock Screen ");
            int location = WallpaperManager.LOCK_SCREEN;
            var file = await DefaultCacheManager().getSingleFile(widget.image);
            var result = await WallpaperManager.setWallpaperFromFile(
                file.path, location);
          },
          child: const Text("LOCK"),
        ),

        //
        CupertinoActionSheetAction(
          onPressed: () async {
            setState(() {
              isSet = false;
            });
            Navigator.of(context).pop("Both");
            Fluttertoast.showToast(msg: "Wallpaper Updated as Both Screen");
            int location = WallpaperManager.BOTH_SCREEN;
            var file = await DefaultCacheManager().getSingleFile(widget.image);
            var result = await WallpaperManager.setWallpaperFromFile(
                file.path, location);
          },
          child: const Text("BOTH"),
        ),

        //
        CupertinoActionSheetAction(
          onPressed: () async {
            setState(() {
              isSet = false;
            });
            Navigator.of(context).pop("DOwnload");
            Fluttertoast.showToast(msg: "Succesfully Download");
            String url = widget.image.toString();
            await GallerySaver.saveImage(url);
          },
          child: const Text("Download"),
        ),

        //
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
            opacity: isSet ? 0.5 : 1,
            image: NetworkImage(widget.image.toString()),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkResponse(
              onTap: () async {
                setState(() {
                  isSet = true;
                });
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
