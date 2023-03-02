import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tryapp/Assesment/newassesment/newassesmentbase.dart';
import 'package:tryapp/CompleteAssessment/completeAssessmentBase.dart';
import 'package:tryapp/Patient_Caregiver_Family/Dashboard/reportui.dart';
import 'package:tryapp/Therapist/Dashboard/ViewFeedbackBase.dart';
import 'package:tryapp/Therapist/Dashboard/addPatientDirectly.dart';
import 'package:tryapp/Therapist/Dashboard/detailedScreen.dart';
import 'package:tryapp/Therapist/Dashboard/shareApp.dart';
import 'package:tryapp/Therapist/Dashboard/therapistpro.dart';
import 'package:tryapp/constants.dart';
import 'package:tryapp/main.dart';
import 'package:tryapp/splash/assesment.dart';
import 'package:tryapp/viewPhoto.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TherapistUI extends StatefulWidget {
  @override
  _TherapistUIState createState() => _TherapistUIState();
}

class _TherapistUIState extends State<TherapistUI> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  // FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  User curuser;
  var fname, lname, address, userFirstName, userLastName, curUid, patientUid;
  String imgUrl = "";
  List<Map<String, dynamic>> list = [];
  int sum = 0;
  double rating = 0.0;
  bool admin = false;
  bool beginAssessmentStatus = false;
  bool recommendationStatus = false;
  List<String> requestedPatientNames = [];
  List<String> recommendationPatientNames = [];
  List<String> finishedPatientNames = [];
  List<String> cmPatientNames = [];
  List<String> cmNames = [];
  String dialogMessage;

  @override
  void initState() {
    super.initState();
    setImage();
    getUserDetails();
    getCurrentUid();
    getFeedback();

    // if (requestedPatientNames.isNotEmpty &&
    //     recommendationPatientNames.isNotEmpty &&
    //     finishedPatientNames.isNotEmpty &&
    //     cmPatientNames.isNotEmpty &&
    //     cmNames.isNotEmpty) {
    //   dialogMessage =
    //       'You can now begin assessment for $requestedPatientNames.\nProvide Recommendation for the assessment of $recommendationPatientNames & $finishedPatientNames.\n$cmNames has conducted assessment for $cmPatientNames respectively. Please, provide recommendation on the same.';
    // } else if (requestedPatientNames.isNotEmpty &&
    //     recommendationPatientNames.isNotEmpty &&
    //     finishedPatientNames.isNotEmpty) {
    //   dialogMessage =
    //       'You can now begin assessment for $requestedPatientNames.\nProvide Recommendation for the assessment of $recommendationPatientNames & $finishedPatientNames.';
    // } else if (requestedPatientNames.isNotEmpty &&
    //     recommendationPatientNames.isNotEmpty &&
    //     cmPatientNames.isNotEmpty &&
    //     cmNames.isNotEmpty) {
    //   dialogMessage =
    //       'You can now begin assessment for $requestedPatientNames.\nProvide Recommendation for the assessment of $recommendationPatientNames.\n$cmNames has conducted assessment for $cmPatientNames respectively. Please, provide recommendation on the same.';
    // } else if (requestedPatientNames.isNotEmpty &&
    //     finishedPatientNames.isNotEmpty &&
    //     cmPatientNames.isNotEmpty &&
    //     cmNames.isNotEmpty) {
    //   dialogMessage =
    //       'You can now begin assessment for $requestedPatientNames.\nProvide Recommendation for the assessment of $finishedPatientNames.\n$cmNames has conducted assessment for $cmPatientNames respectively. Please, provide recommendation on the same.';
    // } else if (recommendationPatientNames.isNotEmpty &&
    //     finishedPatientNames.isNotEmpty &&
    //     cmPatientNames.isNotEmpty &&
    //     cmNames.isNotEmpty) {
    //   dialogMessage =
    //       '\nProvide Recommendation for the assessment of $recommendationPatientNames & $finishedPatientNames.\n$cmNames has conducted assessment for $cmPatientNames respectively. Please, provide recommendation on the same.';
    // } else if (requestedPatientNames.isNotEmpty &&
    //     recommendationPatientNames.isNotEmpty) {
    //   dialogMessage =
    //       'You can now begin assessment for $requestedPatientNames.\nProvide Recommendation for the assessment of $recommendationPatientNames.';
    // } else if (requestedPatientNames.isNotEmpty &&
    //     finishedPatientNames.isNotEmpty) {
    //   dialogMessage =
    //       'You can now begin assessment for $requestedPatientNames.\nProvide Recommendation for the assessment of $finishedPatientNames.';
    // } else if (requestedPatientNames.isNotEmpty &&
    //     cmPatientNames.isNotEmpty &&
    //     cmNames.isNotEmpty) {
    //   dialogMessage =
    //       'You can now begin assessment for $requestedPatientNames.\n$cmNames has conducted assessment for $cmPatientNames respectively. Please, provide recommendation on the same.';
    // } else if (recommendationPatientNames.isNotEmpty &&
    //     finishedPatientNames.isNotEmpty) {
    //   dialogMessage =
    //       'Provide Recommendation for the assessment of $recommendationPatientNames & $finishedPatientNames.';
    // } else if (recommendationPatientNames.isNotEmpty &&
    //     cmPatientNames.isNotEmpty &&
    //     cmNames.isNotEmpty) {
    //   dialogMessage =
    //       'Provide Recommendation for the assessment of $recommendationPatientNames.\n$cmNames has conducted assessment for $cmPatientNames respectively. Please, provide recommendation on the same.';
    // } else if (finishedPatientNames.isNotEmpty &&
    //     cmPatientNames.isNotEmpty &&
    //     cmNames.isNotEmpty) {
    //   dialogMessage =
    //       'Provide Recommendation for the assessment of $finishedPatientNames.\n$cmNames has conducted assessment for $cmPatientNames respectively. Please, provide recommendation on the same.';
    // } else if (requestedPatientNames.isNotEmpty) {
    //   dialogMessage =
    //       'You can now begin assessment for $requestedPatientNames.';
    // } else if (recommendationPatientNames.isNotEmpty) {
    //   dialogMessage =
    //       'Provide Recommendation for the assessment of $recommendationPatientNames.';
    // } else if (finishedPatientNames.isNotEmpty) {
    //   dialogMessage =
    //       'Provide Recommendation for the assessment of $finishedPatientNames.';
    // } else if (cmPatientNames.isNotEmpty && cmNames.isNotEmpty) {
    //   dialogMessage =
    //       '$cmNames has conducted assessment for $cmPatientNames respectively. Please, provide recommendation on the same';
    // }

    if (!kIsWeb) {
      Future.delayed(Duration(seconds: 30), () async {
        if (requestedPatientNames.isNotEmpty &&
            recommendationPatientNames.isNotEmpty &&
            finishedPatientNames.isNotEmpty &&
            cmPatientNames.isNotEmpty &&
            cmNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Attention!"),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('You can now begin assessment for',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: requestedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${requestedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: recommendationPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${recommendationPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: finishedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${finishedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text(
                          '\n$cmNames has conducted assessment for $cmPatientNames. Please, provide recommendation on the same',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (requestedPatientNames.isNotEmpty &&
            recommendationPatientNames.isNotEmpty &&
            finishedPatientNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Attention!"),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('You can now begin assessment for',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: requestedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${requestedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: recommendationPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${recommendationPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: finishedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${finishedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (requestedPatientNames.isNotEmpty &&
            recommendationPatientNames.isNotEmpty &&
            cmPatientNames.isNotEmpty &&
            cmNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Attention!"),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('You can now begin assessment for',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: requestedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${requestedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: recommendationPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${recommendationPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text(
                          '\n$cmNames has conducted assessment for $cmPatientNames. Please, provide recommendation on the same',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (requestedPatientNames.isNotEmpty &&
            finishedPatientNames.isNotEmpty &&
            cmPatientNames.isNotEmpty &&
            cmNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Attention!"),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('You can now begin assessment for',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: requestedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${requestedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: finishedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${finishedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text(
                          '\n$cmNames has conducted assessment for $cmPatientNames. Please, provide recommendation on the same',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (recommendationPatientNames.isNotEmpty &&
            finishedPatientNames.isNotEmpty &&
            cmPatientNames.isNotEmpty &&
            cmNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Attention!"),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: recommendationPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${recommendationPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: finishedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${finishedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text(
                          '\n$cmNames has conducted assessment for $cmPatientNames. Please, provide recommendation on the same',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (requestedPatientNames.isNotEmpty &&
            recommendationPatientNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Attention!"),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('You can now begin assessment for',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: requestedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${requestedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: recommendationPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${recommendationPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (requestedPatientNames.isNotEmpty &&
            finishedPatientNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Attention!"),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('You can now begin assessment for',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: requestedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${requestedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: finishedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${finishedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (requestedPatientNames.isNotEmpty &&
            cmPatientNames.isNotEmpty &&
            cmNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Attention!"),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('You can now begin assessment for',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: requestedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${requestedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text(
                          '\n$cmNames has conducted assessment for $cmPatientNames. Please, provide recommendation on the same',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (recommendationPatientNames.isNotEmpty &&
            cmPatientNames.isNotEmpty &&
            cmNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Attention!"),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: recommendationPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${recommendationPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text(
                          '\n$cmNames has conducted assessment for $cmPatientNames. Please, provide recommendation on the same',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (recommendationPatientNames.isNotEmpty &&
            finishedPatientNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Attention!"),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: recommendationPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${recommendationPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: finishedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${finishedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (recommendationPatientNames.isNotEmpty &&
            cmPatientNames.isNotEmpty &&
            cmNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Attention!"),
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('\nProvide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: recommendationPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${recommendationPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                      Text(
                          '\n$cmNames has conducted assessment for $cmPatientNames. Please, provide recommendation on the same',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (requestedPatientNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("New Assignment"),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('You can now begin assessment for',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: requestedPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${requestedPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (recommendationPatientNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Provide Recommendations"),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Provide Recommendation for the assessment of',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: recommendationPatientNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '${index + 1}. ${recommendationPatientNames[index]}',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else if (cmPatientNames.isNotEmpty && cmNames.isNotEmpty) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Provide Recommendations"),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          '\n$cmNames has conducted assessment for $cmPatientNames. Please, provide recommendation on the same',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      });
    }
  }

  getFeedback() async {
    final User useruid = _auth.currentUser;
    await firestoreInstance
        .collection("users")
        .doc(useruid.uid)
        .get()
        .then((value) {
      if (value.data().containsKey("feedback")) {
        if (value.data()["feedback"] != null &&
            value.data()["feedback"] != "") {
          setState(() {
            list = List<Map<String, dynamic>>.generate(
                value.data()["feedback"].length,
                (int index) => Map<String, dynamic>.from(
                    value.data()["feedback"].elementAt(index)));
          });
          for (var i = 0; i < list.length; i++) {
            sum += list[i]["rating"];
          }
          setState(() {
            rating = sum / list.length;
          });
        }
      } else {
        firestoreInstance
            .collection("users")
            .doc(useruid.uid)
            .set({'feedback': ''}, SetOptions(merge: true));
        setState(() {
          rating = 0.0;
        });
      }
    });
  }

  Future<void> setImage() async {
    final User useruid = _auth.currentUser;
    await firestoreInstance
        .collection("users")
        .doc(useruid.uid)
        .get()
        .then((value) {
      setState(() {
        if (value.data()["url"] != null) {
          imgUrl = (value.data()["url"].toString()) ?? "";
        } else {
          firestoreInstance
              .collection("users")
              .doc(useruid.uid)
              .set({'url': ''}, SetOptions(merge: true));
          imgUrl = "";
        }
        print(imgUrl);
        // address = (value["houses"][0]["city"].toString());
      });
    });
  }

  Future<void> getUserDetails() async {
    final User useruid = _auth.currentUser;
    await firestoreInstance.collection("users").doc(useruid.uid).get().then(
      (value) {
        setState(() {
          userFirstName = (value.data()["firstName"].toString());
          userLastName = (value.data()["lastName"].toString());
          // imgUrl = (value['url'].toString()) ?? "";
          // print("**********imgUrl = $imgUrl");
          // address = (value["houses"][0]["city"].toString());
        });
        if (value.data().containsKey("admin")) {
          setState(() {
            admin = value.data()["admin"];
          });
        }
      },
    );
  }

  Future<void> getPatientDetails() async {
    final User useruid = _auth.currentUser;
    if (patientUid != null) {
      await firestoreInstance.collection("users").doc(patientUid).get().then(
        (value) {
          setState(() {
            fname = (value.data()["firstName"].toString());
            lname = (value.data()["lastName"].toString());
            address = (value.data()["houses"][0]["city"].toString());
          });
        },
      );
    }
  }

  Future<void> getCurrentUid() async {
    final User useruid = _auth.currentUser;
    setState(() {
      curUid = useruid.uid;
    });
  }

  Widget getButton(
      String status,
      String therapistUid,
      String assessorUid,
      String patientUid,
      List<Map<String, dynamic>> list,
      String docID,
      BuildContext buildContext) {
    void _showSnackBar(snackbar) {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: Container(
          height: 25.0,
          child: Center(
            child: Text(
              '$snackbar',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
          ),
        ),
        backgroundColor: lightBlack(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );
      ScaffoldMessenger.of(buildContext)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    if (status == "Assessment Scheduled" && assessorUid == curUid) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          elevation: 3,
          color: Color.fromRGBO(10, 80, 106, 1),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NewAssesment(docID, "therapist", null)));
          },
          child: Text(
            "Begin Assessment",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    } else if (status == "Assessment Scheduled" && assessorUid != curUid) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          elevation: 3,
          color: Color.fromRGBO(10, 80, 106, 1),
          onPressed: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => NewAssesment(docID)));
            _showSnackBar("Wait for the assessor to finish the assessment");
          },
          child: Text(
            "Assessment Scheduled",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    } else if (status == "Assessment in Progress" && assessorUid == curUid) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          elevation: 3,
          color: Color.fromRGBO(10, 80, 106, 1),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CompleteAssessmentBase(list, docID, "therapist")));
          },
          child: Text(
            "Provide Recommendations",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    } else if (status == "Assessment in Progress" && assessorUid != curUid) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          elevation: 3,
          color: Color.fromRGBO(10, 80, 106, 1),
          onPressed: () {
            _showSnackBar("Wait for the assessor to finish the assessment");
          },
          child: Text(
            "Assessment in Progress",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    } else if (status == "Report Generated") {
      return Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          elevation: 3,
          color: Color.fromRGBO(10, 80, 106, 1),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ReportUI(docID, patientUid, therapistUid, list)));
          },
          child: Text(
            "View Report",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    } else if (status == "Assessment Finished" && curUid != assessorUid) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          elevation: 3,
          color: Color.fromRGBO(10, 80, 106, 1),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CompleteAssessmentBase(list, docID, "therapist")));
          },
          child: Text(
            "Provide Recommendations",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        // Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget ongoingassess(TherapistProvider assesspro, BuildContext context) {
    return (assesspro.loading)
        ? Center(child: CircularProgressIndicator())
        : (assesspro.datasetmain.length == 0)
            ? Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .2,
                      child: Image.asset('assets/nodata.png'),
                    ),
                    Container(
                      child: Container(
                        child: Text(
                          'NO ASSIGNMENTS ASSIGNED',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                child: Container(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 1000,
                        minHeight: MediaQuery.of(context).size.height / 10),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: assesspro.datasetmain?.length ?? 0,
                      itemBuilder: (context, index) {
                        // print(assesspro.datasetmain.length);
                        // return;
                        // return listdata(assesspro.datasetmain[index],
                        //     assesspro.datasetmain[index], assesspro);
                        return listdata(assesspro.datasetmain["$index"],
                            assesspro.dataset.docs[index], assesspro, context);
                      },
                    ),
                  ),
                ),
              ));
  }

  Widget listdata(snapshot, assessmentdata, TherapistProvider assesspro,
      BuildContext buildContext) {
    patientUid = assessmentdata["patient"] ?? "";
    List<Map<String, dynamic>> list = [];

    if (assessmentdata.data()["form"] != null) {
      list = List<Map<String, dynamic>>.generate(
          assessmentdata.data()["form"].length,
          (int index) => Map<String, dynamic>.from(
              assessmentdata.data()["form"].elementAt(index)));
    }

    // print(snapshot["patient"]);
    // print(snapshot);
    Widget getDate(String label, var date) {
      if (date != null) {
        return Container(
          width: double.infinity,
          child: Wrap(children: [
            Text(
              '$label ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
            Text(
              '${DateFormat.yMd().format(date.toDate())}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ]),
        );
      } else {
        if (label == "Completion Date:") {
          return Wrap(children: [
            Text(
              "$label ",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
            Text(
              "Yet to be Complete",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ]);
        } else {
          return Wrap(children: [
            Text(
              "$label ",
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
            Text(
              "Yet to be Begin",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ]);
        }
      }
    }

    Widget getAddress(var address) {
      if (address != null) {
        return Container(
          width: double.infinity,
          child: Wrap(children: [
            Text(
              'Home Address: ',
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
            Text(
              '${(snapshot["houses"][0]["address1"] != "") ? snapshot["houses"][0]["address1"][0].toString().toUpperCase() : ""}${(snapshot["houses"][0]["address1"] != "") ? snapshot["houses"][0]["address1"].toString().substring(1) : ""},'
                      '${(snapshot["houses"][0]["address2"] != "") ? snapshot["houses"][0]["address2"][0].toString().toUpperCase() : ""}${(snapshot["houses"][0]["address2"] != "") ? snapshot["houses"][0]["address2"].toString().substring(1) : ""},'
                      '${(snapshot["houses"][0]["city"] != "") ? snapshot["houses"][0]["city"][0].toString().toUpperCase() : ""}${(snapshot["houses"][0]["city"] != "") ? snapshot["houses"][0]["city"].toString().substring(1) : ""} ' ??
                  "Home Address: Nagpur",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ]),
        );
      } else {
        return Container(
          child: Wrap(children: [
            Text(
              "Home Address: ",
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
            Text(
              "Home Address not Availabe",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ]),
        );
      }
    }

    // assesspro.getfielddata(snapshot["patient"]);

    return Container(
      // decoration: new BoxDecoration(boxShadow: [
      //   new BoxShadow(
      //     color: Colors.grey[100],
      //     blurRadius: 15.0,
      //   ),
      // ]
      // ),
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      // height: MediaQuery.of(context).size.height * 0.3,
      child: GestureDetector(
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.white,
            child: Container(
                padding: EdgeInsets.only(bottom: 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          // color: Colors.red,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 47,
                            // backgroundImage: (imgUrl != "" && imgUrl != null)
                            //       ? new NetworkImage(imgUrl)
                            //       : Image.asset('assets/therapistavatar.png'),
                            child: ClipOval(
                              child: Image.asset('assets/therapistavatar.png'),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: VerticalDivider(
                            width: 2,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          // color: Colors.red,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      'Patient Name: ',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black45),
                                    ),
                                  ),
                                  Container(
                                    width: 87,
                                    child: Text(
                                      '${(snapshot["firstName"] != "") ? snapshot["firstName"][0].toString().toUpperCase() : ""}${(snapshot["firstName"] != "") ? snapshot["firstName"].toString().substring(1) : ""} '
                                              '${(snapshot["lastName"] != "") ? snapshot["lastName"][0].toString().toUpperCase() : ""}${(snapshot["lastName"] != "") ? snapshot["lastName"].toString().substring(1) : ""} ' ??
                                          "Prachi Rathi",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.5),
                              Divider(),
                              Container(
                                width: double.infinity,
                                child: Wrap(children: [
                                  Text(
                                    'Start Date: ',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black45),
                                  ),
                                  Text(
                                    '${DateFormat.yMd().format(assessmentdata['date'].toDate())}' ??
                                        "1/1/2021",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ]),
                              ),
                              SizedBox(height: 2.5),
                              Divider(),
                              (assessmentdata.data()[
                                              "assessmentCompletionDate"] !=
                                          "" &&
                                      assessmentdata.data()[
                                              "assessmentCompletionDate"] !=
                                          null)
                                  ? getDate(
                                      "Completion Date:",
                                      assessmentdata
                                          .data()["assessmentCompletionDate"])
                                  : SizedBox(),
                              (assessmentdata.data()[
                                              "assessmentCompletionDate"] !=
                                          "" &&
                                      assessmentdata.data()[
                                              "assessmentCompletionDate"] !=
                                          null)
                                  ? SizedBox(height: 2.5)
                                  : SizedBox(),
                              (assessmentdata.data()[
                                              "assessmentCompletionDate"] !=
                                          "" &&
                                      assessmentdata.data()[
                                              "assessmentCompletionDate"] !=
                                          null)
                                  ? Divider()
                                  : SizedBox(),
                              // getDate("Latest Change: ",
                              //     snapshot["latestChangeDate"]),
                              // SizedBox(height: 2.5),
                              // Divider(),
                              // Container(
                              //   width: double.infinity,
                              //   child: Wrap(children: [
                              //     Text(
                              //       'Status: ',
                              //       style: TextStyle(
                              //           fontSize: 16, color: Colors.black45),
                              //     ),
                              //     Text(
                              //       '${assessmentdata.data()["currentStatus"]}',
                              //       style: TextStyle(
                              //         fontSize: 16,
                              //       ),
                              //     ),
                              //   ]),
                              // ),
                              // SizedBox(height: 2.5),
                              // Divider(),

                              // getAddress(snapshot["houses"]),
                              Container(
                                child: Wrap(children: [
                                  Text(
                                    'Home Address: ',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black45),
                                  ),
                                  Text(
                                    '${assessmentdata.data()["home"]}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ]),
                              ),

                              // Container(child: Text('${dataset.data}')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    getButton(
                        assessmentdata.data()["currentStatus"],
                        assessmentdata.data()["therapist"],
                        assessmentdata.data()["assessor"],
                        assessmentdata.data()["patient"],
                        list,
                        assessmentdata.data()["docID"],
                        context),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ))),
        onTap: () async {
          //   print("Hello");
          //   await assesspro.getdocref(assessmentdata);
          //   // print(assesspro.curretnassessmentdocref);
          //   // print(assessmentdata.data);

          //   if (assessmentdata.data['Status'] == "new") {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 NewAssesment(assesspro.curretnassessmentdocref)));
          //   } else {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 NewAssesment(assesspro.curretnassessmentdocref)));
          //   }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TherapistProvider assesspro = Provider.of<TherapistProvider>(context);
    setState(() {
      requestedPatientNames = assesspro.requestedPatientNames.toList();
      recommendationPatientNames =
          assesspro.recommendationPatientNames.toList();
      finishedPatientNames = assesspro.finishedPatientNames.toList();
      cmPatientNames = assesspro.cmPatientNames.toList();
      cmNames = assesspro.cmNames.toList();
    });
    Widget getName(String name) {
      if (name != null) {
        return Container(
          alignment: Alignment.bottomLeft,
          child: Text(
            "${name[0].toUpperCase()}${name.substring(1)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 37,
            ),
          ),
        );
      } else {
        return Container(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Therapist",
            style: TextStyle(
              color: Colors.white,
              fontSize: 37,
            ),
          ),
        );
      }
    }

    Widget buildStar(BuildContext context, int index) {
      Icon icon;
      if (index >= rating) {
        icon = new Icon(
          Icons.star_border,
          // ignore: deprecated_member_use
          color: Theme.of(context).buttonColor,
          size: 20,
        );
      } else if (index > rating - 1 && index < rating) {
        icon = new Icon(
          Icons.star_half,
          color: Color(0xffffbb20),
          size: 20,
        );
      } else {
        icon = new Icon(
          Icons.star,
          color: Color(0xffffbb20),
          size: 20,
        );
      }
      return new InkResponse(
        onTap: () {},
        child: icon,
      );
    }

    Widget homepage(TherapistProvider assesspro) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height * 0.12,
              child: GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Scheduled Assessments",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lato")),
                          SizedBox(height: 5),
                          Text("View scheduled assessments",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Lato"))
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: assesspro,
                          child: DetailedScreen(
                              'Scheduled Assessments', 'Scheduled'),
                        );
                      },
                    ));
                  }),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height * 0.12,
              child: GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pending Assessments",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lato")),
                          SizedBox(height: 5),
                          Text("View assessments which are yet to be filled",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Lato"))
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: assesspro,
                          child:
                              DetailedScreen('Pending Assessments', 'Pending'),
                        );
                      },
                    ));
                  }),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height * 0.12,
              child: GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Closed Assessments",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lato")),
                          SizedBox(height: 5),
                          Text("View reports of closed assessments",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Lato"))
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: assesspro,
                          child: DetailedScreen('Closed Assessments', 'Closed'),
                        );
                      },
                    ));
                  }),
            ),
          ],
        ),
      );
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            drawer: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(10, 80, 106, 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              // color: Colors.pink,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 40),
                                    alignment: Alignment.centerLeft,
                                    // color: Colors.red,
                                    child: Text(
                                      "Hello,",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  getName(userFirstName),
                                  Container(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Text(
                                      "$rating / 5",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: new List.generate(
                                              5,
                                              (index) =>
                                                  buildStar(context, index))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 7),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ViewPhoto(imgUrl ?? "", "therapist")));
                              },
                              child: Container(
                                  // height: 30,
                                  alignment: Alignment.topRight,
                                  padding: EdgeInsets.only(top: 30),
                                  // width: double.infinity,
                                  // color: Colors.red,
                                  child: (imgUrl != "" && imgUrl != null)
                                      ? CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 47,
                                          // backgroundImage: (imgUrl != "" && imgUrl != null)
                                          //     ? NetworkImage(imgUrl)
                                          //     : Image.asset('assets/therapistavatar.png'),
                                          child: ClipOval(
                                              clipBehavior: Clip.hardEdge,
                                              child: CachedNetworkImage(
                                                imageUrl: imgUrl,
                                                fit: BoxFit.cover,
                                                width: 400,
                                                height: 400,
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                              )),
                                        )
                                      : CircleAvatar(
                                          radius: 47,
                                          backgroundColor: Colors.white,
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/therapistavatar.png',
                                            ),
                                          ),
                                        )),
                            ),
                          ],
                        ),
                        // child: Text("$name"),
                        //
                      ),
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.favorite, color: Colors.green),
                    //   title: Text(
                    //     'Patients/Caregivers/Families',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    //   onTap: () => {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) => PatientsList()))
                    //   },
                    // ),
                    // ListTile(
                    //   leading: Icon(Icons.home, color: Colors.green),
                    //   title: Text(
                    //     'Home Addresses',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    //   onTap: () => {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) => HomeAddresses()))
                    //   },
                    // ),
                    // ListTile(
                    //   leading: Icon(Icons.people, color: Colors.green),
                    //   title: Text(
                    //     'Nurses/Case Managers',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    //   onTap: () => {
                    //     Navigator.of(context).push(
                    //         MaterialPageRoute(builder: (context) => NursesList()))
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Icons.assessment, color: Colors.green),
                      title: Text(
                        'Assessments',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AssesmentSplashScreen("therapist")))
                      },
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.feedback_rounded, color: Colors.green),
                      title: Text(
                        'Feedback',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewFeedbackBase()))
                      },
                    ),
                    admin
                        ? ListTile(
                            leading:
                                Icon(Icons.add_moderator, color: Colors.green),
                            title: Text(
                              'Add Patient',
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddPatientDirectly()))
                            },
                          )
                        : SizedBox(),
                    admin
                        ? ListTile(
                            leading: Icon(Icons.admin_panel_settings_sharp,
                                color: Colors.green),
                            title: Text(
                              'Admin',
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ShareApp()))
                            },
                          )
                        : SizedBox(),
                    // ListTile(
                    //   leading: Icon(Icons.pages, color: Colors.green),
                    //   title: Text(
                    //     'Report',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    //   onTap: () => {Navigator.of(context).pop()},
                    // ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(10, 80, 106, 1),
              title: Text('Dashboard'),
              elevation: 0.0,
              actions: [
                IconButton(
                  tooltip: "Logout",
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    try {
                      await _auth.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MyHomePage()));
                    } catch (e) {
                      print("Logout Failed: " + e.toString());
                    }
                  },
                  // label: Text(
                  //   'Logout',
                  //   style: TextStyle(color: Colors.white, fontSize: 16),
                  // ),
                )
              ],
            ),
            backgroundColor: Colors.grey[300],
            body: homepage(assesspro)
            // ongoingassess(assesspro, context)
            ));
  }
}
