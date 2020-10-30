import 'package:circle_app_alpha/UI/Shared/ui_helpers.dart';
import 'package:circle_app_alpha/UI/Widgets/busy_button.dart';
import 'package:circle_app_alpha/ui/Widgets/input_field.dart';
import 'package:circle_app_alpha/UI/Widgets/text_link.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:circle_app_alpha/ViewModels/signin_view_model.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SigninViewModel>.reactive(
    viewModelBuilder : () => SigninViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Image.asset('assets/images/circle.jpg'),
              ),
              InputField(
                placeholder: 'Email',
                controller: emailController,
              ),
              verticalSpaceSmall,
              InputField(
                placeholder: 'Password',
                password: true,
                controller: passwordController,
              ),
              verticalSpaceMedium,
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BusyButton(
                    title: 'Login',
                    busy: model.busy,
                    onPressed: () {
                      model.login(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    },
                  )
                ],
              ),
              verticalSpaceMedium,
              TextLink(
                'Create an Account if you\'re new.',
                onPressed: () {
                  model.navigateToSignUp();
                },
              )
            ],
          ),
        )),
    );
  }
}