import 'package:flutter/material.dart';
import 'package:meatforte/screens/profile_screen.dart';
import 'package:meatforte/widgets/business_details.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/personal_details.dart';

class CompleteKYC extends StatefulWidget {
  const CompleteKYC({Key key}) : super(key: key);

  @override
  _CompleteKYCState createState() => _CompleteKYCState();
}

class _CompleteKYCState extends State<CompleteKYC> with SingleTickerProviderStateMixin {

  TabController _tabController;

  Widget _contentList = PersonalDetails();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _changeTabContent(int index) {
    switch (index) {
      case 0:
        setState(() {
          _contentList = PersonalDetails();
        });
        break;
      case 1:
        setState(() {
          _contentList = BusinessDetails();
        });
        break;
      default:
        setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            flexibleSpace: CustomAppBar(
              title: 'Complete KYC',
              containsBackButton: true,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 3.0,
                    controller: _tabController,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).accentColor,
                    onTap: (value) => _changeTabContent(value),
                    tabs: [
                      Tab(text: 'Profile'),
                      Tab(text: 'Business'),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                _contentList,
              ],
            ),
          ),
        ),
      ),
    );
  }
}