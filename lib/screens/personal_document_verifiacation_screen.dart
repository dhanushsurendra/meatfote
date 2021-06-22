import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meatforte/helpers/modal_bottom_sheet.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';

class UserDetailsVerificationScreen extends StatelessWidget {
  final String document;
  final String title;

  const UserDetailsVerificationScreen({
    Key key,
    @required this.document,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            flexibleSpace: CustomAppBar(
              title: title,
              containsBackButton: true,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: Colors.grey,
                  radius: Radius.circular(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.6,
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
                            onPressed: () =>
                                ModalBottomSheet.modalBottomSheet(
                              context,
                              ['Camera', 'Gallery'],
                              'Choose Action',
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            child: Text(
                              'Upload high resolution photo for better approval chances',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
