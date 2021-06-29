import 'dart:io';

import 'package:flutter/material.dart';

class ImageInput extends StatelessWidget {
  final File file;

  const ImageInput({
    Key key,
    @required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: file == null
                  ? Center(child: Text('No photo selected'))
                  : Image.file(file),
            ),
          ),
        ],
      ),
    );
  }
}
