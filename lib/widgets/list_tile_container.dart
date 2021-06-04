import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListTileContainer extends StatelessWidget {
  final String title;
  final Function onTap;
  final Icon icon;
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;

  const ListTileContainer({
    Key key,
    @required this.title,
    @required this.onTap,
    @required this.icon,
    @required this.fontSize,
    @required this.fontWeight,
    @required this.letterSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
            color: Colors.black12,
          )
        ],
      ),
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 45.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFEBEBF1),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Center(child: icon),
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        title,
                        softWrap: false,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: fontSize,
                          letterSpacing: letterSpacing,
                          fontWeight: fontWeight,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 20.0,
                    color: Colors.grey[400].withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
