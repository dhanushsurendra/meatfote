import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/search.dart';
import 'package:meatforte/screens/search_items_screen.dart';
import 'package:provider/provider.dart';

class SearchInputScreen extends StatefulWidget {
  const SearchInputScreen({Key key}) : super(key: key);

  @override
  _SearchInputScreenState createState() => _SearchInputScreenState();
}

class _SearchInputScreenState extends State<SearchInputScreen> {
  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();

    void _getSearchQuery(String value) {
      Provider.of<Search>(context, listen: false).getSearchQuery(value);
    }

    void _clearSearchQuery() {
      Provider.of<Search>(context, listen: false).clearSearchQuery();
      setState(() {
        _searchController.text = '';
      });
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0.0, 2.0),
                blurRadius: 6.0,
                color: Colors.black12,
              ),
            ],
          ),
          child: Center(
            child: TextField(
              controller: _searchController,
              cursorColor: Theme.of(context).primaryColor,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFCAD1DB),
                  fontSize: 18.0,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFFCAD1DB),
                  size: 25.0,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Color(0xFFCAD1DB),
                    size: 25.0,
                  ),
                  onPressed: _clearSearchQuery,
                ),
                border: InputBorder.none,
              ),
              onChanged: _getSearchQuery,
              onSubmitted: (String value) {
                if (value.isEmpty) {
                  return;
                }
                Navigator.of(context).push(
                  FadePageRoute(
                    childWidget: SearchItemsScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
