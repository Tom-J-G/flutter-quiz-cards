import 'package:flutter/material.dart';


//Labels for each field
Widget fieldLabel(data) =>
  Row(
    children: <Widget>[     
      data,       
      Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            color: Colors.grey,
          ),
          )
      ),
    ]
  );