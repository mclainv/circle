import 'package:flutter/material.dart';
import 'package:circle_app_alpha/ViewModels/initialization_view_model.dart';
class InitializationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<InitializationViewModel>.withConsumer(
      viewModel: InitializationViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 100,
                child: Image.asset('assets/circle.jpg'),
              ),
              CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Color(0xff19c7c1)),
              )
            ],
          ),
        ),
      ),
    );
  }
}