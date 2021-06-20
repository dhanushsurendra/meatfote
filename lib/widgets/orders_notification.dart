import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/notification.dart';
import 'package:meatforte/screens/order_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class OrdersNotification extends StatefulWidget {
  const OrdersNotification({Key key}) : super(key: key);

  @override
  _OrdersNotificationState createState() => _OrdersNotificationState();
}

class _OrdersNotificationState extends State<OrdersNotification> {
  IO.Socket socket;
  String userid = "";

  @override
  void initState() {
    super.initState();
    //IO.Socket socket;
    socket = IO.io(
      'http://192.168.0.8:3000',
      <String, dynamic>{
        'transports': ['websocket']
      },
    );

    socket.onConnect((data) {
      print('connect');
      userid = socket.id;
      print("id: " + userid);
      socket.on('carrito:all', (data) {
        print("mensaje: " + data.toString());
      });
    });

    //socket.emit('carrito:all', {'id': userid});
    socket.on('carrito:all', (data) {
      print("message " + data.toString());
    });
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: Provider.of<Notifications>(context, listen: false)
            .activities
            .length,
        itemBuilder: (BuildContext context, int index) {
          final NotificationItem orders =
              Provider.of<Notifications>(context, listen: false)
                  .activities[index];
          if (orders.type == 'ORDERS') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () => Navigator.of(context).push(
                    FadePageRoute(
                      childWidget: OrderDetailsScreen(
                        title: 'Order Details',
                        isOrderSummary: false,
                        hasCancelOrder: false,
                        addressId: orders.id,
                      ),
                    ),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .10,
                    width: double.infinity,
                    color: orders.read
                        ? Colors.transparent
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Payment update on Order: #${orders.orderId}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              orders.subTitle,
                              maxLines: 3,
                              softWrap: true,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
