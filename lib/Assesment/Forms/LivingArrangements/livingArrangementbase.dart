import 'package:flutter/material.dart';
import 'package:tryapp/Assesment/Forms/LivingArrangements/livingArrangementUI.dart';
import 'package:tryapp/Assesment/Forms/Patio/patioUI.dart';

import 'package:provider/provider.dart';
import 'package:tryapp/Assesment/newassesment/newassesmentpro.dart';

class LivingArrangements extends StatelessWidget {
  String roomname;
  var accessname;
  List<Map<String, dynamic>> wholelist;
  LivingArrangements(this.roomname, this.wholelist, this.accessname);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ChangeNotifierProvider<NewAssesmentProvider>(
          create: (_) => NewAssesmentProvider(""),
          child: LivingArrangementsUI(roomname, wholelist, accessname)),
    ));
  }
}