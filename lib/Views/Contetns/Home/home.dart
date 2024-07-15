import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:doggyfeed/Models/Strings/app.dart';
import 'package:doggyfeed/Models/Utils/Colors.dart';
import 'package:doggyfeed/Models/Utils/Common.dart';
import 'package:doggyfeed/Models/Utils/FirebaseStructure.dart';
import 'package:doggyfeed/Models/Utils/Images.dart';
import 'package:doggyfeed/Views/Contetns/Home/drawer.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  dynamic dataLive = null;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getData();
      initNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: color7,
        drawer: HomeDrawer(),
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
                                onTap: () => (_scaffoldKey
                                        .currentState!.isDrawerOpen)
                                    ? _scaffoldKey.currentState!.openEndDrawer()
                                    : _scaffoldKey.currentState!.openDrawer(),
                                child: Icon(
                                  Icons.menu_rounded,
                                  color: colorWhite,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.circular(20.0)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 15.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: displaySize.width * 0.08,
                                      child: Image.asset(logo),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        "$app_name $app_quote",
                                        style: TextStyle(
                                            fontSize: 16.0, color: colorBlack),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  getData();
                                },
                                child: Icon(
                                  Icons.refresh,
                                  color: colorWhite,
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  if (dataLive != null)
                    getLiveTile(Icons.speaker_group_outlined, "Dog Command",
                        dataLive['dog-command'],
                        type: 1, onTap: () async {
                      await _databaseReference
                          .child(FirebaseStructure.LIVEDATA)
                          .child('dog-command')
                          .set(true);
                    }),
                  if (dataLive != null)
                    getLiveTile(Icons.speaker_group_outlined, "Sound 1",
                        dataLive['sound1'],
                        type: 1, onTap: () async {
                      await _databaseReference
                          .child(FirebaseStructure.LIVEDATA)
                          .child('sound1')
                          .set(true);
                    }),
                  if (dataLive != null)
                    getLiveTile(Icons.speaker_group_outlined, "Sound 2",
                        dataLive['sound2'],
                        type: 1, onTap: () async {
                      await _databaseReference
                          .child(FirebaseStructure.LIVEDATA)
                          .child('sound2')
                          .set(true);
                    }),
                  if (dataLive != null)
                    getLiveTile(Icons.speaker_group_outlined, "Sound 3",
                        dataLive['sound3'],
                        type: 1, onTap: () async {
                      await _databaseReference
                          .child(FirebaseStructure.LIVEDATA)
                          .child('sound3')
                          .set(true);
                    }),
                  if (dataLive != null)
                    getLiveTile(Icons.speaker_group_outlined, "Sound 4",
                        dataLive['sound4'],
                        type: 1, onTap: () async {
                      await _databaseReference
                          .child(FirebaseStructure.LIVEDATA)
                          .child('sound4')
                          .set(true);
                    }),
                  if (dataLive != null)
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            getHorizontalCard(Icons.food_bank_outlined,
                                'Food Level', dataLive['food-level'],
                                symbol: '%', showProgressAnimation: true),
                            getHorizontalCard(Icons.water_drop_outlined,
                                'Water Level', dataLive['water-level'],
                                symbol: '%', showProgressAnimation: true)
                          ],
                        ))
                ],
              )),
        ));
  }

  void getData() {
    _databaseReference
        .child(FirebaseStructure.LIVEDATA)
        .onValue
        .listen((DatabaseEvent data) async {
      setState(() {
        dataLive = data.snapshot.value;
      });
    });
  }

  void initNotifications() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        _databaseReference
            .child(FirebaseStructure.NOTIFY)
            .onValue
            .listen((DatabaseEvent data) async {
          dynamic noti = data.snapshot.value;
          if (noti['istrue'] == true) {
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: -1,
                    channelKey: 'emergency_doggyfeed',
                    title: 'Notification',
                    body: noti['message'].toString()));

            await _databaseReference
                .child(FirebaseStructure.NOTIFY)
                .child('istrue')
                .set(false);
          }
        });
      }
    });
  }

  Widget getLiveTile(IconData icon, String title, dynamic value,
      {String? symbol,
      int type = 0,
      void Function(int?)? onToggle,
      void Function()? onTap,
      void Function(double)? onChangeEnd,
      int expandedFlex = 0}) {
    return Expanded(
        flex: expandedFlex,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Card(
            color: (value is bool && value) ? color10 : color6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                  leading: Icon(
                    icon,
                    color: colorPrimary,
                    size: displaySize.width * 0.08,
                  ),
                  title: Text(
                    title.toString(),
                    style: TextStyle(
                        color: color15,
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0),
                  ),
                  subtitle: (type == 2)
                      ? Slider(
                          activeColor: colorPrimary,
                          inactiveColor: colorGrey,
                          value: value.toDouble(),
                          max: 100,
                          divisions: 100,
                          onChangeEnd: onChangeEnd,
                          onChanged: (double value) {},
                        )
                      : null,
                  trailing: ((type == 1)
                      ? ((value)
                          ? Icon(
                              Icons.play_circle_fill_outlined,
                              color: colorPrimary,
                              size: 35.0,
                            )
                          : GestureDetector(
                              onTap: onTap,
                              child: Icon(
                                Icons.play_circle_fill_outlined,
                                color: colorGrey,
                                size: 35.0,
                              ),
                            ))
                      : Text(
                          '$value ${symbol ?? ''}',
                          style: TextStyle(
                              color: color15,
                              fontWeight: FontWeight.w400,
                              fontSize: 25.0),
                        ))),
            ),
          ),
        ));
  }

  Widget getHorizontalCard(IconData icon, String title, dynamic value,
      {String? symbol, bool showProgressAnimation = false}) {
    return Expanded(
        flex: 1,
        child: Card(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (showProgressAnimation && value is int)
                LiquidLinearProgressIndicator(
                  value: double.parse(value.toString()) / 100,
                  valueColor: AlwaysStoppedAnimation(color10),
                  backgroundColor: Colors.white,
                  direction: Axis.vertical,
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: colorPrimary,
                    size: displaySize.width * 0.08,
                  ),
                  Text(
                    '$value ${symbol ?? ''}',
                    style: TextStyle(
                        color: color15,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: color15,
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
