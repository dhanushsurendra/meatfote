import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/user.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class UserDetailsVerificationScreen extends StatefulWidget {
  final String document;
  final String title;
  final File file;
  final String documentType;

  const UserDetailsVerificationScreen({
    Key key,
    @required this.document,
    @required this.title,
    @required this.documentType,
    this.file,
  }) : super(key: key);

  @override
  _UserDetailsVerificationScreenState createState() =>
      _UserDetailsVerificationScreenState();
}

class _UserDetailsVerificationScreenState
    extends State<UserDetailsVerificationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    File _image;
    final picker = ImagePicker();

    Future<void> getImage(int index) async {
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

        Navigator.of(context).pushReplacement(
          FadePageRoute(
            childWidget: UserDetailsVerificationScreen(
              document: widget.document,
              title: widget.title,
              file: croppedImage,
              documentType: widget.documentType,
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

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            flexibleSpace: CustomAppBar(
              title: widget.title,
              containsBackButton: true,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.document,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: Colors.grey,
                      radius: Radius.circular(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 0.65,
                          decoration: BoxDecoration(
                            color: Color(0xFFCAD1DB).withOpacity(0.2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: Theme.of(context).primaryColor,
                                  size: 35.0,
                                ),
                                onPressed: () => showModalBottomSheet<dynamic>(
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
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: Text(
                                  'Upload high resolution photo for better approval chances.',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              widget.file != null
                                  ? Container(
                                      width: 60.0,
                                      height: 60.0,
                                      child: Image.file(widget.file),
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(height: _isLoading ? 20.0 : 10.0),
                              !_isLoading
                                  ? TextButton(
                                      onPressed: () async {
                                        if (widget.file == null &&
                                            _image == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Select an image to upload',
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              duration:
                                                  const Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        setState(() {
                                          _isLoading = true;
                                        });

                                        try {
                                          await Provider.of<User>(context,
                                                  listen: false)
                                              .uploadDocument(
                                            widget.file,
                                            userId,
                                            documentType: widget.documentType,
                                            document: widget.document,
                                          );

                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.SUCCES,
                                            animType: AnimType.BOTTOMSLIDE,
                                            title: 'Success!',
                                            desc:
                                                'Document uploaded successfully.',
                                            btnOkOnPress: () => {},
                                            btnOkColor:
                                                Theme.of(context).primaryColor,
                                          )..show();

                                          setState(() {
                                            _isLoading = false;
                                          });
                                        } catch (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Something went wrong. Please try again.',
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              duration:
                                                  const Duration(seconds: 1),
                                            ),
                                          );

                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStateColor.resolveWith(
                                          (states) => Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.15),
                                        ),
                                      ),
                                      child: Text(
                                        'Upload document',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 25.0,
                                      height: 25.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                              SizedBox(height: _isLoading ? 23.0 : 10.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
