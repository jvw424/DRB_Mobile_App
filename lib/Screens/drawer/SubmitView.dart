import 'package:collection/collection.dart';
import 'package:drb_app/models/LotLocations.dart';
import 'package:drb_app/models/SubmitInfo.dart';
import 'package:drb_app/providers/SubmitProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SubmitView extends StatelessWidget {
  SubmitView({
    super.key,
  });

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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    'Cash: \$${subProv.getSubmit!.cashTot.toString()}',
                                    style: const TextStyle(fontSize: 16.0)),
                                Text(
                                    'Credit: \$${subProv.getSubmit!.credTot.toString()}',
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
                                          initialValue: subProv
                                              .getSubmit!.overShort
                                              .toString(),
                                          enableInteractiveSelection: false,
                                          readOnly: true,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              labelText: 'Over/Short',
                                              icon: FaIcon(
                                                FontAwesomeIcons.rightLeft,
                                                color: subProv.getSubmit!
                                                            .overShort ==
                                                        0
                                                    ? Colors.grey
                                                    : subProv.getSubmit!
                                                                .overShort >
                                                            0
                                                        ? Colors.green[100]!
                                                        : Colors.red[100]!,
                                              ))))),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      enableInteractiveSelection: false,
                                      textAlign: TextAlign.center,
                                      initialValue: subProv
                                          .getSubmit!.depositTotal!
                                          .toString(),
                                      decoration: const InputDecoration(
                                          labelText: 'Deposit Total',
                                          icon: FaIcon(
                                              FontAwesomeIcons.moneyBill)),
                                    )),
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
                                          fontSize: 12, color: Colors.black),
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
                                    initialValue: subProv.getSubmit!.bagNum,
                                    readOnly: true,
                                    enableInteractiveSelection: false,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black),
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                        labelText: 'Bag #',
                                        labelStyle: TextStyle(fontSize: 12),
                                        icon:
                                            Icon(Icons.shopping_bag_outlined)),
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
                                height: subProv.getSubmit!.attendants!.length <
                                        3
                                    ? MediaQuery.of(context).size.height *
                                        (subProv.getSubmit!.attendants!.length *
                                            .075)
                                    : MediaQuery.of(context).size.height * (.2),
                                child: ListView.builder(
                                    //shrinkWrap: true,
                                    itemCount:
                                        subProv.getSubmit!.attendants!.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
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
                                                  child: Text(subProv.getSubmit!
                                                      .attendants![index]!),
                                                ),
                                                Flexible(
                                                  flex: 2,
                                                  child: ElevatedButton(
                                                      onPressed: () async {},
                                                      child: Consumer<
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
                                                      onPressed: () async {},
                                                      child: Consumer<
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
                                    (subProv.getSubmit!.ccStart!.length * .075)
                                : MediaQuery.of(context).size.height * (.2),

                            // for list of items
                            child: ListView.builder(
                                //shrinkWrap: true,
                                itemCount: subProv.getSubmit!.ccStart!.length,
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
                                          bottom: 8.0, left: 8.0, right: 8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                  '${subProv.getSubmit!.ccStart!.elementAt(index)}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87)),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                await pickDateTime();
                                              }, child:
                                                      Consumer<SubmitProvider>(
                                                builder:
                                                    (context, subCon, child) {
                                                  var txt = subCon
                                                      .getSubmit!.ccEnd![index];
                                                  return txt == 'null'
                                                      ? const Text(
                                                          'CC End',
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      : Text(
                                                          txt!,
                                                          textAlign:
                                                              TextAlign.center,
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
                            initiallyExpanded: true,
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
                            initiallyExpanded: subProv.getSubmit!.notes != null,
                            title: Text('Notes',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[700])),
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                child: TextFormField(
                                  initialValue: subProv.getSubmit!.notes,
                                  maxLines: 4,
                                  enableInteractiveSelection: false,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                  textAlign: TextAlign.center,
                                  readOnly: true,
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
