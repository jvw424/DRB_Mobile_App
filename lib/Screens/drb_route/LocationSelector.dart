import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:drb_app/Screens/drb_route/SequenceSelector.dart';
import 'package:drb_app/models/LotLocations.dart';
import 'package:drb_app/providers/AttendantProvider.dart';
import 'package:drb_app/providers/LotProvider.dart';
import 'package:drb_app/providers/SeqProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationSelctor extends StatelessWidget {
  const LocationSelctor({
    super.key,
  });

  lstView(List<LotLocation> lots) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: lots.length,
      //padding: EdgeInsets.only(top: 70, bottom: 100),
      itemBuilder: (context, index) {
        final sProv = Provider.of<SeqProvider>(context, listen: false);
        final atProv = Provider.of<AttendantProvider>(context, listen: false);
        List<String> lotList = [];
        for (var lot in lots) {
          lotList.add(lot.name);
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              side: const BorderSide(
                  width: 1, color: Color.fromARGB(255, 83, 120, 139)),

              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(lots[index].name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                      color: Color.fromARGB(255, 83, 120, 139))),
            ),
            subtitle: Text(lots[index].number.toString()),
            trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () async {
                  await atProv.fetchAts();
                  atProv.clearSelectedAts();
                  await sProv.fetchSeqs(
                    lots[index].name,
                  );
                  await sProv.makeVisitList();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SequenceSelector(
                                location: lots[index].name,
                              )));
                }),
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    final lotProv = Provider.of<LotProvider>(context, listen: false);
    final seqProv = Provider.of<SeqProvider>(context, listen: false);
    final atProv = Provider.of<AttendantProvider>(context, listen: false);

    List<String> lots = [];
    for (var lot in lotProv.getlots) {
      lots.add(lot.name);
    }
    GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

    return Scaffold(
        appBar: AppBar(title: const Text('Select Location')),
        body: Column(
          children: [
            ListTile(
              title: SimpleAutoCompleteTextField(
                  style: const TextStyle(fontSize: 20),
                  key: key,
                  decoration:
                      const InputDecoration(hintText: "Search Lot Name"),
                  controller: TextEditingController(text: ""),
                  suggestions: lots,
                  submitOnSuggestionTap: true,
                  clearOnSubmit: true,
                  textSubmitted: (text) async {
                    if (lots.contains(text)) {
                      await atProv.fetchAts();
                      atProv.clearSelectedAts();
                      await seqProv.fetchSeqs(
                        text,
                      );
                      await seqProv.makeVisitList();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SequenceSelector(
                                    location: text,
                                  )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid Location")));
                    }
                  }),
            ),
            Expanded(
              child: Consumer<LotProvider>(
                  builder: (context, prov, child) => lstView(prov.getlots)),
            ),
          ],
        ));
  }
}
