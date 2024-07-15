import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:doggyfeed/Models/Utils/Colors.dart';
import 'package:doggyfeed/Models/Utils/Common.dart';
import 'package:doggyfeed/Models/Utils/FirebaseStructure.dart';
import 'package:doggyfeed/Models/Utils/Routes.dart';
import 'package:doggyfeed/Models/Utils/Utils.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:intl/intl.dart';
import 'package:doggyfeed/Views/Widgets/graph_view.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../Widgets/custom_text_datetime_chooser.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];

  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  bool useFilters = false;
  bool showFilters = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: color7,
        body: SafeArea(
          child: SizedBox(
              width: displaySize.width,
              height: displaySize.height,
              child: Column(
                children: [
                  Expanded(
                      flex: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Routes(context: context).back();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: colorWhite,
                                ),
                              ),
                              Text(
                                "History",
                                style: TextStyle(fontSize: 16.0, color: color7),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    showFilters = !showFilters;
                                  });
                                },
                                child: Icon(
                                  (showFilters) ? Icons.menu_open : Icons.menu,
                                  color: colorWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  (showFilters)
                      ? AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                        fontSize: 16.0, color: colorBlack),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: CustomTextDateTimeChooser(
                                        height: 5.0,
                                        controller: start,
                                        backgroundColor: color7,
                                        iconColor: colorPrimary,
                                        isIconAvailable: true,
                                        hint: 'Start',
                                        icon: Icons.calendar_month,
                                        textInputType: TextInputType.text,
                                        validation: (value) {
                                          return null;
                                        },
                                        obscureText: false),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: CustomTextDateTimeChooser(
                                        height: 5.0,
                                        controller: end,
                                        backgroundColor: color7,
                                        iconColor: colorPrimary,
                                        isIconAvailable: true,
                                        hint: 'End',
                                        icon: Icons.safety_check,
                                        textInputType: TextInputType.text,
                                        validation: (value) {
                                          return null;
                                        },
                                        obscureText: false),
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 50.0,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  colorWhite),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  colorPrimary),
                                        ),
                                        onPressed: () async {
                                          useFilters = true;
                                          getData();
                                        },
                                        child: const Text(
                                          "Filter Records",
                                          style: TextStyle(),
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 50.0,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  colorWhite),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  colorPrimary),
                                        ),
                                        onPressed: () async {
                                          useFilters = true;
                                          getData();
                                          viewGraph();
                                        },
                                        child: const Text(
                                          "Graph View",
                                          style: TextStyle(),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: colorWhite,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5.0, left: 5.0, right: 5.0),
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (var rec in list)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1.0),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 5.0),
                                          child: ExpandedTile(
                                            theme: ExpandedTileThemeData(
                                              headerRadius: 24.0,
                                              headerPadding:
                                                  const EdgeInsets.all(24.0),
                                              headerSplashColor: colorSecondary,
                                              contentBackgroundColor: color7,
                                              contentPadding:
                                                  const EdgeInsets.all(24.0),
                                              contentRadius: 12.0,
                                            ),
                                            leading: Icon(
                                              Icons.pets_outlined,
                                              color: colorPrimary,
                                              size: 35.0,
                                            ),
                                            title: Text(
                                              rec['value']['dog-detection']
                                                  ? 'Detected'
                                                  : 'Not Detected',
                                              style: TextStyle(
                                                  color: rec['value']
                                                          ['dog-detection']
                                                      ? colorPrimary
                                                      : colorGrey,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15.0),
                                            ),
                                            content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getHistoryCard(
                                                    Icons.water_drop_outlined,
                                                    'Water Level',
                                                    rec['value']['water-level']
                                                        .toString(),
                                                    symbol: '%'),
                                                getHistoryCard(
                                                    Icons.food_bank_outlined,
                                                    'Food Level',
                                                    rec['value']['food-level']
                                                        .toString(),
                                                    symbol: '%'),
                                                getHistoryCard(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    'Datetime',
                                                    getDateTime(int.parse(
                                                        rec['key']
                                                            .toString()))),
                                              ],
                                            ),
                                            controller: ExpandedTileController(
                                                isExpanded: false),
                                          )),
                                    )
                                ]),
                          ),
                        ),
                      ))
                ],
              )),
        ));
  }

  String getDateTime(int mills) {
    return DateFormat('yyyy/MM/dd hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(mills));
  }

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.HISTORY)
        .once()
        .then((DatabaseEvent data) {
      list.clear();
      for (DataSnapshot element in data.snapshot.children) {
        if (useFilters == true &&
            start.text.isNotEmpty &&
            end.text.isNotEmpty) {
          DateTime currentDateTime =
              DateTime.fromMillisecondsSinceEpoch(element.key as int);
          if (currentDateTime.isAfter(
                  DateFormat("yyyy/MM/dd hh:mm a").parse(start.text)) &&
              currentDateTime
                  .isBefore(DateFormat("yyyy/MM/dd hh:mm a").parse(end.text))) {
            list.add({'key': element.key, 'value': element.value});
          }
        } else {
          list.add({'key': element.key, 'value': element.value});
        }

        print({'key': element.key, 'value': element.value});
      }
      setState(() {
        useFilters = false;
      });
    });
  }

  Future<void> viewGraph() async {
    if (list.isNotEmpty) {
      final List<ChartData> chartData1 = [];
      final List<ChartData> chartData2 = [];
      for (var element in list) {
        chartData1.add(ChartData(
            getDateTime(int.parse(element['key'].toString())),
            double.parse(element['value']['water-level'].toString())));

        chartData2.add(ChartData(
            getDateTime(int.parse(element['key'].toString())),
            double.parse(element['value']['food-level'].toString())));
      }

      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return GraphView(
              chartData1: chartData1,
              chartData2: chartData2,
              label1: "Water / Food Levels",
            );
          });
    } else {
      CustomUtils.showToast("No data found to create graph");
    }
  }

  getHistoryCard(IconData icon, String title, String param,
      {String? symbol, bool isSwitch = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: colorGrey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: color15,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                  )
                ],
              )),
          if (isSwitch)
            ToggleSwitch(
              activeBgColor: [colorPrimary],
              initialLabelIndex: int.parse(param),
              totalSwitches: 2,
              labels: const ['OFF', 'ON'],
              changeOnTap: false,
            ),
          if (!isSwitch)
            Expanded(
                flex: 0,
                child: Row(
                  children: [
                    Text(
                      param,
                      style: TextStyle(
                          color: color15,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                    if (symbol != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          symbol,
                          style: TextStyle(
                              color: color15,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0),
                        ),
                      )
                  ],
                ))
        ],
      ),
    );
  }
}
