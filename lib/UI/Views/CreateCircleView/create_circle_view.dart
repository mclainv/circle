import 'package:circle_app_alpha/Models/circle.dart';
import 'package:circle_app_alpha/ui/shared/ui_helpers.dart';
import 'package:circle_app_alpha/ui/widgets/input_field.dart';
import 'package:circle_app_alpha/UI/Views/CreateCircleView/create_circle_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateCircleView extends StatelessWidget {

  final nameController = TextEditingController();
  final memberUsernameController = TextEditingController();
  final Circle edittingCircle;

  CreateCircleView({Key key, this.edittingCircle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateCircleViewModel>.reactive(
      viewModelBuilder: () => CreateCircleViewModel(),
      onModelReady: (model) {
        // update the text in the controller
        nameController.text = edittingCircle?.name ?? '';

        memberUsernameController.text = edittingCircle?.name ?? '';

        model.setEdittingCircle(edittingCircle);
      },
      builder: (context, model, child) => Scaffold(
          floatingActionButton: FloatingActionButton(
            child: !model.busy
                ? Icon(Icons.add)
                : CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
            onPressed: () { 
              if (!model.busy) {
                model.createCircle(name: nameController.text, memberUsername: memberUsernameController.text);
              }
            },
            backgroundColor:
            !model.busy ? Theme.of(context).primaryColor : Colors.grey[600],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                verticalSpace(40),
                Text(
                  'Create Circle',
                  style: TextStyle(fontSize: 26),
                ),
                verticalSpaceMedium,
                InputField(
                  placeholder: 'Name of the Circle',
                  controller: nameController,
                ),
                verticalSpaceMedium,
                Text('Who would you like to invite?'),
                verticalSpaceSmall,
                InputField(
                  placeholder: "Friend's username",
                  controller: memberUsernameController,
                ),
//                Container(
//                  height: 250,
//                  decoration: BoxDecoration(
//                      color: Colors.grey[200],
//                      borderRadius: BorderRadius.circular(10)),
//                  alignment: Alignment.center,
//                  child: Text(
//                    'Tap to add Circle image',
//                    style: TextStyle(color: Colors.grey[400]),
//                  ),
//                )
              ],
            ),
          )),
    );
  }
}