import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget Offline() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(top: 16, left: 8),
      child: Row(
        children: const [
          Icon(
            Icons.wifi_off,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              "you are offline",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
