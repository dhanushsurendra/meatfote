import 'package:flutter/material.dart';
import 'package:meatforte/screens/search_input_screen.dart';

class SearchFieldContainer extends StatelessWidget {
  const SearchFieldContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SearchInputScreen(),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xFFCAD1DB).withOpacity(0.4),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.grey,
              ),
              SizedBox(width: 8.0),
              Text(
                'Search',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
