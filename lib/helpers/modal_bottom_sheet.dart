import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/screens/personal_verifiacation_screen.dart';

class ModalBottomSheet {
  static modalBottomSheet(
    BuildContext context,
    List<String> listItems,
    String title, [
    bool saveButton = false,
    bool containsRadio = false,
    Function onTap,
  ]) {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: listItems.length * 60.0 + 60,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: saveButton
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.center,
                children: [
                  saveButton
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextButton(
                            onPressed: null,
                            child: Text(
                              '',
                              style: TextStyle(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  saveButton
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                (states) => Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.15),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: !containsRadio
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: listItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              listItems[index],
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              // Navigator.of(context).pop();
                              Navigator.of(context).push(
                                FadePageRoute(
                                  childWidget: PersonalVerificationScreen(
                                    document: title,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : RadioListTileBuilder(
                        listItems: listItems,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RadioListTileBuilder extends StatefulWidget {
  final List listItems;

  RadioListTileBuilder({
    Key key,
    @required this.listItems,
  }) : super(key: key);

  @override
  _RadioListTileBuilderState createState() => _RadioListTileBuilderState();
}

class _RadioListTileBuilderState extends State<RadioListTileBuilder> {
  int _selectedRadio;

  @override
  void initState() {
    super.initState();
    _selectedRadio = 0;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.listItems.length,
      itemBuilder: (BuildContext context, int index) {
        return RadioListTile(
          toggleable: true,
          selected: true,
          title: Text(widget.listItems[index]),
          value: index,
          tileColor: Theme.of(context).primaryColor,
          groupValue: _selectedRadio,
          onChanged: (value) {
            setState(() {
              _selectedRadio = value;
            });
          },
        );
      },
    );
  }
}
