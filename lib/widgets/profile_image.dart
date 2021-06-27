import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/user.dart';
import 'package:meatforte/screens/image_preview_screen.dart';
import 'package:provider/provider.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File _image;
    final picker = ImagePicker();

    String userId = Provider.of<Auth>(context, listen: false).userId;

    Future<void> getImage(int index) async {
      FocusScope.of(context).unfocus();

      final pickedFile = await picker.getImage(
        source: index == 0 ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 20,
      );

      if (pickedFile != null) {
        _image = File(pickedFile.path);
        File croppedImage = await ImageCropper.cropImage(
          sourcePath: _image.path,
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressFormat: ImageCompressFormat.jpg,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Color(0xFFFF0037),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImagePreview(
              file: croppedImage,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No Image Choosen!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 90.0,
          height: 90.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(0.0, 2.0),
                blurRadius: 6.0,
                color: Colors.black12,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Provider.of<User>(context).userImageUrl == null ||
                    Provider.of<User>(context).userImageUrl == ''
                ? Image.asset(
                    'assets/images/profile_image.png',
                  )
                : Image.network(
                    Provider.of<User>(context).userImageUrl,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => showModalBottomSheet<dynamic>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                  height: 180.0,
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      Text(
                        'Select',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ListTile(
                        onTap: () {
                          getImage(0);
                          Navigator.of(context).pop();
                        },
                        title: Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          getImage(1);
                          Navigator.of(context).pop();
                        },
                        title: Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            child: Container(
              width: 35.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(100.0),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 25.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
