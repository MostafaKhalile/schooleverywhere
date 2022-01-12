import '../Staff/UnPaidLeaveRequest.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/LoginPage.dart';
import 'LeaveRequest.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class UnPaidPreviousLeaveRequest extends StatefulWidget {
  final String id;
  final String year;
  final String section;
  const UnPaidPreviousLeaveRequest(this.id, this.year, this.section);

  @override
  State<StatefulWidget> createState() {
    return new _UnPaidPreviousLeaveRequestState();
  }
}

class _UnPaidPreviousLeaveRequestState
    extends State<UnPaidPreviousLeaveRequest> {
  bool isLoading = false;
  bool pressed = false;
  List<dynamic> unPaidLeaveRequests = [];
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController dateFrom = new TextEditingController();
  TextEditingController dateTo = new TextEditingController();
  List<dynamic> dropLeaveRequest = [];
  initState() {
    super.initState();
  }

  Future<void> syncUnPaidPreviousLeaveRequest() async {
    EventObject objectEventSt =
        await unPaidPreviousLeaveRequest(widget.id, dateFrom.text, dateTo.text);
    if (objectEventSt.success!) {
      Map? dataShowContentData = objectEventSt.object as Map?;
      List<dynamic> listOfColumns = dataShowContentData!['data'];
      setState(() {
        unPaidLeaveRequests = listOfColumns;
        isLoading = true;
      });
    } else {
      String? msg = objectEventSt.object as String?;
      /* Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> syncUnPaidDeleteLeaveRequest() async {
    EventObject objectEventSt =
        await unPaidDeleteLeaveRequest(dropLeaveRequest);
    setState(() {
      Navigator.of(context).pop();
      if (objectEventSt.success!) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UnPaidPreviousLeaveRequest(
                  widget.id, widget.year, widget.section)),
        );
        /* Flushbar(
          title: "Success",
          message: "Deleted",
          icon: Icon(Icons.done_outline),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 2),
        )
          ..show(context);*/
        Fluttertoast.showToast(
            msg: "Deleted",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            backgroundColor: AppTheme.appColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        String? msg = objectEventSt.object as String?;
        /*  Flushbar(
          title: "Failed",
          message: msg.toString(),
          icon: Icon(Icons.close),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 3),
        )
          ..show(context);*/
        Fluttertoast.showToast(
            msg: msg.toString(),
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            backgroundColor: AppTheme.appColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => UnPaidLeaveRequest()));
          break;
        case 1:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => UnPaidPreviousLeaveRequest(
                      widget.id, widget.year, widget.section)));
          break;
      }
    });
  }

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final dateFromUi = Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
        child: Container(
            width: MediaQuery.of(context).size.width * .5,
            height: MediaQuery.of(context).size.height * .05,
            child: DateTimeField(
              format: format,
              controller: dateFrom,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.appColor)),
              ),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1996),
                    initialDate: DateTime.now(),
                    lastDate: DateTime(2050));
              },
            )));

    final dateToUi = Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
        child: Container(
            width: MediaQuery.of(context).size.width * .5,
            height: MediaQuery.of(context).size.height * .05,
            child: DateTimeField(
              format: format,
              controller: dateTo,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.appColor)),
              ),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1996),
                    initialDate: DateTime.now(),
                    lastDate: DateTime(2050));
              },
            )));

    final viewBtn = Padding(
      padding: EdgeInsets.symmetric(
          vertical: 30.0, horizontal: MediaQuery.of(context).size.width * .25),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if (dateFrom != null && dateTo != null) {
            pressed = true;
            syncUnPaidPreviousLeaveRequest();
          } else {
            /* Flushbar(
              title: "Failed",
              message: 'Please Fill All Required Data',
              icon: Icon(Icons.close),
              backgroundColor: AppTheme.appColor,
              duration: Duration(seconds: 3),
            )
              ..show(context);*/
            Fluttertoast.showToast(
                msg: "Please Fill All Required Data",
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 3,
                backgroundColor: AppTheme.appColor,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('View', style: TextStyle(color: Colors.white)),
      ),
    );

    final deleteBtn = Padding(
      padding: EdgeInsets.symmetric(
          vertical: 30.0, horizontal: MediaQuery.of(context).size.width * .25),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          syncUnPaidDeleteLeaveRequest();
        },
        padding: EdgeInsets.all(12),
        color: Colors.red,
        child: Text('Delete', style: TextStyle(color: Colors.white)),
      ),
    );

    final showData = !isLoading
        ? loadingSign
        : Center(
            child: DataTable(
              columns: [
                DataColumn(label: Text("")),
                DataColumn(
                    label: Text(
                  "Name",
                  style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                )),
                DataColumn(
                    label: Text(
                  "Status",
                  style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                )),
                DataColumn(
                    label: Text(
                  "Date",
                  style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                )),
                DataColumn(
                    label: Text(
                  "Reason",
                  style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                )),
                DataColumn(
                    label: Text(
                  "Approved by",
                  style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                )),
              ],
              rows:
                  unPaidLeaveRequests // Loops through dataColumnText, each iteration assigning the value to element
                      .map(
                        ((element) => DataRow(
                              cells: <DataCell>[
                                (element["showCheckBox"] == "checkBox")
                                    ? DataCell(Checkbox(
                                        value: element["checkBoxchecked"],
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            element["checkBoxchecked"] =
                                                newValue!;
                                            if (newValue)
                                              dropLeaveRequest
                                                  .add(element["id"]);
                                            else
                                              dropLeaveRequest
                                                  .remove(element["id"]);
                                          });
                                        }))
                                    : DataCell(Text("")),
                                DataCell(Text(
                                  element["name"],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                )),
                                DataCell(Text(
                                  element["status"],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                )),
                                DataCell(Text(
                                  element["date"],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                )),
                                DataCell(Text(
                                  element["reason"],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                )),
                                DataCell(Text(
                                  element["approvedBy"],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                )),
                              ],
                            )),
                      )
                      .toList(),
            ),
          );

    final body = Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.width * .02),
          ),
          dateFromUi,
          dateToUi,
          viewBtn,
          pressed
              ? new Expanded(
                  child: ListView(
                  children: <Widget>[
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: showData,
                        ))
                  ],
                ))
              : Container(),
          pressed ? deleteBtn : Container(),
        ],
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(FlavorConfig.instance.values.schoolName!),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => HomePage(
                        type: STAFF_TYPE,
                        sectionid: widget.section,
                        Id: widget.id,
                        Academicyear: widget.year)));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AssetImage('${FlavorConfig.instance.values.imagePath!}'),
              ),
            )
          ],
        ),
        backgroundColor: AppTheme.appColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_comment),
            title: Text('New Request'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.low_priority),
            title: Text('Previous'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.appColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(STAFF_TYPE, widget.id);
            removeUserData();
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
//          Navigator.pop(context);
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: Icon(
            FontAwesomeIcons.doorOpen,
            color: AppTheme.floatingButtonColor,
            size: 30,
          ),
          backgroundColor: Colors.transparent,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          )),
    );
  }
}
