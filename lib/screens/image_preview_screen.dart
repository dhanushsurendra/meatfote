import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/widgets/bottom_navigation.dart';
import 'package:meatforte/widgets/button.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/image_input.dart';

import 'package:provider/provider.dart';

class ImagePreview extends StatelessWidget {
  static const routeName = '/image-preview-screen';
  final File filePath;
  const ImagePreview({Key key, this.filePath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).userId;

    // void checkStatus() async {
    //   final status =
    //       Provider.of<Auth>(context, listen: false).isImageUploadSuccess;
    //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: status
    //           ? Text('Successfully updated')
    //           : Text('Successfully updated'),
    //     ),
    //   );
    // }

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
            ImageInput(filePath: filePath),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Button(
                buttonText: 'Upload',
                onTap: filePath == null
                    ? null
                    : () {
                        // Provider.of<Auth>(context, listen: false)
                        //     .uploadProfileImage(userId, filePath);

                        // checkStatus();

                        Navigator.of(context).pushReplacementNamed(
                          BottomNavigation.routeName,
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
