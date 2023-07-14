import 'package:drb_app/providers/SubmitProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityView extends StatelessWidget {
  ActivityView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SubmitProvider>(
      builder: (context, subCon, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Activity History')),
          body: (subCon.getActs.isEmpty)
              ? subCon.stillSearching
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          Text('No results Found'),
                        ],
                      ),
                    )
              : Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: subCon.getActs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  selectedTileColor: Colors.blueGrey[100],
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 83, 120, 139)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Text(
                                            subCon.getActs[index].activity,
                                            maxLines: 3,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20.0,
                                                color: Color.fromARGB(
                                                    255, 83, 120, 139))),
                                      ),
                                      Text(
                                          DateFormat('M/d/yy').format(
                                              subCon.getActs[index].when),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.0,
                                              color: Color.fromARGB(
                                                  255, 83, 120, 139))),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(subCon.getActs[index].user),
                                    ],
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
        );
      },
    );
  }
}
