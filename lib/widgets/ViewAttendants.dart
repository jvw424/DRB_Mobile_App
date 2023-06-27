import 'package:drb_app/providers/AttendantProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAts extends StatelessWidget {
  const ViewAts({super.key});

  @override
  Widget build(BuildContext context) {
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
}
