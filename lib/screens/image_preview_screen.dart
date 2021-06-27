import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/user.dart';
import 'package:meatforte/widgets/bottom_navigation.dart';
import 'package:meatforte/widgets/button.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/image_input.dart';

import 'package:provider/provider.dart';

class ImagePreview extends StatefulWidget {
  static const routeName = '/image-preview-screen';
  final File file;
  const ImagePreview({Key key, this.file}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).userId;

    void checkStatus() async {
      setState(() {
        _isLoading = false;
      });

      final status =
          Provider.of<User>(context, listen: false).isImageUploadSuccess;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: status ? 'Success!' : 'Error!',
        desc: status
            ? 'Profile image updated successfully.'
            : 'Failed to update.',
        btnOkOnPress: () => status
            ? Navigator.of(context).push(
                FadePageRoute(
                  childWidget: BottomNavigation(),
                ),
              )
            : () {},
        btnOkColor: Theme.of(context).primaryColor,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
      )..show();
    }

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            flexibleSpace: CustomAppBar(
              title: 'Image Preview',
              containsBackButton: true,
            ),
          ),
        ),
        body: Column(
          children: [
            ImageInput(filePath: widget.file),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Button(
                buttonText: 'Upload',
                onTap: widget.file == null
                    ? null
                    : () {
                        setState(() {
                          _isLoading = true;
                        });
                        Provider.of<User>(context, listen: false)
                            .uploadProfileImage(widget.file, userId);

                        checkStatus();
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
