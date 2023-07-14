import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:drb_app/Screens/drawer/DrbView.dart';
import 'package:drb_app/providers/SubmitProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PastSubmissions extends StatelessWidget {
  PastSubmissions({
    super.key,
  });

  final GlobalKey<AutoCompleteTextFieldState<String>> lotKey = GlobalKey();

  final GlobalKey<AutoCompleteTextFieldState<String>> filterKey = GlobalKey();

  DateTime? startRange;

  DateTime? endRange;

  TextEditingController locationController = TextEditingController(text: '');

  filterDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(content:
              StatefulBuilder(builder: (BuildContext context, setState) {
            final subProv = Provider.of<SubmitProvider>(context, listen: false);

            Future<DateTime?> pickDate() => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(3000),
                );

            Future pickDateTime(bool isStart) async {
              DateTime? input = await pickDate();
              if (input == null) return;

              if (isStart) {
                startRange = DateTime(
                  input.year,
                  input.month,
                  input.day,
                  1,
                  0,
                );
              } else {
                endRange = DateTime(
                  input.year,
                  input.month,
                  input.day,
                  23,
                  0,
                );
              }
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const Text('Filter'),
                  SizedBox(
                    height: 40,
                  ),
                  ListTile(
                    leading: Icon(Icons.search),
                    title: SimpleAutoCompleteTextField(
                        style: const TextStyle(fontSize: 20),
                        key: filterKey,
                        decoration: const InputDecoration(hintText: "Lot Name"),
                        controller: locationController,
                        suggestions: subProv.getLots,
                        submitOnSuggestionTap: true,
                        clearOnSubmit: false,
                        textSubmitted: (text) async {
                          if (subProv.getLots.contains(text)) {
                            locationController.text = text;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Invalid Location")));
                          }
                        }),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Date Range',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700])),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await pickDateTime(true);

                        setState(() => {});
                      },
                      child: startRange == null
                          ? const Text('Start Date')
                          : Text(
                              DateFormat('h:mm a M/d/yy').format(startRange!))),
                  ElevatedButton(
                      onPressed: () async {
                        await pickDateTime(false);

                        setState(() => {});
                      },
                      child: endRange == null
                          ? const Text('End Date')
                          : Text(
                              DateFormat('h:mm a M/d/yy').format(endRange!))),
                  SizedBox(
                    height: 40,
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
                            if (locationController.text.isNotEmpty &&
                                startRange != null &&
                                endRange != null) {
                              subProv.queryInitial(
                                locationController.text.trim(),
                                startRange!,
                                endRange!,
                              );

                              setState(() {
                                Navigator.pop(context);
                                FocusScope.of(context).unfocus();
                              });
                            }
                          },
                          child: const Text('Filter'))
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
    return Consumer<SubmitProvider>(builder: (context, subCon, child) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select Submission')),
        body: (subCon.getDrbs.isEmpty || subCon.getLots.isEmpty)
            ? subCon.stillSearching
                ? Center(child: CircularProgressIndicator())
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          trailing: IconButton(
                            icon: FaIcon(FontAwesomeIcons.sliders),
                            onPressed: () {
                              filterDialog(context);
                            },
                          ),
                          leading: IconButton(
                            icon: Icon(Icons.rotate_left),
                            onPressed: () {
                              subCon.fetchInitialDrbs();
                            },
                          ),
                          title: SimpleAutoCompleteTextField(
                              style: const TextStyle(fontSize: 20),
                              key: lotKey,
                              decoration: const InputDecoration(
                                  hintText: "Search Lot Name"),
                              controller: TextEditingController(text: ""),
                              suggestions: subCon.getLots,
                              submitOnSuggestionTap: true,
                              clearOnSubmit: true,
                              textSubmitted: (text) async {
                                if (subCon.getLots.contains(text)) {
                                  subCon.searchInitial(text);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Invalid Location")));
                                }
                              }),
                        ),
                        SizedBox(
                          height: 200,
                        ),
                        Text('No results Found'),
                      ],
                    ),
                  )
            : Column(
                children: [
                  ListTile(
                    trailing: IconButton(
                      icon: FaIcon(FontAwesomeIcons.sliders),
                      onPressed: () {
                        filterDialog(context);
                      },
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.rotate_left),
                      onPressed: () {
                        subCon.fetchInitialDrbs();
                      },
                    ),
                    title: SimpleAutoCompleteTextField(
                        style: const TextStyle(fontSize: 20),
                        key: lotKey,
                        decoration:
                            const InputDecoration(hintText: "Search Lot Name"),
                        controller: TextEditingController(text: ""),
                        suggestions: subCon.getLots,
                        submitOnSuggestionTap: true,
                        clearOnSubmit: true,
                        textSubmitted: (text) async {
                          if (subCon.getLots.contains(text)) {
                            subCon.searchInitial(text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Invalid Location")));
                          }
                        }),
                  ),
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: subCon.getDrbs.length,
                          //padding: EdgeInsets.only(top: 70, bottom: 100),
                          itemBuilder: (context, index) {
                            final subProv = Provider.of<SubmitProvider>(context,
                                listen: false);

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                  subCon.drbTap(index);
                                },
                                selected: subCon.getSelectedDrbs[index],
                                selectedTileColor: Colors.blueGrey[100],
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 83, 120, 139)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox.shrink(),
                                    Text(subCon.getDrbs[index].location,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22.0,
                                            color: Color.fromARGB(
                                                255, 83, 120, 139))),
                                    Text(
                                        DateFormat('M/d/yy').format(
                                            subCon.getDrbs[index].submitDate!),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20.0,
                                            color: Color.fromARGB(
                                                255, 83, 120, 139))),
                                  ],
                                ),
                                subtitle: Text(
                                    subCon.getDrbs[index].lotNum.toString()),
                                trailing: IconButton(
                                    icon: const Icon(Icons.arrow_forward),
                                    onPressed: () async {
                                      await subProv.viewSubmission(
                                          subCon.getDrbs[index]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DrbView()));
                                    }),
                              ),
                            );
                          })),
                ],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 50,
          margin: const EdgeInsets.all(10),
          child: !subCon.getSelectedDrbs.contains(true)
              ? SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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
                        subCon.drbDelete();
                      },
                      child: const Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
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
                        subCon.makeCSV();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.save_alt_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Download CSV',
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
