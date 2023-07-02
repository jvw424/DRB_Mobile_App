import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:drb_app/Screens/drb_route/Submit.dart';
import 'package:drb_app/models/Rate.dart';
import 'package:drb_app/models/Sequence.dart';
import 'package:drb_app/providers/AttendantProvider.dart';
import 'package:drb_app/providers/SeqProvider.dart';
import 'package:drb_app/providers/SubmitProvider.dart';
import 'package:drb_app/services/AuthService.dart';
import 'package:drb_app/Screens/drb_route/RateView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

// ignore: must_be_immutable
class RateEditor extends StatelessWidget {
  bool wasVisited;
  String location;
  int idx;
  RateEditor({
    super.key,
    required this.idx,
    required this.location,
    required this.wasVisited,
  });

  GlobalKey<AutoCompleteTextFieldState<String>> autoKey = GlobalKey();

  int colSelected = 10;
  TextEditingController newSeqNum = TextEditingController(text: '');
  TextEditingController newSeqStartCod = TextEditingController(text: '');
  int? prevSelected;
  DateTime? newSeqTime;
  String? prevSelectedTime;

  List<Color> wList = [
    Colors.red[200]!,
    Colors.orange[100]!,
    Colors.yellow[100]!,
    Colors.green[100]!,
    Colors.blue[200]!,
    Colors.grey[200]!,
    Colors.pink[100]!,
  ];

  List<ColorSwatch> cols = const <ColorSwatch>[
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.yellowAccent,
    Colors.lightGreenAccent,
    Colors.lightBlueAccent,
    Colors.grey,
    Colors.pinkAccent,
  ];

  createNewDialog(BuildContext context, List<String> newAts) {
    final seqProv = Provider.of<SeqProvider>(context, listen: false);

    Widget ticColor() {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .15,
        width: MediaQuery.of(context).size.width * .8,
        child: MaterialColorPicker(
          selectedColor: colSelected > 7 ? null : cols[colSelected],
          allowShades: false,
          colors: cols,
          onMainColorChange: (value) {
            colSelected = cols.indexOf(value!);
          },
        ),
      );
    }

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(content:
              StatefulBuilder(builder: (BuildContext context, setState) {
            Future<DateTime?> pickDate() => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(3000),
                );

            Future<TimeOfDay?> pickTime() => showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

            Future pickDateTime() async {
              DateTime? input = await pickDate();
              if (input == null) return;

              TimeOfDay? time = await pickTime();
              if (time == null) return;

              newSeqTime = DateTime(
                input.year,
                input.month,
                input.day,
                time.hour,
                time.minute,
              );
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      'Choose from available Sequences',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .22,
                    width: MediaQuery.of(context).size.width * .8,

                    // for list of items
                    child: ListView.builder(
                        //shrinkWrap: true,
                        itemCount: seqProv.getSeqs.length,
                        itemBuilder: (context, index) {
                          if (seqProv.getSeqs[index].saved) {
                            return const SizedBox.shrink();
                          } else {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, left: 8.0, right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: wList[seqProv.getSeqs[index].color],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    border: Border.all(
                                      width: 0.5,
                                      color: Colors.black54,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    title: Center(
                                      child: Text(
                                        seqProv.getSeqs[index].rates.last
                                            .startNumber
                                            .toString(),
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    trailing: IconButton(
                                        color: Colors.black,
                                        icon: const Icon(Icons.navigate_next),
                                        onPressed: () async {
                                          seqProv.setSaved(index, true);
                                          seqProv.addAt(newAts, index);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RateEditor(
                                                        idx: index,
                                                        location: location,
                                                        wasVisited: false,
                                                      )));
                                        }),
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                  ExpansionTile(
                    title: const Text('Add New Sequence'),
                    initiallyExpanded: false,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ListTile(
                                title: TextFormField(
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              controller: newSeqNum,
                              decoration: const InputDecoration(
                                labelText: 'Start Number',
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onTap: () {
                                setState(() {
                                  newSeqNum.clear();
                                });
                              },
                              onFieldSubmitted: (val) {},
                              keyboardType: TextInputType.phone,
                              validator: (val) => int.tryParse(val!) == null ||
                                      int.tryParse(val)! <= 0
                                  ? "Enter Valid Start Number"
                                  : null,
                            )),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTile(
                                title: TextFormField(
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              controller: newSeqStartCod,
                              decoration: const InputDecoration(
                                labelText: 'Start Cod',
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onTap: () {
                                setState(() {
                                  newSeqStartCod.clear();
                                });
                              },
                              onFieldSubmitted: (val) {},
                              keyboardType: TextInputType.phone,
                              validator: (val) => int.tryParse(val!) == null ||
                                      int.tryParse(val)! < 0
                                  ? "Enter Valid Start Cod"
                                  : null,
                            )),
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          'Choose Ticket Color',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ticColor(),
                      ElevatedButton(
                          onPressed: () async {
                            await pickDateTime();

                            setState(() => {});
                          },
                          child: newSeqTime == null
                              ? const Text('CC Start')
                              : Text(DateFormat('h:mm a M/d/yy')
                                  .format(newSeqTime!))),
                      Column(
                        children: [
                          const Text(
                            'Or Choose Same Credit Start Time From Previous Sequence',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.width * .8,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: seqProv.getSeqs.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  String credTime =
                                      seqProv.getSeqs[index].startCredit;

                                  int curColor = seqProv.getSeqs[index].color;

                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .15,
                                      width: MediaQuery.of(context).size.width *
                                          .2,
                                      child: Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                prevSelectedTime = credTime;
                                                setState(
                                                    () => prevSelected = index);
                                              },
                                              onLongPress: () {
                                                prevSelectedTime = null;
                                                setState(
                                                    () => prevSelected = null);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                backgroundColor:
                                                    wList[curColor],
                                                disabledForegroundColor: Colors
                                                    .red
                                                    .withOpacity(0.38),
                                                disabledBackgroundColor:
                                                    Colors.red.withOpacity(
                                                        0.12), //specify the button's disabled text, icon, and fill color
                                                shadowColor: Colors
                                                    .black, //specify the button's elevation color
                                                elevation:
                                                    4.0, //buttons Material shadow
                                                textStyle: const TextStyle(
                                                    fontFamily:
                                                        'roboto'), //specify the button's text TextStyle
                                                padding: const EdgeInsets.only(
                                                    top: 4.0,
                                                    bottom: 4.0,
                                                    right: 8.0,
                                                    left:
                                                        8.0), //specify the button's Padding
                                                side: const BorderSide(
                                                    color: Colors.black,
                                                    width: .5,
                                                    style: BorderStyle
                                                        .solid), //set border for the button
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)), // set the buttons shape. Make its birders rounded etc
                                                alignment: Alignment
                                                    .center, //set the button's child Alignment
                                              ),
                                              child: Text(
                                                credTime,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Positioned(
                                              child: Icon(Icons.check,
                                                  size: 25,
                                                  color: prevSelected == index
                                                      ? Colors.green
                                                      : Colors.transparent),
                                            ),
                                          ]),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
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
                              FocusScope.of(context).unfocus();
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
                          onPressed: () async {
                            if (newSeqStartCod.text != '' &&
                                newSeqNum.text != '' &&
                                colSelected <= 7 &&
                                (newSeqTime != null ||
                                    prevSelectedTime != null)) {
                              if (newSeqTime != null) {
                                prevSelectedTime = DateFormat('h:mm a M/d/yy')
                                    .format(newSeqTime!);
                              }

                              Sequence newSeq = Sequence(
                                  rates: [
                                    Rate(
                                      startNumber:
                                          int.parse(newSeqNum.text.trim()),
                                      startCod:
                                          int.parse(newSeqStartCod.text.trim()),
                                      shortTimes: {},
                                      attendants: newAts,
                                    )
                                  ],
                                  startCredit: prevSelectedTime!,
                                  color: colSelected);

                              seqProv.addSeqs(seq: newSeq, loc: location);

                              int nextIdx = seqProv.getLastIdx;
                              seqProv.setSaved(nextIdx, true);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RateEditor(
                                            idx: nextIdx,
                                            location: location,
                                            wasVisited: false,
                                          )));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Start number, Start COD, Color, and Time are required")));
                            }
                          },
                          child: const Text('Submit'))
                    ],
                  )
                ],
              ),
            );
          }));
        });
  }

  Widget typeAheadList(BuildContext context) {
    final atProv = Provider.of<AttendantProvider>(context, listen: false);

    return ListTile(
      title: SimpleAutoCompleteTextField(
          style: const TextStyle(fontSize: 20),
          key: autoKey,
          decoration: const InputDecoration(hintText: "Attendant"),
          controller: TextEditingController(text: ""),
          suggestions: atProv.getAts,
          submitOnSuggestionTap: true,
          clearOnSubmit: true,
          textSubmitted: (text) {
            atProv.addSelectedAts(text);

            if (!atProv.getAts.contains(text)) {
              String nText = "";

              if (text.contains(' ')) {
                var arr = text.split(' ');
                for (var word in arr) {
                  nText += '${word[0].toUpperCase()}${word.substring(1)} ';
                }
              } else {
                nText = text[0].toUpperCase() + text.substring(1);
              }
              atProv.addAttendant(nText);
            }
          }),
    );
  }

  Widget atViewOption(BuildContext context) {
    return Consumer<AttendantProvider>(builder: (context, atProv, child) {
      if (atProv.getSelectedAts.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: atProv.getSelectedAts.length,
            itemBuilder: (context, index) {
              return Center(
                child: ListTile(
                  dense: true,
                  title: Center(
                    child: Text(
                      atProv.getSelectedAts[index],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  leading: const SizedBox.shrink(),
                  trailing: IconButton(
                      color: Colors.red,
                      icon: const Icon(Icons.highlight_remove),
                      onPressed: () {
                        atProv.removeSelecetedAts(index);
                      }),
                ),
              );
            });
      }
    });
  }

  createAtDialog(BuildContext context, bool isSequnce) {
    final atProv = Provider.of<AttendantProvider>(context, listen: false);
    final seqProv = Provider.of<SeqProvider>(context, listen: false);
    atProv.clearSelectedAts();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: isSequnce
                        ? const Text(
                            'Options for next Sequence:',
                          )
                        : const Text(
                            'Options for next Rate:',
                          )),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: (MediaQuery.of(context).size.height * .05),
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: wList[seqProv.getSeqs[idx].color]),
                      onPressed: () {
                        if (isSequnce) {
                          List<String> myList = List.from(
                              seqProv.getSeqs[idx].rates.last.attendants);
                          createNewDialog(context, myList);
                        } else {
                          List<String> myList = List.from(
                              seqProv.getSeqs[idx].rates.last.attendants);

                          seqProv.addRate(idx, myList);
                          Navigator.pop(context);
                          FocusScope.of(context).unfocus();
                        }
                      },
                      child: const Text(
                        'Same Attendant',
                        style: TextStyle(color: Colors.black),
                      )),
                ),
                typeAheadList(context),
                SizedBox(
                    height: MediaQuery.of(context).size.height * .17,
                    width: MediaQuery.of(context).size.width * .9,
                    child: atViewOption(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors
                              .red, //specify the color of the button's text and icons as well as the overlay colors used to indicate the hover, focus, and pressed states
                          elevation: 4.0, //buttons Material shadow
                          textStyle: const TextStyle(
                              fontFamily:
                                  'roboto'), //specify the button's text TextStyle
                          padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 4.0,
                              right: 8.0,
                              left: 8.0), //specify the button's Padding

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0)), // set the buttons shape. Make its birders rounded etc
                          alignment: Alignment
                              .center, //set the button's child Alignment
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors
                              .blue, //specify the color of the button's text and icons as well as the overlay colors used to indicate the hover, focus, and pressed states
                          elevation: 4.0, //buttons Material shadow
                          textStyle: const TextStyle(
                              fontFamily:
                                  'roboto'), //specify the button's text TextStyle
                          padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 4.0,
                              right: 8.0,
                              left: 8.0), //specify the button's Padding

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0)), // set the buttons shape. Make its birders rounded etc
                          alignment: Alignment
                              .center, //set the button's child Alignment
                        ),
                        onPressed: () {
                          if (isSequnce) {
                            List<String> myList =
                                List.from(atProv.getSelectedAts);
                            createNewDialog(context, myList);
                          } else {
                            List<String> myList =
                                List.from(atProv.getSelectedAts);

                            seqProv.addRate(idx, myList);

                            Navigator.pop(context);
                            FocusScope.of(context).unfocus();
                          }
                        },
                        child: const Text("Done")),
                  ],
                ),
              ],
            ),
          ));
        });
  }

  createSaveDialog(
    BuildContext context,
  ) {
    final seqProv = Provider.of<SeqProvider>(context, listen: false);
    final subProv = Provider.of<SubmitProvider>(context, listen: false);

    TextEditingController pickupTextController = TextEditingController();
    Set times = {};
    List<DateTime?> inputTimes = [];

    for (var seq in seqProv.getSeqs) {
      for (var rate in seq.rates) {
        if (rate.credits != 0) {
          times.add(seq.startCredit);
        }
        if (rate.closeTimes != '') {
          times.remove(seq.startCredit);
        }
      }
    }

    for (var a in times) {
      DateTime? aTime;
      inputTimes.add(aTime);
    }

    Future<DateTime?> pickDate() => showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(3000),
        );

    Future<TimeOfDay?> pickTime() => showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(content:
              StatefulBuilder(builder: (BuildContext context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Text(
                        'Save for later',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * .9,

                    // for list of items
                    child: ListView.builder(
                        //shrinkWrap: true,
                        itemCount: times.length,
                        itemBuilder: (context, index) {
                          Future pickDateTime() async {
                            DateTime? input = await pickDate();
                            if (input == null) return;

                            TimeOfDay? time = await pickTime();
                            if (time == null) return;

                            setState(() {
                              inputTimes[index] = DateTime(
                                input.year,
                                input.month,
                                input.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }

                          return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8.0, left: 8.0, right: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('CC Start:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700])),
                                      Text(
                                        times.elementAt(index),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('        ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700])),
                                      ElevatedButton(
                                          onPressed: () async {
                                            await pickDateTime();

                                            setState(() => {});
                                          },
                                          child: inputTimes[index] == null
                                              ? const Text('CC End Time')
                                              : Text(DateFormat('h:mm a M/d/yy')
                                                  .format(inputTimes[index]!))),
                                    ],
                                  ),
                                ],
                              ));
                        }),
                  ),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.phone,
                    validator: (val) => val == '' ? "Enter #" : null,
                    controller: pickupTextController,
                    decoration: const InputDecoration(
                      labelText: 'Cash Pickup',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors
                                .red, //specify the color of the button's text and icons as well as the overlay colors used to indicate the hover, focus, and pressed states
                            elevation: 4.0, //buttons Material shadow
                            textStyle: const TextStyle(
                                fontFamily:
                                    'roboto'), //specify the button's text TextStyle
                            padding: const EdgeInsets.only(
                                top: 4.0,
                                bottom: 4.0,
                                right: 8.0,
                                left: 8.0), //specify the button's Padding

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0)), // set the buttons shape. Make its birders rounded etc
                            alignment: Alignment
                                .center, //set the button's child Alignment
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            //specify the color of the button's text and icons as well as the overlay colors used to indicate the hover, focus, and pressed states
                            elevation: 4.0, //buttons Material shadow
                            textStyle: const TextStyle(
                                fontFamily:
                                    'roboto'), //specify the button's text TextStyle
                            padding: const EdgeInsets.only(
                                top: 4.0,
                                bottom: 4.0,
                                right: 8.0,
                                left: 8.0), //specify the button's Padding

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0)), // set the buttons shape. Make its birders rounded etc
                            alignment: Alignment
                                .center, //set the button's child Alignment
                          ),
                          onPressed: () async {
                            if (times.isNotEmpty) {
                              for (var time in inputTimes) {
                                // ignore: unrelated_type_equality_checks
                                if (time == 'null' || time == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Input End Times")));

                                  return;
                                }
                              }

                              for (final pairs in IterableZip<dynamic>(
                                  [times, inputTimes])) {
                                if (DateFormat("h:mm a M/d/yy")
                                    .parse(pairs[0])
                                    .isAfter(pairs[1])) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Incorrect Dates")));

                                  return;
                                }
                              }

                              await seqProv.makeCloseTimes(
                                  IterableZip<dynamic>([times, inputTimes]));
                            }

                            if (pickupTextController.text.trim() != '') {
                              int count = 0;
                              for (var seq in seqProv.getSeqs) {
                                if (seq.saved) {
                                  count += 1;
                                }
                              }

                              var supervisor =
                                  await subProv.getSupervisorName();

                              seqProv.cashPickup(
                                  int.tryParse(
                                          pickupTextController.text.trim())! ~/
                                      count,
                                  supervisor);
                            }

                            seqProv.saveButton(location);

                            Navigator.popUntil(context,
                                (Route<dynamic> route) => route.isFirst);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Saved Successfully")));
                          },
                          child: const Text("save")),
                    ],
                  ),
                ],
              ),
            );
          }));
        });
  }

  Widget submissionOption(int color, BuildContext context) {
    final subProv = Provider.of<SubmitProvider>(context, listen: false);

    final seqProv = Provider.of<SeqProvider>(context, listen: false);
    if (seqProv.getVisited.isEmpty) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: wList[color], //button's fill color

            elevation: 10.0, //buttons Material shadow
            side: const BorderSide(
                color: Colors.black, width: 1, style: BorderStyle.solid),

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    20.0)), // set the buttons shape. Make its birders rounded etc
            alignment: Alignment.center, //set the button's child Alignment
          ),
          child: const Column(
            children: [
              Icon(
                Icons.navigate_next,
                color: Colors.black,
              ),
              Text(
                "Continue to Submission",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          onPressed: () async {
            if (seqProv.validCheck(idx)) {
              await subProv.setInfo(seqProv.getSeqs, location);
              await subProv.makeTable();

              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Submit(
                            location: location,
                          )));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Fix Rate ${seqProv.getSeqs[idx].rates.length}")));
            }
          });
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: wList[color], //button's fill color

            elevation: 4.0, //buttons Material shadow
            side: const BorderSide(
                color: Colors.black, width: 1, style: BorderStyle.solid),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    20.0)), // set the buttons shape. Make its birders rounded etc
            alignment: Alignment.center, //set the button's child Alignment
          ),
          child: const Column(
            children: [
              Icon(
                Icons.navigate_next,
                color: Colors.black,
              ),
              Text(
                'Continue',
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ],
          ),
          onPressed: () {
            int nextIdx = seqProv.popVisited();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RateEditor(
                          idx: nextIdx,
                          location: location,
                          wasVisited: true,
                        )));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final lotProv = Provider.of<LotProvider>(context);

    final seqProv = Provider.of<SeqProvider>(context, listen: false);
    // final atProv = Provider.of<AttendantProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              //await seqProv.fetchSeqs(location);
              if (wasVisited) {
                seqProv.addToVisited(idx);
              } else {
                seqProv.setSaved(idx, false);
              }
              Navigator.of(context).pop();
            }),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: wList[seqProv.getSeqs[idx].color],
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Text(
                  seqProv.getSeqs[idx].startCredit,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
              color: Colors.black,
              icon: const Icon(
                Icons.add_chart,
                size: 26,
              ),
              onPressed: () {
                if (seqProv.validCheck(idx)) {
                  if (seqProv.getVisited.isEmpty) {
                    createAtDialog(context, true);
                  } else {
                    int nextIdx = seqProv.popVisited();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RateEditor(
                                  idx: nextIdx,
                                  location: location,
                                  wasVisited: true,
                                )));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Fix Rate ${seqProv.getSeqs[idx].rates.length}")));
                }
              })
        ],
      ),
      body: RateView(idx: idx),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            seqProv.getVisited.isNotEmpty
                ? SizedBox.shrink()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: wList[seqProv.getSeqs[idx].color],
                      elevation: 4.0, //buttons Material shadow
                      side: const BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0)), // set the buttons shape. Make its birders rounded etc
                      alignment:
                          Alignment.center, //set the button's child Alignment
                    ),
                    onPressed: () {
                      if (seqProv.validCheck(idx)) {
                        createSaveDialog(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Fix Rate ${seqProv.getSeqs[idx].rates.length}")));
                      }
                    },
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.save_alt_rounded,
                            color: Colors.black,
                          ),
                          Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: wList[seqProv.getSeqs[idx].color],
                elevation: 4.0, //buttons Material shadow
                side: const BorderSide(
                    color: Colors.black, width: 1, style: BorderStyle.solid),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20.0)), // set the buttons shape. Make its birders rounded etc
                alignment: Alignment.center, //set the button's child Alignment
              ),
              onPressed: () {
                if (seqProv.validCheck(idx)) {
                  createAtDialog(context, false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Fix Rate ${seqProv.getSeqs[idx].rates.length}")));
                }
              },
              child: const Column(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  Text(
                    'Add Rate',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            submissionOption(seqProv.getSeqs[idx].color, context),
          ],
        ),
      ),
    );
  }
}
