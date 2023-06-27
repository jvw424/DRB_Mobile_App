import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:drb_app/widgets/AmPm.dart';
import 'package:drb_app/widgets/MyHours.dart';
import 'package:drb_app/widgets/MyMinutes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Submit extends StatelessWidget {
  String location;
  Submit({super.key, required this.location});

  int cashTotal = 0;
  int creditTotal = 0;
  int difference = 0;

  DateTime ahora = DateTime.now();
  List<String> allAts = [];
  Map<String, List<DateTime>> mapAtts = {};

  List<String> supList = [];
  String supervisor = '';

  Map<String, dynamic> endTimes = {};
  Set<String> timesUsed = {};
  Set<String> creditsUsed = {};

  GlobalKey<AutoCompleteTextFieldState<String>> AutoKey = GlobalKey();

  TextEditingController depositController = TextEditingController(text: '0');
  TextEditingController differenceController = TextEditingController(text: '0');
  TextEditingController bagController = TextEditingController();

  final FixedExtentScrollController _controller = FixedExtentScrollController();
  final FixedExtentScrollController _controller2 = FixedExtentScrollController();

  Color getColor(int isRed) {
    if (difference > 0) {
      return Colors.green[100]!;
    } else if (difference == 0) {
      return Colors.grey;
    } else {
      return Colors.red[100]!;
    }
  }

  Widget typeAheadList() {
    return ListTile(
      title: SimpleAutoCompleteTextField(
          style: const TextStyle(fontSize: 20),
          key: AutoKey,
          decoration: const InputDecoration(hintText: "Supervisor"),
          controller: TextEditingController(text: ""),
          suggestions: supList,
          submitOnSuggestionTap: true,
          clearOnSubmit: false,
          textSubmitted: (text) {
            //todo

            if (!supList.contains(text)) {
              String nText = "";

              if (text.contains(' ')) {
                var arr = text.split(' ');
                for (var word in arr) {
                  nText += '${word[0].toUpperCase()}${word.substring(1)} ';
                }
              } else {
                nText = text[0].toUpperCase() + text.substring(1);
              }
              supList.add(nText);
            }
          }),
    );
  }

  Widget oneLabel(idx) {
    if (mapAtts[allAts[idx]]![0].year == 2012 ||
        mapAtts[allAts[idx]]![1].year == 2012) {
      return const SizedBox.shrink();
    } else {
      return IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            mapAtts[allAts[idx]]![0] =
                DateTime(2012, ahora.month, ahora.day, 1, 0);
            mapAtts[allAts[idx]]![1] =
                DateTime(2012, ahora.month, ahora.day, 1, 0);
            //TODO createTimeDialog(idx);
          });
    }
  }

  Widget shiftOption(int idx) {
    if (mapAtts[allAts[idx]]![0].year == 2012 ||
        mapAtts[allAts[idx]]![1].year == 2012) {
      return IconButton(
          icon: const Icon(Icons.access_time),
          onPressed: () {
            //createTimeDialog(context, idx);
          });
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Text('${DateFormat('h').format(mapAtts[allAts[idx]]![0])}-${DateFormat('h a').format(mapAtts[allAts[idx]]![1])}'),
      );
    }
  }

  Widget timeOption(String key) {
    DateTime creditEnd;
    if (!endTimes.keys.contains(key)) {
      return const Flexible(
        child:
            Padding(padding: EdgeInsets.only(right: 4.0), child: Placeholder()

                // DatetimePickerWidget(
                //   dateTime: creditEnd,
                //   label: 'End',
                //   setTime: (DateTime d) {
                //     setState(() {
                //       creditEnd = d;
                //       endTimes[key] = DateFormat('h:mm a M/d/yy').format(d);
                //     });
                //   },
                // ),
                ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("End: " + endTimes[key]),
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                endTimes.remove(key);
              }),
        ],
      );
    }
  }

  createTimeDialog(BuildContext context, int idx) {
    return showDialog(
        context: context,
        builder: (context) {
          DateTime startTime = mapAtts[allAts[idx]]![0];
          DateTime endTime = mapAtts[allAts[idx]]![1];
          String timeHelpStart = ' AM';
          String timeHelpEnd = ' AM';

          return AlertDialog(content:
              StatefulBuilder(builder: (BuildContext context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              width: MediaQuery.of(context).size.width * .9,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      allAts[idx],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Start Time :${DateFormat('h:mm').format(startTime)}$timeHelpStart',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: 300,
                        decoration: BoxDecoration(color: Colors.grey[300]),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                                color: Colors.black,
                                width: .5,
                                style: BorderStyle.solid)),
                        height: MediaQuery.of(context).size.height * .2,
                        width: MediaQuery.of(context).size.width * .8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // hours wheel
                            SizedBox(
                              width: 70,
                              child: ListWheelScrollView.useDelegate(
                                onSelectedItemChanged: (val) {
                                  int sameMin = startTime.minute;
                                  setState(() => startTime = DateTime(
                                      ahora.year,
                                      ahora.month,
                                      ahora.day,
                                      val + 1,
                                      sameMin));
                                },
                                controller: _controller,
                                itemExtent: 30,
                                perspective: 0.005,
                                diameterRatio: 1.2,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 12,
                                  builder: (context, index) {
                                    return MyHours(
                                      hours: index + 1,
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            // minutes wheel
                            SizedBox(
                              width: 70,
                              child: ListWheelScrollView.useDelegate(
                                onSelectedItemChanged: (val) {
                                  int sameHour = startTime.hour;

                                  setState(() => startTime = DateTime(
                                      ahora.year,
                                      ahora.month,
                                      ahora.day,
                                      sameHour,
                                      val * 15));
                                },
                                itemExtent: 30,
                                perspective: 0.005,
                                diameterRatio: 1.2,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 4,
                                  builder: (context, index) {
                                    return MyMinutes(
                                      mins: (index) * 15,
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 15,
                            ),

                            // am or pm
                            SizedBox(
                              width: 70,
                              child: ListWheelScrollView.useDelegate(
                                onSelectedItemChanged: (val) {
                                  if (val == 1) {
                                    setState(() => timeHelpStart = ' PM');
                                  } else {
                                    setState(() => timeHelpStart = ' AM');
                                  }
                                },
                                itemExtent: 30,
                                perspective: 0.005,
                                diameterRatio: 1.2,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 2,
                                  builder: (context, index) {
                                    if (index == 0) {
                                      return const AmPm(
                                        isItAm: true,
                                      );
                                    } else {
                                      return const AmPm(
                                        isItAm: false,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'End Time :${DateFormat('h:mm').format(endTime)}$timeHelpEnd',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: 300,
                        decoration: BoxDecoration(color: Colors.grey[300]),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                                color: Colors.black,
                                width: .5,
                                style: BorderStyle.solid)),
                        height: MediaQuery.of(context).size.height * .2,
                        width: MediaQuery.of(context).size.width * .8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // hours wheel
                            SizedBox(
                              width: 70,
                              child: ListWheelScrollView.useDelegate(
                                onSelectedItemChanged: (val) {
                                  int sameMin = endTime.minute;
                                  setState(() => endTime = DateTime(
                                      ahora.year,
                                      ahora.month,
                                      ahora.day,
                                      val + 1,
                                      sameMin));
                                },
                                controller: _controller2,
                                itemExtent: 30,
                                perspective: 0.005,
                                diameterRatio: 1.2,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 12,
                                  builder: (context, index) {
                                    return MyHours(
                                      hours: index + 1,
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            // minutes wheel
                            SizedBox(
                              width: 70,
                              child: ListWheelScrollView.useDelegate(
                                onSelectedItemChanged: (val) {
                                  int sameHour = endTime.hour;
                                  setState(() => endTime = DateTime(
                                      ahora.year,
                                      ahora.month,
                                      ahora.day,
                                      sameHour,
                                      val * 15));
                                },
                                itemExtent: 30,
                                perspective: 0.005,
                                diameterRatio: 1.2,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 4,
                                  builder: (context, index) {
                                    return MyMinutes(
                                      mins: (index) * 15,
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 15,
                            ),

                            // am or pm
                            SizedBox(
                              width: 70,
                              child: ListWheelScrollView.useDelegate(
                                onSelectedItemChanged: (val) {
                                  if (val == 1) {
                                    setState(() => timeHelpEnd = ' PM');
                                  } else {
                                    setState(() => timeHelpEnd = ' AM');
                                  }
                                },
                                itemExtent: 30,
                                perspective: 0.005,
                                diameterRatio: 1.2,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 2,
                                  builder: (context, index) {
                                    if (index == 0) {
                                      return const AmPm(
                                        isItAm: true,
                                      );
                                    } else {
                                      return const AmPm(
                                        isItAm: false,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              disabledForegroundColor:
                                  Colors.orange.withOpacity(0.38),
                              disabledBackgroundColor: Colors.orange.withOpacity(
                                  0.12), //specify the button's disabled text, icon, and fill color
                              shadowColor: Colors
                                  .black, //specify the button's elevation color
                              elevation: 4.0, //buttons Material shadow
                              textStyle: const TextStyle(
                                  fontFamily:
                                      'roboto'), //specify the button's text TextStyle
                              padding: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 4.0,
                                  right: 8.0,
                                  left: 8.0), //specify the button's Padding
                              side: const BorderSide(
                                  color: Colors.black,
                                  width: .5,
                                  style: BorderStyle
                                      .solid), //set border for the button
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0)), // set the buttons shape. Make its birders rounded etc
                              alignment: Alignment
                                  .center, //set the button's child Alignment
                            ),
                            onPressed: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: const Text('Cancel')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              disabledForegroundColor:
                                  Colors.orange.withOpacity(0.38),
                              disabledBackgroundColor: Colors.orange.withOpacity(
                                  0.12), //specify the button's disabled text, icon, and fill color
                              shadowColor: Colors
                                  .black, //specify the button's elevation color
                              elevation: 4.0, //buttons Material shadow
                              textStyle: const TextStyle(
                                  fontFamily:
                                      'roboto'), //specify the button's text TextStyle
                              padding: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 4.0,
                                  right: 8.0,
                                  left: 8.0), //specify the button's Padding
                              side: const BorderSide(
                                  color: Colors.black,
                                  width: .5,
                                  style: BorderStyle
                                      .solid), //set border for the button
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0)), // set the buttons shape. Make its birders rounded etc
                              alignment: Alignment
                                  .center, //set the button's child Alignment
                            ),
                            onPressed: () {
                              DateFormat format =
                                  DateFormat('yyyy-MM-dd h:mm a');

                              setState(() => mapAtts[allAts[idx]]![0] =
                                  format.parse('${ahora.year}-${ahora.month}-${ahora.day} ${DateFormat('h:mm').format(startTime)}$timeHelpStart'));
                              setState(() => mapAtts[allAts[idx]]![1] =
                                  format.parse('${ahora.year}-${ahora.month}-${ahora.day} ${DateFormat('h:mm').format(endTime)}$timeHelpEnd'));

                              Navigator.pop(context);
                            },
                            child: const Text('Submit'))
                      ],
                    ),
                  )
                ],
              ),
            );
          }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '$location Submission',
          ),
        ),
        body: SingleChildScrollView(
            child: Card(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(4.0)),
                child: Form(
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            AppBar(
                              automaticallyImplyLeading: false,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Cash: \$$cashTotal',
                                      style: const TextStyle(fontSize: 16.0)),
                                  Text('Credit: \$$creditTotal',
                                      style: const TextStyle(fontSize: 16.0)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 4.0,
                                        left: 4.0,
                                        right: 4.0,
                                      ),
                                      child: TextFormField(
                                        enabled: false,
                                        controller: differenceController,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            labelText: 'Over/Short',
                                            icon: FaIcon(
                                              FontAwesomeIcons.rightLeft,
                                              color: getColor(difference),
                                            )),

                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Text('Over/Short',
                                        //         style: TextStyle(
                                        //             fontSize: 12,
                                        //             color: Colors.grey[700])),
                                        //     Text(difference.toString(),
                                        //         style: TextStyle(
                                        //             backgroundColor:
                                        //                 getColor(difference),
                                        //             color: Colors.black)),
                                        //     Text('Over/Short',
                                        //         style: TextStyle(
                                        //             fontSize: 12,
                                        //             color: Colors.transparent))
                                        //   ],
                                        // ),
                                      )),
                                ),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      controller: depositController,
                                      onTap: () {
                                        //todo
                                      },
                                      onChanged: (val) {
                                        difference =
                                            int.parse(depositController.text) -
                                                cashTotal;
                                        //todo
                                      },
                                      onFieldSubmitted: (val) {
                                        difference =
                                            int.parse(depositController.text) -
                                                cashTotal;

                                        differenceController.text =
                                            difference.toString();
                                      },
                                      keyboardType: TextInputType.phone,
                                      validator: (val) => int.parse(val!) > 0
                                          ? null
                                          : "Enter Valid Start Number",
                                      decoration: const InputDecoration(
                                          labelText: 'Deposit Total',
                                          icon: FaIcon(
                                              FontAwesomeIcons.moneyBill)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            typeAheadList(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8.0, left: 8.0, right: 8.0),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: bagController,
                                onTap: () {
                                  //todo
                                  bagController.clear();
                                },
                                onFieldSubmitted: (val) {},
                                keyboardType: TextInputType.phone,
                                validator: (val) => int.parse(val!) > 0
                                    ? null
                                    : "Enter Valid Bag Number",
                                decoration: const InputDecoration(
                                    labelText: 'Bag #',
                                    labelStyle: TextStyle(fontSize: 12),
                                    icon: Icon(Icons.shopping_bag_outlined)),
                              ),
                            ),
                            SizedBox(
                              height: 13,
                              width: MediaQuery.of(context).size.width * 8,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text('Shift Times',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700])),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: allAts.length,
                              itemBuilder: (context, index) => Center(
                                child: ListTile(
                                    dense: true,
                                    title: Center(
                                      child: Text(
                                        allAts[index],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    leading: oneLabel(index),
                                    trailing: shiftOption(index)),
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: creditsUsed.length,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    String key = creditsUsed.elementAt(index);

                                    return Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Container(
                                          padding: const EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey[500]!,
                                                  width: 1.0),
                                            ),
                                          ),
                                          height: 17,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              8,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text('Credit Start/End',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[700])),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Text('Start: $key'),
                                              ),
                                            ),
                                            timeOption(key)
                                          ],
                                        ),
                                      )
                                    ]);
                                  } else {
                                    String key = creditsUsed.elementAt(index);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text('Start: $key'),
                                            ),
                                          ),
                                          timeOption(key)
                                        ],
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ))))));
  }
}
