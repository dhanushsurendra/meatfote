import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/helpers/show_dialog.dart';
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/team_members.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/empty_image.dart';
import 'package:meatforte/widgets/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AddTeamMemberScreen extends StatefulWidget {
  const AddTeamMemberScreen({Key key}) : super(key: key);

  @override
  _AddTeamMemberScreenState createState() => _AddTeamMemberScreenState();
}

class _AddTeamMemberScreenState extends State<AddTeamMemberScreen> {
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> _getTeamMembers(String userId) async {
    await Provider.of<TeamMembers>(context, listen: false)
        .fetchTeamMembers(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            flexibleSpace: CustomAppBar(
              title: 'Add Team Member',
              containsBackButton: true,
            ),
          ),
        ),
        body: FutureBuilder(
          future: Provider.of<TeamMembers>(context, listen: false)
              .fetchTeamMembers(userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          color: Colors.grey[300],
                        ),
                      );
                    },
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return RefreshIndicator(
                color: Theme.of(context).primaryColor,
                onRefresh: () => _getTeamMembers(userId),
                child: ErrorHandler(
                  message: 'Something went wrong. Please try again.',
                  heightPercent: 0.823,
                ),
              );
            }

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20.0),
                    FontHeading(text: 'Owner'),
                    SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 4.0,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Provider.of<TeamMembers>(context, listen: false)
                                  .ownerName,
                            ),
                            Text(
                              Provider.of<TeamMembers>(context, listen: false)
                                  .ownerPhoneNumber,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FontHeading(text: 'Team Members'),
                    SizedBox(height: 10.0),
                    Provider.of<TeamMembers>(context).teamMembers.length == 0
                        ? EmptyImage(
                            message: 'No team memebers yet. Start adding some!',
                            imageUrl: 'assets/images/empty.png',
                            heightPercent: 0.6,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                Provider.of<TeamMembers>(context, listen: false)
                                    .teamMembers
                                    .length,
                            itemBuilder: (BuildContext context, int index) {
                              final TeamMember teamMember =
                                  Provider.of<TeamMembers>(context,
                                          listen: false)
                                      .teamMembers[index];

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 4.0,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(teamMember.name),
                                      Row(
                                        children: [
                                          Text(teamMember.phoneNumber),
                                          SizedBox(width: 16.0),
                                          GestureDetector(
                                            onTap: () => ShowDialog.showDialog(
                                              context,
                                              DialogType.WARNING,
                                              'Confirm delete',
                                              'Are you sure you want to delete this team memeber?',
                                              () async {
                                                try {
                                                  await Provider.of<
                                                      TeamMembers>(
                                                    context,
                                                    listen: false,
                                                  ).deleteTeamMember(
                                                    teamMember.id,
                                                    userId,
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Deleted successfully!',
                                                      ),
                                                      duration: const Duration(
                                                        seconds: 1,
                                                      ),
                                                    ),
                                                  );
                                                } on HttpException catch (_) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Something went wrong.',
                                                      ),
                                                    ),
                                                  );
                                                } catch (error) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Something went wrong.',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              true,
                                              () {},
                                            ),
                                            child: Container(
                                              width: 35.0,
                                              height: 35.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  100.0,
                                                ),
                                                color: Color(0xFFEBEBF1),
                                              ),
                                              child: Icon(
                                                Icons.delete_outline,
                                                size: 22.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddMember(
              userId: userId,
            ),
          ),
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}

class AddMember extends StatefulWidget {
  final String userId;

  AddMember({
    Key key,
    @required this.userId,
  }) : super(key: key);

  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();

  bool _isLoading = false;

  Future<void> _onFormSubmitted() async {
    FocusScope.of(context).unfocus();

    var isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<TeamMembers>(context, listen: false).addTeamMember(
        widget.userId,
        _nameController.text,
        _phoneNumberController.text,
      );

      AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Succes',
          desc: 'Team memeber added successfully!',
          showCloseIcon: true,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          btnCancelOnPress: null,
          btnOkOnPress: () {},
          btnOkColor: Theme.of(context).primaryColor,
          onDissmissCallback: () {
            Navigator.of(context).pop();
          })
        ..show();

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      var errorMessage = 'Something went wrong!';

      if (error.message != null) {
        errorMessage = error.message;
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error',
        desc: errorMessage,
        showCloseIcon: true,
        btnOkColor: Theme.of(context).primaryColor,
      )..show();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      FontHeading(text: 'Name'),
                      SizedBox(height: 10.0),
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            borderSide: BorderSide.none,
                          ),
                          errorMaxLines: 2,
                          fillColor: Color(0xFFCAD1DB).withOpacity(.45),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 10.0,
                          ),
                        ),
                        validator: (value) {
                          if (value.length <= 3) {
                            return 'Name should be greater than 3 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      FontHeading(text: 'Phone Number'),
                      SizedBox(height: 10.0),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFCAD1DB).withOpacity(.45),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Text(
                                  '+91',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                cursorColor: Theme.of(context).primaryColor,
                                focusNode: _phoneNumberFocusNode,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  fillColor: Color(0xFFCAD1DB).withOpacity(.45),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal: 10.0,
                                  ),
                                ),
                                controller: _phoneNumberController,
                                validator: (value) {
                                  if (value.length < 10 ||
                                      value.isEmpty ||
                                      value.length > 10) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Material(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(5.0),
                            onTap: _onFormSubmitted,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              child: Center(
                                child: !_isLoading
                                    ? Text(
                                        'Add Member',
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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
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
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
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
