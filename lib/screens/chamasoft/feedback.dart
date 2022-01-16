import 'dart:convert';

import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/providers/auth.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/buttons.dart';
import 'package:chamasoft/widgets/textfields.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FeedBackForm extends StatefulWidget {
  // final RateMyApp rateMyApp;
  const FeedBackForm({/* this.rateMyApp, */ Key key}) : super(key: key);

  @override
  _FeedBackFormState createState() => _FeedBackFormState();
}

class _FeedBackFormState extends State<FeedBackForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final feedbackController = TextEditingController();
  double _appBarElevation = 0;
  ScrollController _scrollController;
  // String info = CustomHelper.getApplicationBuildNumber() as String;

  void _submit(BuildContext context, Auth auth, String groupName) async {
    final String versionCode = await CustomHelper.getApplicationBuildNumber();
    if (_formKey.currentState.validate()) {
      final response = await sendEmail(
          nameController.value.text,
          emailController.value.text,
          subjectController.value.text,
          feedbackController.value.text,
          auth.userName,
          auth.phoneNumber,
          auth.emailAddress,
          groupName,
          versionCode
          // info

          // groupObject.groupName,
          // member.identity,
          );

      if (response == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Message Sent!'), backgroundColor: Colors.green));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ChamasoftSettings(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to send Email!'),
            backgroundColor: Colors.green));
      }

      nameController.clear();
      emailController.clear();
      subjectController.clear();
      feedbackController.clear();
    }
  }

  Future sendEmail(
    String name,
    String subject,
    String email,
    String message,
    String userName,
    String phoneNumber,
    String emailAddress,
    String groupName,
    String versionCode,
    /* String identity */
  ) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_uz5oez5';
    const templateId = 'template_hcs8qyq';
    const userId = 'user_rWgQ8dW5XFBy4itaXX9RF';
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json'
        }, //This line makes sure it works for all platforms.
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_name': name,
            'user_subject': subject,
            'user_email': email,
            'user_message': message,
            'user_phone': phoneNumber,
            'auth_name': userName,
            'auth_email': emailAddress,
            'user_current_group': groupName,
            'app_version': versionCode
          }
        }));
    print("Response is $response");
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    final auth = Provider.of<Auth>(context, listen: false);

    //final currentMember = Provider.of<Groups>(context, listen: true).members;
    return Scaffold(
      key: _scaffoldKey,
      appBar: secondaryPageAppbar(
          context: context,
          title: "Feedback",
          action: () => Navigator.of(context).pop(),
          elevation: _appBarElevation,
          leadingIcon: LineAwesomeIcons.arrow_left),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SingleChildScrollView(
              // physics: BouncingScrollPhysics(),
              // scrollDirection: Axis.vertical,
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  toolTip(
                      context: context,
                      title: "Kindly share your feedback with us.",
                      message: "",
                      showTitle: true),
                  Padding(
                    padding: inputPagePadding,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          subtitle1(text: 'Name', textAlign: TextAlign.start),
                          simpleTextInputField(
                            controller: nameController,
                            context: context,
                            labelText: 'eg. Joh Doe',
                            /*  validator: (nameController) {
                                if (nameController == null ||
                                    nameController == "") {
                                  return "Field required";
                                }
                                return null;
                              } */
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          subtitle1(text: 'Email', textAlign: TextAlign.start),
                          simpleTextInputField(
                            controller: emailController,
                            context: context,
                            labelText: 'eg. my@email.com',
                            /*   validator: (emailController) {
                                if (emailController == null ||
                                    emailController == "") {
                                  return "Field required";
                                }
                                return null;
                              } */
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          subtitle1(
                              text: 'Subject', textAlign: TextAlign.start),
                          simpleTextInputField(
                            controller: subjectController,
                            context: context,
                            labelText: 'eg. My Feedback Subject',
                            /*  validator: (subjectController) {
                                if (subjectController == null ||
                                    subjectController == "") {
                                  return "Field required";
                                }
                                return null;
                              } */
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          subtitle1(
                              text: 'Messages', textAlign: TextAlign.start),
                          Center(
                              child: multilineTextField(
                                  controller: feedbackController,
                                  context: context,
                                  labelText: 'eg. My Feedback',
                                  validator: (feedbackController) {
                                    if (feedbackController == null ||
                                        feedbackController == "") {
                                      return "Field required";
                                    }
                                    return null;
                                  })),
                          SizedBox(
                            height: 10,
                          ),
                          // _isLoading
                          //     ? Padding(
                          //         padding: EdgeInsets.all(10),
                          //         child: Center(
                          //             child: CircularProgressIndicator()),
                          //       )
                          //     :
                          Center(
                              child: Container(
                            child: defaultButton(
                              context: context,
                              text: "SEND",
                              onPressed: () =>
                                  _submit(context, auth, groupObject.groupName),
                            ),
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
