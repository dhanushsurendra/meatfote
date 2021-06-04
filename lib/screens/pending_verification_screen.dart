import 'package:flutter/material.dart';
import 'package:share/share.dart';

class PendingVerificationScreen extends StatelessWidget {
  const PendingVerificationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Verification Pending!',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              child: Image.asset('assets/images/waiting.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Your documents are under verification. We will update you within 24 hours. We appreciate your patience.',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () async => await Share.share('https://www.xnxx.com'),
              child: Text(
                'Share our love',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
