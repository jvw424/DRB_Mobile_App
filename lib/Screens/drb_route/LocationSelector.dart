import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:drb_app/models/LotLocations.dart';
import 'package:drb_app/providers/LotProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationSelctor extends StatelessWidget {
  const LocationSelctor({
    super.key,
  });

  lstView(List<LotLocation> lots) => ListView.builder(
      itemCount: lots.length,
      //padding: EdgeInsets.only(top: 70, bottom: 100),
      itemBuilder: (context, index) {
        GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
        List<String> lotList = [];
        for (var lot in lots) {
          lotList.add(lot.name);
        }
        if (index != 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                //<-- SEE HERE
                side: BorderSide(
                    width: 1, color: const Color.fromARGB(255, 83, 120, 139)),

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Placeholder()));
                  }),
            ),
          );
        } else {
          return ListTile(
            title: SimpleAutoCompleteTextField(
                style: TextStyle(fontSize: 20),
                key: key,
                decoration: const InputDecoration(hintText: "Search Lot Name"),
                controller: TextEditingController(text: ""),
                suggestions: lotList,
                submitOnSuggestionTap: true,
                clearOnSubmit: true,
                textSubmitted: (text) {
                  if (lotList.contains(text)) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Placeholder()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Invalid Location")));
                  }
                }),
          );
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Select Location')),
        body: Consumer<LotProvider>(
            builder: (context, prov, child) => lstView(prov.getlots)));
  }
}
