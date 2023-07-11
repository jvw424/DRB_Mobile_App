import 'package:collection/collection.dart';
import 'package:drb_app/models/LotLocations.dart';
import 'package:drb_app/providers/SubmitProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Submit extends StatelessWidget {
  LotLocation location;
  Submit({super.key, required this.location});

  TextEditingController depositController = TextEditingController(text: '0');

  TextEditingController bagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final subProv = Provider.of<SubmitProvider>(context, listen: false);

    Widget pickup() {
      if (subProv.getSubmit!.pickUpTotal != 0) {
        String sups = '';
        for (var a in subProv.getSubmit!.pickupSups!) {
          if (a == subProv.getSubmit!.pickupSups!.last) {
            var arr = a!.split(' ');
            sups += (arr[0]);
          } else {
            var arr = a!.split(' ');
            sups += (arr[0]) + ", ";
          }
        }

        return Row(
          children: [
            Flexible(
              child: TextFormField(
                  enableInteractiveSelection: false,
                  initialValue: sups,
                  readOnly: true,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  decoration: const InputDecoration(
                    icon: FaIcon(FontAwesomeIcons.truckPickup),
                    labelText: 'Pickup Supervisor',
                  )),
            ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: TextFormField(
                  enableInteractiveSelection: false,
                  initialValue: subProv.getSubmit!.pickUpTotal.toString(),
                  readOnly: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: "Cash Pickup",
                  )),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '${location.name} Submission',
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 40,
          margin: const EdgeInsets.all(10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 4.0, //buttons Material shadow
              side: const BorderSide(
                  color: Colors.black, width: 1, style: BorderStyle.solid),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0)), // set the buttons shape. Make its birders rounded etc
              alignment: Alignment.center, //set the button's child Alignment
            ),
            onPressed: () async {
              if (subProv.getSubmit!.depositTotal == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Input Deposit")));
                return;
              }

              if (subProv.getSubmit!.bagNum == null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Input Bag #")));

                return;
              }

              if (subProv.getSubmit!.ccStart!.isNotEmpty) {
                for (var time in subProv.getSubmit!.ccEnd!) {
                  // ignore: unrelated_type_equality_checks
                  if (time == 'null' || time == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Input End Times")));

                    return;
                  }
                }

                for (int i = 0; i < subProv.getSubmit!.ccStart!.length; i++) {
                  if (DateFormat("h:mm a M/d/yy")
                      .parse(subProv.getSubmit!.ccStart![i]!)
                      .isAfter(DateFormat("h:mm a M/d/yy")
                          .parse(subProv.getSubmit!.ccEnd![i]!))) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Incorrect Dates")));

                    return;
                  }
                }
              }

              await subProv.submitDrb();

              Navigator.popUntil(
                  context, (Route<dynamic> route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Saved Successfully")));
            },
            child: const Text(
              'Submit DRB',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 69),
          child: SingleChildScrollView(
              child: Card(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Form(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 4, right: 4, bottom: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              AppBar(
                                automaticallyImplyLeading: false,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Consumer<SubmitProvider>(
                                      builder: (context, subCon, child) {
                                        return Text(
                                            'Cash: \$${subCon.getSubmit!.cashTot.toString()}',
                                            style: const TextStyle(
                                                fontSize: 16.0));
                                      },
                                    ),
                                    Consumer<SubmitProvider>(
                                      builder: (context, subCon, child) {
                                        return Text(
                                            'Credit: \$${subCon.getSubmit!.credTot.toString()}',
                                            style: const TextStyle(
                                                fontSize: 16.0));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 4.0,
                                            left: 4.0,
                                            right: 4.0,
                                          ),
                                          child: Consumer<SubmitProvider>(
                                              builder:
                                                  (context, subCon, child) {
                                            TextEditingController
                                                overShortController =
                                                TextEditingController(
                                                    text: subCon
                                                        .getSubmit!.overShort
                                                        .toString());
                                            return TextFormField(
                                                enableInteractiveSelection:
                                                    false,
                                                readOnly: true,
                                                controller: overShortController,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                    labelText: 'Over/Short',
                                                    icon: FaIcon(
                                                      FontAwesomeIcons
                                                          .rightLeft,
                                                      color: subCon.getSubmit!
                                                                  .overShort ==
                                                              0
                                                          ? Colors.grey
                                                          : subCon.getSubmit!
                                                                      .overShort >
                                                                  0
                                                              ? Colors
                                                                  .green[100]!
                                                              : Colors
                                                                  .red[100]!,
                                                    )));
                                          }))),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Consumer<SubmitProvider>(
                                        builder: (context, subCon, child) {
                                          return TextFormField(
                                            enableInteractiveSelection: false,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textAlign: TextAlign.center,
                                            onChanged: (val) {
                                              if (val.isNotEmpty) {
                                                subCon.depositInput(val);
                                              }
                                            },
                                            onFieldSubmitted: (val) {
                                              if (val.isNotEmpty) {
                                                subCon.depositInput(val);
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                labelText: 'Deposit Total',
                                                icon: FaIcon(FontAwesomeIcons
                                                    .moneyBill)),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              pickup(),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                        left: 8.0,
                                        right: 8.0,
                                      ),
                                      child: TextFormField(
                                          enableInteractiveSelection: false,
                                          readOnly: true,
                                          initialValue:
                                              subProv.getSubmit!.supervisor,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                          decoration: const InputDecoration(
                                            labelText: 'Supervisor',
                                          )),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0, left: 8.0, right: 8.0),
                                      child: TextFormField(
                                        enableInteractiveSelection: false,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                        textAlign: TextAlign.center,
                                        onChanged: (val) {
                                          subProv.bagInput(val);
                                        },
                                        onFieldSubmitted: (val) {
                                          subProv.bagInput(val);
                                        },
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                            labelText: 'Bag #',
                                            labelStyle: TextStyle(fontSize: 12),
                                            icon: Icon(
                                                Icons.shopping_bag_outlined)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                initiallyExpanded: false,
                                title: Text('Shift Times',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700])),
                                children: [
                                  SizedBox(
                                    height: subProv
                                                .getSubmit!.attendants!.length <
                                            3
                                        ? MediaQuery.of(context).size.height *
                                            (subProv.getSubmit!.attendants!
                                                    .length *
                                                .075)
                                        : MediaQuery.of(context).size.height *
                                            (.2),
                                    child: ListView.builder(
                                        //shrinkWrap: true,
                                        itemCount: subProv
                                            .getSubmit!.attendants!.length,
                                        itemBuilder: (context, index) {
                                          Future<TimeOfDay?> pickTime() =>
                                              showTimePicker(
                                                  context: context,
                                                  initialTime:
                                                      TimeOfDay.fromDateTime(
                                                          DateFormat("h:mm a")
                                                              .parse(
                                                                  "8:00 AM")));
                                          Future pickDateTime(
                                              bool isStart) async {
                                            DateTime input = DateTime.now();

                                            TimeOfDay? time = await pickTime();
                                            if (time == null) return;

                                            if (isStart) {
                                              subProv.startTimeInput(
                                                  DateTime(
                                                    input.year,
                                                    input.month,
                                                    input.day,
                                                    time.hour,
                                                    time.minute,
                                                  ),
                                                  index);
                                            } else {
                                              subProv.endTimeInput(
                                                  DateTime(
                                                    input.year,
                                                    input.month,
                                                    input.day,
                                                    time.hour,
                                                    time.minute,
                                                  ),
                                                  index);
                                            }
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Container(
                                              color: Colors.blueGrey[50],
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: Text(subProv
                                                          .getSubmit!
                                                          .attendants![index]!),
                                                    ),
                                                    Flexible(
                                                      flex: 2,
                                                      child: ElevatedButton(
                                                          onPressed: () async {
                                                        await pickDateTime(
                                                            true);
                                                      }, child: Consumer<
                                                              SubmitProvider>(
                                                        builder: (context,
                                                            subCon, child) {
                                                          var txt = subCon
                                                                  .getSubmit!
                                                                  .startTimes![
                                                              index];

                                                          return txt == 'null'
                                                              ? const Text(
                                                                  'Start',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )
                                                              : Text(
                                                                  txt!,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                );
                                                        },
                                                      )),
                                                    ),
                                                    Flexible(
                                                      flex: 2,
                                                      child: ElevatedButton(
                                                          onPressed: () async {
                                                        await pickDateTime(
                                                            false);
                                                      }, child: Consumer<
                                                              SubmitProvider>(
                                                        builder: (context,
                                                            subCon, child) {
                                                          var txt = subCon
                                                              .getSubmit!
                                                              .endTimes![index];
                                                          return txt == 'null'
                                                              ? const Text(
                                                                  'End',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )
                                                              : Text(
                                                                  txt!,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                );
                                                        },
                                                      )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, left: 18.0),
                                  child: Container(
                                    child: subProv.getSubmit!.ccStart!.isEmpty
                                        ? SizedBox.shrink()
                                        : Text(
                                            'CC Times:',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[700]),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: subProv.getSubmit!.ccStart!.length < 3
                                    ? MediaQuery.of(context).size.height *
                                        (subProv.getSubmit!.ccStart!.length *
                                            .075)
                                    : MediaQuery.of(context).size.height * (.2),

                                // for list of items
                                child: ListView.builder(
                                    //shrinkWrap: true,
                                    itemCount:
                                        subProv.getSubmit!.ccStart!.length,
                                    itemBuilder: (context, index) {
                                      Future<DateTime?> pickDate() =>
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(3000),
                                          );

                                      Future<TimeOfDay?> pickTime() =>
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                      Future pickDateTime() async {
                                        DateTime? input = await pickDate();
                                        if (input == null) return;

                                        TimeOfDay? time = await pickTime();
                                        if (time == null) return;

                                        subProv.ccEndInput(
                                            DateTime(
                                              input.year,
                                              input.month,
                                              input.day,
                                              time.hour,
                                              time.minute,
                                            ),
                                            index);
                                      }

                                      return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                              left: 8.0,
                                              right: 8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                      '${subProv.getSubmit!.ccStart!.elementAt(index)}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.black87)),
                                                  ElevatedButton(onPressed:
                                                      () async {
                                                    await pickDateTime();
                                                  }, child:
                                                      Consumer<SubmitProvider>(
                                                    builder: (context, subCon,
                                                        child) {
                                                      var txt = subCon
                                                          .getSubmit!
                                                          .ccEnd![index];
                                                      return txt == 'null'
                                                          ? const Text(
                                                              'CC End',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )
                                                          : Text(
                                                              txt!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            );
                                                    },
                                                  )),
                                                ],
                                              ),
                                            ],
                                          ));
                                    }),
                              ),
                              ExpansionTile(
                                initiallyExpanded: false,
                                title: Text('Breakdown',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700])),
                                children: [
                                  Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(1.5),
                                        1: FlexColumnWidth(2),
                                        2: FlexColumnWidth(2),
                                        3: FlexColumnWidth(2),
                                        4: FlexColumnWidth(2),
                                      },
                                      border: TableBorder.all(
                                          color: Colors.black, width: 1),
                                      children: subProv.getTable)
                                ],
                              ),
                              ExpansionTile(
                                maintainState: true,
                                initiallyExpanded: false,
                                title: Text('Notes',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700])),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40),
                                    child: TextFormField(
                                      maxLines: 4,
                                      enableInteractiveSelection: false,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black),
                                      textAlign: TextAlign.center,
                                      onChanged: (val) {
                                        subProv.notesInput(val);
                                      },
                                      onFieldSubmitted: (val) {
                                        subProv.notesInput(val);
                                      },
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(fontSize: 12),
                                          icon: Icon(Icons.notes)),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ))))),
        ));
  }
}
