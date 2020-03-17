import 'package:flutter/material.dart';

class ChamasoftDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chamasoft Dashboard',
              ),
            ],
          ),
        ),
      ),
    );
  }
}