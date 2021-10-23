import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';

void main() => runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "slnFilter",
    theme: ThemeData(primaryColor: Colors.red),
    home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String fileName;
  List<Filter> filters = presetFiltersList;
  final picker = ImagePicker();
  File? imageFile;

  Future getImage(context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = new File(pickedFile.path);
      fileName = basename(imageFile!.path);
      var image = imageLib.decodeImage(await imageFile!.readAsBytes());
      image = imageLib.copyResize(image!, width: 600);
      Map imagefile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoFilterSelector(
            title: Text("Alper Filters"),
            image: image!,
            filters: presetFiltersList,
            filename: fileName,
            loader: Center(child: CircularProgressIndicator()),
            fit: BoxFit.contain,
          ),
        ),
      );

      if (imagefile != null && imagefile.containsKey('image_filtered')) {
        setState(() {
          imageFile = imagefile['image_filtered'];
          // GallerySaver.saveImage(pickedFile.path);
          GallerySaver.saveImage(imageFile!.path);
        });
        print(imageFile!.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.red, Colors.blue])),
        ),
        title: new Text('Alper Filter'),
      ),
      body: Center(
        child: Container(
          child: imageFile == null
              ? Center(
                  child: new Text(
                    'No image selected.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Colors.grey),
                  ),
                )
              : Image.file(new File(imageFile!.path)),
        ),
      ),
      floatingActionButton: imageFile == null
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.red, Colors.blue],
                ),
                shape: BoxShape.circle,
              ),
              child: FloatingActionButton(
                onPressed: () => getImage(context),
                backgroundColor: Colors.transparent,
                elevation: 0,
                tooltip: 'Pick Image',
                child: new Icon(Icons.add_a_photo),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.red, Colors.blue],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: FloatingActionButton(
                      onPressed: () => getImage(context),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      tooltip: 'Pick Image',
                      child: new Icon(Icons.add_a_photo),
                    ),
                  ),
/*                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.red, Colors.blue],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: FloatingActionButton(
                      onPressed: () => getImage(context),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      tooltip: 'Download Image',
                      child: new Icon(Icons.download_sharp),
                    ),
                  )*/
                ],
              ),
            ),
    );
  }
}

/*
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [Colors.red, Colors.blue],
),
shape: BoxShape.circle,
),*/
