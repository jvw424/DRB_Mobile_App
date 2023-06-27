import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:drb_app/providers/AttendantProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TypeAheadList extends StatelessWidget {
  BuildContext context;
  TypeAheadList({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    final atProv = Provider.of<AttendantProvider>(context, listen: false);

    GlobalKey<AutoCompleteTextFieldState<String>> autoKey = GlobalKey();

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
}
