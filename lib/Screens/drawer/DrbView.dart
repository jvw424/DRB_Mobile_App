import 'package:drb_app/Screens/drawer/RateView2.dart';
import 'package:drb_app/Screens/drawer/SubmitView.dart';
import 'package:drb_app/models/SubmitInfo.dart';
import 'package:drb_app/providers/SubmitProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DrbView extends StatelessWidget {
  DrbView({super.key});

  @override
  Widget build(BuildContext context) {
    final subProv = Provider.of<SubmitProvider>(context, listen: false);

    List<Widget> makeList() {
      List<Widget> pages = [];

      pages.add(SubmitView());

      for (int i = 0; i < subProv.getSubmit!.seqs.length; i++) {
        pages.add(RateView2(seq: subProv.getSubmit!.seqs[i]));
      }
      return pages;
    }

    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(subProv.getSubmit!.location),
          Text(DateFormat('M/d/yy').format(subProv.getSubmit!.submitDate!))
        ],
      )),
      body: PageView(
        scrollDirection: Axis.horizontal,
        children: makeList(),
      ),
    );
  }
}
