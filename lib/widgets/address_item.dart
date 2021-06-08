import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/show_dialog.dart';
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/screens/checkout_screen.dart';
import 'package:provider/provider.dart';

class AddressItem extends StatelessWidget {
  final Address address;

  AddressItem({
    Key key,
    @required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
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
                            borderRadius: BorderRadius.circular(100.0),
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
                          () async {
                            try {
                              await Provider.of<Addresses>(context,
                                      listen: false)
                                  .deleteAddress(address.id, userId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Deleted successfully!'),
                                ),
                              );
                            } on HttpException catch (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Something went wrong.'),
                                ),
                              );
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Something went wrong.'),
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
                            borderRadius: BorderRadius.circular(100.0),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Street: ${address.streetAddress}',
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Locality: ${address.locality}',
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Landmark: ${address.landmark}',
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'City: ${address.city} - ${address.pincode.toString()}',
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Time of Delivery: ${address.timeOfDelivery}',
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Contact: ${address.phoneNumber}',
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
