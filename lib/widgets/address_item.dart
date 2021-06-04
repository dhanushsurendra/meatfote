import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/show_dialog.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/screens/checkout_screen.dart';
import 'package:provider/provider.dart';

class AddressItem extends StatefulWidget {
  final String type;

  AddressItem({
    Key key,
    @required this.type,
  }) : super(key: key);

  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount:
            Provider.of<Addresses>(context, listen: false).addresses.length,
        itemBuilder: (BuildContext context, int index) {
          final Address address =
              Provider.of<Addresses>(context, listen: false).addresses[index];
          return widget.type == 'MANAGE'
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                address.businessName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.of(context).push(
                                      FadePageRoute(
                                        childWidget: CheckoutScreen(
                                          title: 'Edit Address',
                                          address:
                                              Provider.of<Addresses>(context, listen: false)
                                                  .getAddress(address.id),
                                          buttonText: 'Continue',
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: Color(0xFFEBEBF1),
                                      ),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        size: 22.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                  InkWell(
                                    onTap: () => ShowDialog.showDialog(
                                      context,
                                      DialogType.WARNING,
                                      'Confirm delete',
                                      'Are you sure you want to delete this address?',
                                      () {},
                                      true,
                                      () {},
                                    ),
                                    child: Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
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
                          SizedBox(height: 10.0),
                          Text(
                            address.streetAddress +
                                '\n${address.locality}, ${address.landmark}, ${address.city} - ${address.pincode.toString()}, \nTime of Delivery: ${address.timeOfDelivery} \n ${address.phoneNumber}',
                            style: TextStyle(
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                address.businessName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).push(
                                  FadePageRoute(
                                    childWidget: CheckoutScreen(
                                      title: 'Edit Address',
                                      address: Provider.of<Addresses>(context, listen: false)
                                          .getAddress(address.id),
                                      buttonText: 'Update',
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: 35.0,
                                  height: 35.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Color(0xFFEBEBF1),
                                  ),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    size: 22.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  address.streetAddress +
                                      '\n${address.locality}, \n${address.landmark}, \n${address.city} - ${address.pincode.toString()}, \nTime of Delivery: ${address.timeOfDelivery} \n ${address.phoneNumber}',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                              Radio(
                                toggleable: true,
                                value: index,
                                groupValue: _selectedIndex,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _selectedIndex = value;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );

          // SizedBox(height: 10.0),
        },
      ),
    );
  }
}
