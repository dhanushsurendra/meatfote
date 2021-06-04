// import 'package:flutter/material.dart';
// import 'package:meatforte/animations/fade_page_route.dart';
// import 'package:meatforte/screens/complete_kyc.dart';
// import 'package:meatforte/widgets/button.dart';
// import 'package:pin_code_text_field/pin_code_text_field.dart';

// class OTPScreen extends StatefulWidget {
//   const OTPScreen({Key key}) : super(key: key);

//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   TextEditingController controller = TextEditingController(text: "");
//   String thisText = "";
//   int pinLength = 4;
//   bool hasError = false;
//   String errorMessage;

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 50.0),
//                   Text(
//                     'Verify Phone Number',
//                     style: TextStyle(
//                       fontSize: 30.0,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 20.0),
//                   Text(
//                     'Enter the OTP',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   SizedBox(height: 20.0),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         PinCodeTextField(
//                           autofocus: true,
//                           controller: controller,
//                           defaultBorderColor: Colors.grey,
//                           maxLength: pinLength,
//                           hasError: hasError,
//                           onTextChanged: (text) {
//                             setState(() {
//                               hasError = false;
//                             });
//                           },
//                           pinBoxWidth: MediaQuery.of(context).size.width / 5,
//                           pinBoxHeight: 60,
//                           hasUnderline: false,
//                           wrapAlignment: WrapAlignment.start,
//                           pinBoxDecoration: ProvidedPinBoxDecoration
//                               .underlinedPinBoxDecoration,
//                           pinTextStyle: TextStyle(fontSize: 22.0),
//                           pinTextAnimatedSwitcherTransition:
//                               ProvidedPinBoxTextAnimation.scalingTransition,
//                           pinTextAnimatedSwitcherDuration:
//                               Duration(milliseconds: 300),
//                           keyboardType: TextInputType.number,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Visibility(
//                     child: Text(
//                       "Wrong PIN!",
//                     ),
//                     visible: hasError,
//                   ),
//                   SizedBox(height: 40.0),
//                   Button(
//                     onTap: () => Navigator.of(context).push(
//                       FadePageRoute(
//                         childWidget: CompleteKYC(),
//                       ),
//                     ),
//                     buttonText: 'Verify',
//                   ),
//                   SizedBox(height: 20.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Didn\'t receive OTP? ',
//                         style: TextStyle(
//                           color: Theme.of(context).accentColor,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Text(
//                         'Resend',
//                         style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
