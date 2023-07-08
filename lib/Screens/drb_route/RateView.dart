import 'package:drb_app/services/globals.dart';
import 'package:drb_app/providers/CheckProvider.dart';
import 'package:drb_app/providers/SeqProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RateView extends StatelessWidget {
  int idx;
  RateView({super.key, required this.idx});

  TextEditingController valController = TextEditingController();
  TextEditingController quantController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SeqProvider>(
      builder: (context, seq, child) {
        return ListView.builder(
            cacheExtent: 1000000,
            padding: EdgeInsets.only(
                bottom: kFloatingActionButtonMargin +
                    MediaQuery.of(context).size.height * .2),
            itemCount: seq.getSeqs[idx].rates.length,
            itemBuilder: (context, index) {
              String stringMaker() {
                String all = '';
                for (var attendant
                    in seq.getSeqs[idx].rates[index].attendants) {
                  if (attendant ==
                      seq.getSeqs[idx].rates[index].attendants.last) {
                    all += attendant;
                  } else {
                    all += '$attendant, ';
                  }
                }
                return all;
              }

              String shortTimeString() {
                String st = '';
                seq.getSeqs[idx].rates[index].shortTimes.forEach((val, quant) {
                  st += "\$$val : $quant, ";
                });
                return st;
              }

              String ccShortTimeString() {
                String cc = '';
                if (seq.getSeqs[idx].rates[index].ccShortTimes.isEmpty) {
                  return cc;
                } else {
                  cc = 'CC: ';
                  seq.getSeqs[idx].rates[index].ccShortTimes
                      .forEach((val, quant) {
                    cc += "\$$val : $quant, ";
                  });
                  return cc;
                }
              }

              Widget closeTime() {
                if (seq.getSeqs[idx].rates[index].closeTimes != '') {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('CC Times',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700])),
                          Text(seq.getSeqs[idx].rates[index].closeTimes),
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
                if (seq.getSeqs[idx].rates[index].pickup != 0) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Cash Pickup \$${seq.getSeqs[idx].rates[index].pickup.toString()} - ${seq.getSeqs[idx].rates[index].supervisor}'),
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

              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: IgnorePointer(
                    ignoring: (index < seq.getSeqs[idx].rates.length - 1 ||
                        seq.getSeqs[idx].rates[index].wasSaved),
                    child: Form(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            AppBar(
                              backgroundColor: wList[seq.getSeqs[idx].color],
                              automaticallyImplyLeading: false,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${index + 1}",
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black87)),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * .6,
                                    child: Text(stringMaker(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                221, 22, 21, 21))),
                                  ),
                                  IconButton(
                                      disabledColor: Colors.grey,
                                      color: Colors.black,
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        if (index != 0) {
                                          seq.deleteRate(idx);
                                        }
                                        null;
                                      })
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 8),
                              child: TextFormField(
                                initialValue: seq.getSeqs[idx].rates[index].rate
                                    .toString(),
                                enableInteractiveSelection: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textAlign: TextAlign.center,
                                //controller: rateController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],

                                onChanged: (val) {
                                  if (val != '' || val.isNotEmpty) {
                                    seq.editRate(int.parse(val), idx);
                                  }
                                },
                                onFieldSubmitted: (val) {
                                  if (val != '' || val.isNotEmpty) {
                                    seq.editRate(int.parse(val), idx);
                                  }
                                },
                                keyboardType: TextInputType.phone,
                                validator: (val) =>
                                    val!.isEmpty || int.tryParse(val)! <= 0
                                        ? "Enter Valid Rate"
                                        : null,
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
                                        initialValue: seq.getSeqs[idx]
                                            .rates[index].startNumber
                                            .toString(),
                                        enableInteractiveSelection: false,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        readOnly: true,
                                        style: const TextStyle(
                                            color: Colors.black45),
                                        textAlign: TextAlign.center,
                                        //controller: startNumController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                            labelText: 'Start Number',
                                            icon: FaIcon(
                                                FontAwesomeIcons.hashtag)),
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
                                      initialValue: seq
                                          .getSeqs[idx].rates[index].endNumber
                                          .toString(),
                                      enableInteractiveSelection: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (val) {
                                        if (val != '' || val.isNotEmpty) {
                                          seq.editEndNum(int.parse(val), idx);
                                        }
                                      },
                                      onFieldSubmitted: (val) {
                                        if (val != '' || val.isNotEmpty) {
                                          seq.editEndNum(int.parse(val), idx);
                                        }
                                      },
                                      keyboardType: TextInputType.phone,
                                      validator: (val) => val!.isEmpty ||
                                              int.tryParse(val)! <
                                                  seq.getSeqs[idx].rates[index]
                                                      .startNumber
                                          ? "Enter Valid End Number"
                                          : null,
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
                                      initialValue: seq
                                          .getSeqs[idx].rates[index].startCod
                                          .toString(),
                                      enableInteractiveSelection: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.phone,
                                      style: const TextStyle(
                                          color: Colors.black45),
                                      decoration: const InputDecoration(
                                          labelText: 'Start COD',
                                          icon: FaIcon(
                                              FontAwesomeIcons.handshake)),
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
                                      initialValue: seq
                                          .getSeqs[idx].rates[index].endCod
                                          .toString(),
                                      enableInteractiveSelection: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (val) {
                                        if (val != '' || val.isNotEmpty) {
                                          seq.editEndCod(int.parse(val), idx);
                                        }
                                      },
                                      onFieldSubmitted: (val) {
                                        if (val != '' || val.isNotEmpty) {
                                          seq.editEndCod(int.parse(val), idx);
                                        }
                                      },
                                      keyboardType: TextInputType.phone,
                                      validator: (val) => val!.isEmpty ||
                                              int.tryParse(val)! -
                                                      seq
                                                          .getSeqs[idx]
                                                          .rates[index]
                                                          .startCod +
                                                      seq.getSeqs[idx]
                                                          .rates[index].voids +
                                                      seq
                                                          .getSeqs[idx]
                                                          .rates[index]
                                                          .validations +
                                                      seq
                                                          .getSeqs[idx]
                                                          .rates[index]
                                                          .credits >
                                                  seq.getSeqs[idx].rates[index]
                                                          .endNumber -
                                                      seq
                                                          .getSeqs[idx]
                                                          .rates[index]
                                                          .startNumber
                                          ? "Enter Valid End COD"
                                          : null,
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
                                initialValue: seq
                                    .getSeqs[idx].rates[index].credits
                                    .toString(),
                                enableInteractiveSelection: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (val) {
                                  if (val != '' || val.isNotEmpty) {
                                    seq.editCredits(int.parse(val), idx);
                                  }
                                },
                                onFieldSubmitted: (val) {
                                  if (val != '' || val.isNotEmpty) {
                                    seq.editCredits(int.parse(val), idx);
                                  }
                                },
                                keyboardType: TextInputType.phone,
                                validator: (val) => val!.isEmpty ||
                                        int.tryParse(val)! +
                                                seq.getSeqs[idx].rates[index]
                                                    .voids +
                                                seq.getSeqs[idx].rates[index]
                                                    .validations +
                                                (seq.getSeqs[idx].rates[index]
                                                        .endCod -
                                                    seq
                                                        .getSeqs[idx]
                                                        .rates[index]
                                                        .startCod) >
                                            seq.getSeqs[idx].rates[index]
                                                    .endNumber -
                                                seq.getSeqs[idx].rates[index]
                                                    .startNumber
                                    ? "Enter Valid Credits"
                                    : null,
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
                                      initialValue: seq
                                          .getSeqs[idx].rates[index].voids
                                          .toString(),
                                      enableInteractiveSelection: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (val) {
                                        if (val != '' || val.isNotEmpty) {
                                          seq.editVoids(int.parse(val), idx);
                                        }
                                      },
                                      onFieldSubmitted: (val) {
                                        if (val != '' || val.isNotEmpty) {
                                          seq.editVoids(int.parse(val), idx);
                                        }
                                      },
                                      keyboardType: TextInputType.phone,
                                      validator: (val) => val!.isEmpty ||
                                              int.tryParse(val)! +
                                                      seq
                                                          .getSeqs[idx]
                                                          .rates[index]
                                                          .credits +
                                                      seq
                                                          .getSeqs[idx]
                                                          .rates[index]
                                                          .validations +
                                                      (seq
                                                              .getSeqs[idx]
                                                              .rates[index]
                                                              .endCod -
                                                          seq
                                                              .getSeqs[idx]
                                                              .rates[index]
                                                              .startCod) >
                                                  seq.getSeqs[idx].rates[index]
                                                          .endNumber -
                                                      seq
                                                          .getSeqs[idx]
                                                          .rates[index]
                                                          .startNumber
                                          ? "Enter valid Voids"
                                          : null,
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
                                      initialValue: seq
                                          .getSeqs[idx].rates[index].validations
                                          .toString(),
                                      enableInteractiveSelection: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (val) {
                                        if (val != '' || val.isNotEmpty) {
                                          seq.editValidations(
                                              int.parse(val), idx);
                                        }
                                      },
                                      onFieldSubmitted: (val) {
                                        if (val != '' || val.isNotEmpty) {
                                          seq.editValidations(
                                              int.parse(val), idx);
                                        }
                                      },
                                      keyboardType: TextInputType.phone,
                                      validator: (val) => val!.isEmpty ||
                                              int.tryParse(val)! +
                                                      seq.getSeqs[idx]
                                                          .rates[index].voids +
                                                      seq
                                                          .getSeqs[idx]
                                                          .rates[index]
                                                          .credits +
                                                      (seq
                                                              .getSeqs[idx]
                                                              .rates[index]
                                                              .endCod -
                                                          seq
                                                              .getSeqs[idx]
                                                              .rates[index]
                                                              .startCod) >
                                                  seq.getSeqs[idx].rates[index]
                                                          .endNumber -
                                                      seq
                                                          .getSeqs[idx]
                                                          .rates[index]
                                                          .startNumber
                                          ? "Enter Valid number of Validations"
                                          : null,
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
                                      Consumer<SeqProvider>(
                                        builder: (context, value, child) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(shortTimeString()),
                                              Text(ccShortTimeString()),
                                            ],
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                            controller: valController,
                                            enableInteractiveSelection: false,
                                            textAlign: TextAlign.center,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.phone,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Rate',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 14,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                            controller: quantController,
                                            enableInteractiveSelection: false,
                                            textAlign: TextAlign.center,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.phone,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Quantity',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 14,
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: wList[
                                                      seq.getSeqs[idx].color]),
                                              onPressed: () {
                                                final checkProv =
                                                    Provider.of<CheckProvider>(
                                                        context,
                                                        listen: false);

                                                print(checkProv.isChecked);

                                                if (valController.text == '' ||
                                                    quantController.text ==
                                                        '') {
                                                  return;
                                                }

                                                seq.addShortTime(
                                                    isCC: checkProv.isChecked,
                                                    val: int.parse(
                                                        valController.text),
                                                    quant: int.parse(
                                                        quantController.text),
                                                    idx: idx);

                                                valController.clear();
                                                quantController.clear();
                                              },
                                              child: const Text("Submit",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                  )),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Consumer<CheckProvider>(
                                            builder: (context, checkboxProvider,
                                                    _) =>
                                                CheckboxListTile(
                                              checkColor: Colors.black,
                                              activeColor:
                                                  wList[seq.getSeqs[idx].color],
                                              title: Text('CC Refund'),
                                              value: checkboxProvider.isChecked,
                                              onChanged: (value) {
                                                checkboxProvider.isChecked =
                                                    value ?? true;
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.red),
                                                onPressed: () {
                                                  seq.clearShortTime(idx);
                                                },
                                                child: const Text("clear",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Consumer<SeqProvider>(
                                    builder: (context, seqCon, child) {
                                      return Text(
                                        'Cash \$${seqCon.getSeqs[idx].rates[index].cash}',
                                        style: const TextStyle(fontSize: 18),
                                      );
                                    },
                                  ),
                                  Consumer<SeqProvider>(
                                    builder: (context, seqCon, child) {
                                      return Text(
                                        'Credit \$${seqCon.getSeqs[idx].rates[index].creditTotal}',
                                        style: const TextStyle(fontSize: 18),
                                      );
                                    },
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
      },
    );
  }
}
