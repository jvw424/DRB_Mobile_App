import 'package:drb_app/services/globals.dart';
import 'package:drb_app/models/Sequence.dart';
import 'package:drb_app/providers/SeqProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RateView2 extends StatelessWidget {
  Sequence seq;
  RateView2({super.key, required this.seq});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        cacheExtent: 1000000,
        padding:
            const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 60),
        itemCount: seq.rates.length,
        itemBuilder: (context, index) {
          String stringMaker() {
            String all = '';
            for (var attendant in seq.rates[index].attendants) {
              if (attendant == seq.rates[index].attendants.last) {
                all += attendant;
              } else {
                all += '$attendant, ';
              }
            }
            return all;
          }

          String shortTimeString() {
            String all = '';
            seq.rates[index].shortTimes.forEach((val, quant) {
              all += "\$$val : $quant, ";
            });
            return all;
          }

          String ccShortTimeString() {
            String cc = '';
            if (seq.rates[index].ccShortTimes.isEmpty) {
              return cc;
            } else {
              cc = 'CC: ';
              seq.rates[index].ccShortTimes.forEach((val, quant) {
                cc += "\$$val : $quant, ";
              });
              return cc;
            }
          }

          Widget closeTime() {
            if (seq.rates[index].closeTimes != '') {
              return Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('CC Times',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700])),
                      Text(seq.rates[index].closeTimes),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }

          Widget cashPickup() {
            if (seq.rates[index].pickup != 0) {
              return Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Cash Pickup \$${seq.rates[index].pickup.toString()} - ${seq.rates[index].supervisor}'),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }

          Widget buttonControl() {
            if (seq.rates[index].shortTimes.isEmpty) {
              return const SizedBox.shrink();
            } else {
              return Row(
                children: [
                  const Expanded(flex: 3, child: Text('')),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {},
                        child: const Text("Delete",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      )),
                  const SizedBox(
                    width: 14,
                  ),
                  const Expanded(flex: 3, child: Text('')),
                ],
              );
            }
          }

          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(4.0)),
              child: IgnorePointer(
                ignoring: true,
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AppBar(
                          backgroundColor: wList[seq.color],
                          automaticallyImplyLeading: false,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${index + 1}",
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black87)),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * .6,
                                child: Text(stringMaker(),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color:
                                            Color.fromARGB(221, 22, 21, 21))),
                              ),
                              SizedBox.shrink()
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 8),
                          child: TextFormField(
                            initialValue: seq.rates[index].rate.toString(),
                            enableInteractiveSelection: false,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                                labelText: 'Rate',
                                icon: FaIcon(FontAwesomeIcons.dollarSign)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, bottom: 8),
                                  child: TextFormField(
                                    initialValue:
                                        seq.rates[index].startNumber.toString(),
                                    readOnly: true,
                                    style:
                                        const TextStyle(color: Colors.black45),
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                        labelText: 'Start Number',
                                        icon: FaIcon(FontAwesomeIcons.hashtag)),
                                  )),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8),
                                child: TextFormField(
                                  initialValue:
                                      seq.rates[index].endNumber.toString(),
                                  enableInteractiveSelection: false,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      labelText: 'End Number'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8),
                                child: TextFormField(
                                  initialValue:
                                      seq.rates[index].startCod.toString(),
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black45),
                                  decoration: const InputDecoration(
                                      labelText: 'Start COD',
                                      icon: FaIcon(FontAwesomeIcons.handshake)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8),
                                child: TextFormField(
                                  initialValue:
                                      seq.rates[index].endCod.toString(),
                                  enableInteractiveSelection: false,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      labelText: 'End Cod'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                          ),
                          child: TextFormField(
                            initialValue: seq.rates[index].credits.toString(),
                            enableInteractiveSelection: false,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                                labelText: 'Credits',
                                icon: FaIcon(FontAwesomeIcons.creditCard)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8),
                                child: TextFormField(
                                  initialValue:
                                      seq.rates[index].voids.toString(),
                                  enableInteractiveSelection: false,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      labelText: 'Voids',
                                      icon: FaIcon(FontAwesomeIcons.ban)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8),
                                child: TextFormField(
                                  initialValue:
                                      seq.rates[index].validations.toString(),
                                  enableInteractiveSelection: false,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      labelText: 'Validations',
                                      icon: FaIcon(FontAwesomeIcons.stamp)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            child: ExpansionTile(
                              initiallyExpanded: false,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Short Times',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700])),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(shortTimeString()),
                                      Text(ccShortTimeString()),
                                    ],
                                  ),
                                ],
                              ),
                              children: [],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Cash \$${seq.rates[index].cash}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Credit \$${seq.rates[index].creditTotal}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        closeTime(),
                        cashPickup(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
