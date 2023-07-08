import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:drb_app/Screens/drb_route/SequenceSelector.dart';
import 'package:drb_app/models/LotLocations.dart';
import 'package:drb_app/providers/AttendantProvider.dart';
import 'package:drb_app/providers/LotProvider.dart';
import 'package:drb_app/providers/SeqProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationSelctor extends StatelessWidget {
  bool isLocated;
  LocationSelctor({
    required this.isLocated,
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
                                location: lots[index],
                              )));
                }),
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    final seqProv = Provider.of<SeqProvider>(context, listen: false);
    final atProv = Provider.of<AttendantProvider>(context, listen: false);

    GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

    return Consumer<LotProvider>(builder: (context, lotCon, child) {
      return Scaffold(
          appBar: AppBar(title: const Text('Select Location')),
          body: isLocated
              ? lotCon.getLocatedLots.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                            child:
                                Center(child: lstView(lotCon.getLocatedLots)))
                      ],
                    )
              : lotCon.getlots.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        isLocated
                            ? SizedBox.shrink()
                            : ListTile(
                                leading: Icon(Icons.search),
                                title: SimpleAutoCompleteTextField(
                                    style: const TextStyle(fontSize: 20),
                                    key: key,
                                    decoration: const InputDecoration(
                                        hintText: "Search Lot Name"),
                                    controller: TextEditingController(text: ""),
                                    suggestions: lotCon.getNames,
                                    submitOnSuggestionTap: true,
                                    clearOnSubmit: true,
                                    textSubmitted: (text) async {
                                      if (lotCon.getNames.contains(text)) {
                                        await atProv.fetchAts();
                                        atProv.clearSelectedAts();
                                        await seqProv.fetchSeqs(
                                          text,
                                        );
                                        await seqProv.makeVisitList();

                                        LotLocation selected =
                                            lotCon.getlots[0];
                                        for (var lot in lotCon.getlots) {
                                          if (lot.name == text) {
                                            selected = lot;
                                          }
                                        }

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SequenceSelector(
                                                      location: selected,
                                                    )));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text("Invalid Location")));
                                      }
                                    }),
                              ),
                        Expanded(child: lstView(lotCon.getlots))
                      ],
                    ));
    });
  }
}
