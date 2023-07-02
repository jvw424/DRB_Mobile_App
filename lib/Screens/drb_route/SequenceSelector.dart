import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:drb_app/Screens/drb_route/RateEditor.dart';
import 'package:drb_app/models/Rate.dart';
import 'package:drb_app/models/Sequence.dart';
import 'package:drb_app/providers/AttendantProvider.dart';
import 'package:drb_app/providers/SeqProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SequenceSelector extends StatelessWidget {
  final String location;
  SequenceSelector({
    super.key,
    required this.location,
  });

  final GlobalKey<AutoCompleteTextFieldState<String>> textKey = GlobalKey();

  int colSelected = 10;
  TextEditingController newSeqNum = TextEditingController(text: '');
  TextEditingController newSeqStartCod = TextEditingController(text: '');
  int? prevSelected;
  DateTime? inputTime;
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

  Widget atViewOption(BuildContext context) {
    return Consumer<AttendantProvider>(
      builder: (context, atProv, child) {
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
      },
    );
  }

  Widget typeAheadList(BuildContext context) {
    final atProv = Provider.of<AttendantProvider>(context, listen: false);

    return ListTile(
      title: SimpleAutoCompleteTextField(
          style: const TextStyle(fontSize: 20),
          key: textKey,
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

  createDeleteDialog(BuildContext context, int dIndex) {
    final seqProv = Provider.of<SeqProvider>(context, listen: false);
    Color col = wList[seqProv.getSeqs[dIndex].color];
    String seqNum = seqProv.getSeqs[dIndex].rates[0].startNumber.toString();
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(content:
              StatefulBuilder(builder: (BuildContext context, setState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const ListTile(
                      title: Text(
                    'Please confirm sequence delete for:',
                    textAlign: TextAlign.center,
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: col,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
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
                            seqNum,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.grey,
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
                          onPressed: () async {
                            seqProv.deleteSeqs(dIndex, location);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete'))
                    ],
                  )
                ],
              ),
            );
          }));
        });
  }

  Widget prompter() {
    return Consumer<SeqProvider>(
      builder: (context, seqProv, child) {
        if (seqProv.getSeqs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 15, bottom: 5),
            child: Text('Add a new Sequence', style: TextStyle(fontSize: 18)),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              'Sequences with Start Number:',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
      },
    );
  }

  createNewDialog(BuildContext context) {
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

              inputTime = DateTime(
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
                  const Text('New Sequence'),
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      child: inputTime == null
                          ? const Text('CC Start')
                          : Text(
                              DateFormat('h:mm a M/d/yy').format(inputTime!))),
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
                                      MediaQuery.of(context).size.height * .15,
                                  width: MediaQuery.of(context).size.width * .2,
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
                                            setState(() => prevSelected = null);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: wList[curColor],
                                            disabledForegroundColor:
                                                Colors.red.withOpacity(0.38),
                                            disabledBackgroundColor: Colors.red
                                                .withOpacity(
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
                                                borderRadius: BorderRadius.circular(
                                                    20.0)), // set the buttons shape. Make its birders rounded etc
                                            alignment: Alignment
                                                .center, //set the button's child Alignment
                                          ),
                                          child: Text(
                                            credTime,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 14),
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
                                (inputTime != null ||
                                    prevSelectedTime != null)) {
                              if (inputTime != null) {
                                prevSelectedTime = DateFormat('h:mm a M/d/yy')
                                    .format(inputTime!);
                              }

                              Sequence newSeq = Sequence(
                                  rates: [
                                    Rate(
                                      startNumber:
                                          int.parse(newSeqNum.text.trim()),
                                      startCod:
                                          int.parse(newSeqStartCod.text.trim()),
                                      shortTimes: {},
                                      attendants: [],
                                    )
                                  ],
                                  startCredit: prevSelectedTime!,
                                  color: colSelected);

                              seqProv.addSeqs(seq: newSeq, loc: location);

                              Navigator.pop(context);
                              FocusScope.of(context).unfocus();
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

  @override
  Widget build(BuildContext context) {
    final atProv = Provider.of<AttendantProvider>(context, listen: false);
    final seqProv = Provider.of<SeqProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("$location Sequences"),
      ),
      body: seqProv.getVisited.isNotEmpty
          ? Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //button's fill color

                            elevation: 4.0, //buttons Material shadow

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0)), // set the buttons shape. Make its birders rounded etc
                            alignment: Alignment
                                .center, //set the button's child Alignment
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.navigate_next,
                              ),
                              Text(
                                'Load Saved Data',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            int curIdx = seqProv.popVisited();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RateEditor(
                                        idx: curIdx,
                                        location: location,
                                        wasVisited: true)));
                          }),
                    ],
                  ),
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 42.0),
                            child: typeAheadList(context),
                          ),
                          Container(
                              height: constraints.maxHeight * .35,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 0.5,
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              child: atViewOption(context)),
                          prompter(),
                          Consumer<SeqProvider>(
                              builder: (context, seqCon, child) {
                            return SizedBox(
                              height: constraints.maxHeight * .35,

                              // for list of items
                              child: ListView.builder(
                                  //shrinkWrap: true,
                                  itemCount: seqCon.getSeqs.length,
                                  itemBuilder: (context, idx) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, left: 8.0, right: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: wList[
                                                seqCon.getSeqs[idx].color],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            border: Border.all(
                                              width: 0.5,
                                              color: Colors.black,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                          child: ListTile(
                                            //onLongPress: ,
                                            dense: true,

                                            title: Center(
                                              child: Text(
                                                seqCon.getSeqs[idx].rates[0]
                                                    .startNumber
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            leading: IconButton(
                                                onPressed: () {
                                                  createDeleteDialog(
                                                      context, idx);
                                                },
                                                icon: const Icon(
                                                    Icons.delete_outline)),
                                            trailing: IconButton(
                                                color: Colors.black,
                                                icon: const Icon(
                                                  Icons.navigate_next,
                                                ),
                                                onPressed: () {
                                                  if (atProv.getSelectedAts
                                                      .isNotEmpty) {
                                                    List<String> myList =
                                                        List.from(atProv
                                                            .getSelectedAts);

                                                    seqCon.setSaved(idx, true);

                                                    seqCon.addAt(myList, idx);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    RateEditor(
                                                                      location:
                                                                          location,
                                                                      idx: idx,
                                                                      wasVisited:
                                                                          false,
                                                                    )));
                                                    atProv.clearSelectedAts();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Please Add Attendant First")));
                                                  }
                                                }),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          }),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.black, //button's fill color

                                elevation: 4.0, //buttons Material shadow

                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0)), // set the buttons shape. Make its birders rounded etc
                                alignment: Alignment
                                    .center, //set the button's child Alignment
                              ),
                              onPressed: () {
                                newSeqStartCod.clear();
                                newSeqNum.clear();
                                colSelected = 10;
                                prevSelected = null;
                                prevSelectedTime = null;
                                inputTime = null;

                                createNewDialog(context);
                              },
                              child: const Text('Add new Sequence'))
                        ],
                      ),
                    ));
              },
            ),
    );
  }
}
