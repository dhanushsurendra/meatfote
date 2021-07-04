import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/user.dart';
import 'package:meatforte/widgets/bottom_navigation.dart';
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
        _isLoading = true;
      });

      try {
        await Provider.of<User>(context, listen: false)
            .uploadDocument(widget.file, userId);

        setState(() {
          _isLoading = false;
        });

        final status =
            Provider.of<User>(context, listen: false).isImageUploadSuccess;

        AwesomeDialog(
          context: context,
          dialogType: status ? DialogType.SUCCES : DialogType.ERROR,
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
          dismissOnBackKeyPress: status ? false : true,
          dismissOnTouchOutside: status ? false : true,
        )..show();
      } on SocketException catch (_) {
        setState(() {
          _isLoading = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error',
          desc: 'Failed to update!',
          btnOkOnPress: () => () {},
          btnOkColor: Theme.of(context).primaryColor,
        )..show();
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
      }
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
            ImageInput(file: widget.file),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Material(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5.0),
                    onTap: widget.file == null
                        ? null
                        : () {
                            checkStatus();
                          },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: Center(
                        child: !_isLoading
                            ? Text(
                                'Upload',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : SizedBox(
                                width: 25.0,
                                height: 25.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
