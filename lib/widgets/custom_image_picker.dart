import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final _imagePicker = ImagePicker();

  Future _pickImage() async {
    final pickedImageFile = await _imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FittedBox(
          child: Container(

            color: Theme.of(context).primaryColor,
            width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(0.0),
              child: _pickedImage != null?Image(
                fit: BoxFit.contain,
                alignment: Alignment.topRight,
                image: FileImage(_pickedImage)): Container(),
            ),
          ),
        ),
//
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text("Add Image"),
        ),
      ],
    );
  }
}
