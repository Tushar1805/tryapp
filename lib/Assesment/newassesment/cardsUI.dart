import 'package:flutter/material.dart';
import 'package:tryapp/Assesment/Forms/Bathroom/bathroom.dart';
import 'package:tryapp/Assesment/Forms/Bedroom/bedroombase.dart';
import 'package:tryapp/Assesment/Forms/DiningRoom/diningroom.dart';
import 'package:tryapp/Assesment/Forms/Garage/garagebase.dart';
import 'package:tryapp/Assesment/Forms/Kitchen/kitchen.dart';
import 'package:tryapp/Assesment/Forms/Laundry/laundrybase.dart';
import 'package:tryapp/Assesment/Forms/LivingArrangements/livingArrangementbase.dart';
import 'package:tryapp/Assesment/Forms/Pathway/pathwaybase.dart';
import 'package:tryapp/Assesment/Forms/Patio/patiobase.dart';
import 'package:async_button_builder/async_button_builder.dart';
import '../Forms/LivingRoom/livingbase.dart';

/// Frame of this page:
///     There are certain functions defined to take care of things such as colour and border dimension
///     of the linear progress bar
///
///     *)The main Build function:
///       This fucntion contains following things:
///           --All this under a Stack so that the submit assessment button can staty in the bottom.
///           1)Appbar
///           2)Arrangements Card
///               a) Living Arrangements card(Mandatory). called the Cards fucntion described further in this doc.
///           3) Available Rooms card:
///           4)LISTVIEW to build the card based on number of rooms selected in last page(New Assessment Ui page).
///
///
///     Explanation: Innerlist:
///
///         {
///            'name': 'Pathway',
///            'count': text, //the count from button will get saved here
///            'completed': 7,
///            'rooms1':{<---------------------------------- (INNERLIST REFERS TO THIS LIST)
///                 name://This will help us to
///                        save name of room.
///                 complete: //This will help
///                           us to save the numbers of
///                           completed fields this
///                           far and also help us
///                           to calculate the linear
///                           progress bar.
///                 total: // This is the total number
///                           of questions in
///                           particular rooms..
///                           This is Static.
///                           We will get this data
///                           from gettotal function
///                           from the provider.
///                 question: { //this is explained in getMaps function in provider.
///                   rr1:{
///                       Answer:,
///                       Priority:,
///                       Recommendation:,
///                       Recommendationthera:,
///                       additional:{},
///                      }
///                   }
///             }
///         },
///
///     *)The Cards fucntion:
///       This fucntion takes(one room detail at a time called innerlist,index and key for individual card).
///       This function contains following things:
///            1) The outer frame to display each and ever room details.
///            2) The linear progress bar to show the completed fields in each and individual fields.
///
///     *) The getRoute class:
///        This fucntion takes (same innerlist,name of the room,the name of innerlist,index)
///       This function is a helper fucntion to the cards function.
///       It helps to decide which page ot which room to go.
///
///

final _colorgreen = Color.fromRGBO(10, 80, 106, 1);

class CardsUINew extends StatefulWidget {
  List<Map<String, dynamic>> wholelist;
  CardsUINew(this.wholelist);
  @override
  _CardsUINewState createState() => _CardsUINewState();
}

class _CardsUINewState extends State<CardsUINew> with TickerProviderStateMixin {
  GlobalKey c1 = GlobalKey();
  double widthh = 1;
  AnimationController _animationController;

  double _containerPaddingLeft = 20.0;
  double _animationValue;
  double _translateX = 0;
  double _translateY = 0;
  double _rotate = 0;
  double _scale = 1;

  bool show;
  bool sent = false;
  Color _color = Colors.lightBlue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setWidth(c1));
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));
    show = true;
    _animationController.addListener(() {
      setState(() {
        show = false;
        _animationValue = _animationController.value;
        if (_animationValue >= 0.2 && _animationValue < 0.4) {
          _containerPaddingLeft = 100.0;
          _color = Colors.green;
        } else if (_animationValue >= 0.4 && _animationValue <= 0.5) {
          _translateX = 80.0;
          _rotate = -20.0;
          _scale = 0.1;
        } else if (_animationValue >= 0.5 && _animationValue <= 0.8) {
          _translateY = -20.0;
        } else if (_animationValue >= 0.81) {
          _containerPaddingLeft = 20.0;
          sent = true;
        }
      });
    });
  }

  /// This fucntio will help us to get the width of the container.
  /// with help of this we will be able to set the liner progress bar width

  void setWidth(GlobalKey key) {
    final RenderBox rend = key.currentContext.findRenderObject();
    widthh = rend.size.width;
    setState(() {});
  }

  double getwidth(completed, total) {
    if (completed <= 1) {
      return widthh * completed / total;
    } else {
      return widthh * ((completed - 0.5) / total);
    }
  }

  /// This function will help us to get the colour base on the count of completed
  /// form fields.
  Color getcolor(innerlist, index) {
    Color colors = Colors.red;

    if (innerlist['room${index + 1}']['complete'] >= 0 &&
        innerlist['room${index + 1}']['complete'] <= 3) {
      colors = Color.fromRGBO(233, 92, 36, 1);
      // bordercolor = Color.fromRGBO(233, 92, 36, 1);
    } else if (innerlist['room${index + 1}']['complete'] > 3 &&
        innerlist['room${index + 1}']['complete'] <
            innerlist['room$index']['total']) {
      colors = Color.fromRGBO(221, 216, 0, 01);
      // bordercolor = Color.fromRGBO(221, 216, 0, 1);
    } else if (innerlist['room${index + 1}']['complete'] ==
        innerlist['room$index']['total']) {
      colors = Color.fromRGBO(127, 176, 54, 1);
    }
    return colors;
  }

  /// This fucntion will help us to get border colour of our linear progress bar
  Color getbordercolor(innerlist, index) {
    Color bordercolor = Colors.red;
    if (innerlist['room$index']['complete'] >= 0 &&
        innerlist['room$index']['complete'] <= 3) {
      bordercolor = Color.fromRGBO(233, 92, 36, 1);
    } else if (innerlist['room$index']['complete'] > 3 &&
        innerlist['room$index']['complete'] <
            innerlist['room$index']['total']) {
      bordercolor = Color.fromRGBO(221, 216, 0, 1);
    } else if (innerlist['room$index']['complete'] ==
        innerlist['room$index']['total']) {
      bordercolor = Color.fromRGBO(127, 176, 54, 1);
    }
    return bordercolor;
  }

  /// This will help us  get border radius. this have been included because wehen the count
  /// becomes equal to total question then th border radius changes.
  BorderRadius getborderradius(innerlist, index) {
    var bordertype = BorderRadius.only(
      // topRight: Radius.circular(20),
      topLeft: Radius.circular(20),
    );
    if (innerlist['room$index']['complete'] ==
        innerlist['room$index']['total']) {
      bordertype = BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      );
    }
    return bordertype;
  }

  @override
  Widget build(BuildContext context) {
    // AssesmentProvider assesmentProvider = AssesmentProvider();
    return Scaffold(
        appBar: AppBar(
          title: Text('Assessment'),
          backgroundColor: _colorgreen,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                          // height: MediaQuery.of(context).size.height / 8,
                          width: double.infinity,
                          child: Card(
                            // key: c2,
                            elevation: 8,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'ARRANGEMENTS:',
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: _colorgreen),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )),
                      Container(
                        child: cards(widget.wholelist[1], 1, widthh),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          // height: MediaQuery.of(context).size.height / 8,
                          width: double.infinity,
                          child: Card(
                            key: c1,
                            elevation: 8,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'AVAILABLE ROOMS:',
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: _colorgreen),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )),
                      Container(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 3000, minHeight: 0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.wholelist.length,
                              itemBuilder: (context, index) {
                                if (widget.wholelist[index]['name'] ==
                                    'Living Arrangements') {
                                  return SizedBox();
                                }
                                return cards(
                                    widget.wholelist[index], index, widthh);
                              }),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  )),
            ),
            Container(
              child: Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.bottomRight,
                // height: double.infinity,
                child: AsyncButtonBuilder(
                  child: Padding(
                    // Value keys are important as otherwise our custom transitions
                    // will have no way to differentiate between children.
                    key: ValueKey('foo'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    child: Text(
                      'Submit Assessment Details',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  loadingWidget: Padding(
                    key: ValueKey('bar'),
                    padding: const EdgeInsets.all(17.0),
                    child: SizedBox(
                      height: 25.0,
                      width: 25.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  successWidget: Padding(
                    key: ValueKey('foobar'),
                    padding: const EdgeInsets.all(17.5),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    await Future.delayed(const Duration(milliseconds: 1500),
                        () {
                      for (int i = 0; i < widget.wholelist.length; i++) {
                        for (int j = 1;
                            j <= widget.wholelist[i]['count'];
                            j++) {
                          print(widget.wholelist[i]['count']);
                        }
                      }
                    });
                    // print(widget.wholelist);
                  },
                  loadingSwitchInCurve: Curves.bounceInOut,
                  loadingTransitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 1.0),
                        end: Offset(0, 0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                  builder: (context, child, callback, state) {
                    return Material(
                      color: state.maybeWhen(
                        success: () => Colors.green[600],
                        orElse: () => Colors.blue,
                      ),
                      // This prevents the loading indicator showing below the
                      // button
                      clipBehavior: Clip.hardEdge,
                      shape: StadiumBorder(),
                      child: InkWell(
                        child: child,
                        onTap: callback,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }

  /// This is the card function used to dispaly the card.
  Widget cards(Map<String, dynamic> innerlist, int index, key) {
    return Container(
      // width: double.infinity,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: innerlist['count'],
          itemBuilder: (context, index1) {
            return Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    getRoute(innerlist, innerlist['room${index1 + 1}']['name'],
                        'room${index1 + 1}', index);
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: getbordercolor(
                                          innerlist, index1 + 1)),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                              ),
                              Container(
                                height: 20,
                                width: getwidth(
                                    innerlist['room${index1 + 1}']['complete'],
                                    innerlist['room${index1 + 1}']['total']),
                                decoration: BoxDecoration(
                                    color:
                                        getbordercolor(innerlist, index1 + 1),
                                    borderRadius:
                                        getborderradius(innerlist, index1 + 1)),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Text(
                                    innerlist['room${index1 + 1}']['name'],
                                    style: TextStyle(
                                        color: Color.fromRGBO(10, 80, 106, 1),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Text(
                                    '${innerlist['room${index1 + 1}']['complete']}/${innerlist['room${index1 + 1}']['total']}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(10, 80, 106, 1),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                ));
            // Text(innerlist['room${index1 + 1}']);
          }),
    );
  }

  /// This function decides which page to visit base upon the name.
  Widget getRoute(innerlist, roomname, accessname, index) {
    if (innerlist['name'] == 'Living Room') {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LivingRoom(roomname, widget.wholelist, accessname)))
          .then((value) => setState(() {
                widget.wholelist[index][accessname]['complete'] =
                    value['complete'];
                // widget.wholelist[index]['']
              }));
    } else if (innerlist['name'] == 'Kitchen') {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Kitchen(roomname, widget.wholelist, accessname)))
          .then((value) => setState(() {
                widget.wholelist[index][accessname]['complete'] =
                    value['complete'];
                // widget.wholelist[index]['']
              }));
    } else if (innerlist['name'] == 'Dining Room') {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DiningRoom(roomname, widget.wholelist, accessname)))
          .then((value) => setState(() {
                widget.wholelist[index][accessname]['complete'] =
                    value['complete'];
                // widget.wholelist[index]['']
              }));
    } else if (innerlist['name'] == 'Bathroom') {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Bathroom(roomname, widget.wholelist, accessname)))
          .then((value) => setState(() {
                widget.wholelist[index][accessname]['complete'] =
                    value['complete'];
                // widget.wholelist[index]['']
              }));
    } else if (innerlist['name'] == 'Bedroom') {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Bedroom(roomname, widget.wholelist, accessname)))
          .then((value) => setState(() {
                widget.wholelist[index][accessname]['complete'] =
                    value['complete'];
                // widget.wholelist[index]['']
              }));
    } else if (innerlist['name'] == 'Laundry') {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Laundry(roomname, widget.wholelist, accessname)))
          .then((value) => setState(() {
                widget.wholelist[index][accessname]['complete'] =
                    value['complete'];
              }));
    } else if (innerlist['name'] == 'Patio') {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Patio(roomname, widget.wholelist, accessname)))
          .then((value) => setState(() {
                widget.wholelist[index][accessname]['complete'] =
                    value['complete'];
                // widget.wholelist[index]['']
              }));
    } else if (innerlist['name'] == 'Garage') {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Garage(roomname, widget.wholelist, accessname)))
          .then((value) => setState(() {
                widget.wholelist[index][accessname]['complete'] =
                    value['complete'];
                // widget.wholelist[index]['']
              }));
    } else if (innerlist['name'] == 'Pathway') {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Pathway(roomname, widget.wholelist, accessname)))
          .then((value) => setState(() {
                widget.wholelist[index][accessname]['complete'] =
                    value['complete'];
                // widget.wholelist[index]['']
              }));
    } else if (innerlist['name'] == 'Living Arrangements') {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LivingArrangements(
                      roomname, widget.wholelist, accessname)))
          .then((value) => setState(() {
                widget.wholelist[index][accessname]['complete'] =
                    value['complete'];
                // widget.wholelist[index]['']
              }));
    }
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  CustomDialog({this.title, this.description, this.buttonText, this.image});
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context));
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          padding: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              )
            ],
          ),
          child: Container(
            // margin:
            //     EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Container(
                    child: Image.asset(
                  "assets/gifmessage.gif",
                  // height: 125.0,
                  // width: 150.0,
                )),
                SizedBox(height: 15.2),
                Container(
                    // width: 200,
                    child: Image.asset(
                  "assets/download.png",
                  height: 70.0,
                  width: 70.0,
                )),
                SizedBox(height: 12.0),
                Text(description, style: TextStyle(fontSize: 16.0)),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    color: Color.fromRGBO(10, 80, 106, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Color.fromRGBO(10, 80, 106, 1),
                        )),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        Text("Got it", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
