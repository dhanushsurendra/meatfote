import 'package:flutter/material.dart';
import 'package:meatforte/helpers/modal_bottom_sheet.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: Image.asset(
              'assets/images/profile_image.png',
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => ModalBottomSheet.modalBottomSheet(
              context,
              ['Gallery', 'Camera'],
              'Select any one',
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
