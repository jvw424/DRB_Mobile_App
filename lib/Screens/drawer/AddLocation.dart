import 'package:drb_app/models/LotLocations.dart';
import 'package:drb_app/providers/LotProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final nameTextController = TextEditingController();

  final numberTextController = TextEditingController();

  final addressTextController = TextEditingController();

  final streetTextController = TextEditingController();

  final cityTextController = TextEditingController();

  final stateTextController = TextEditingController(text: "CA");

  final zipTextController = TextEditingController();
  final latTextController = TextEditingController();

  final longTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final lotProv = Provider.of<LotProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      validator: (val) => val == '' ? "Enter Name" : null,
                      controller: nameTextController,
                      decoration: const InputDecoration(
                        labelText: 'Location Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == '' ? "Enter #" : null,
                      controller: numberTextController,
                      decoration: const InputDecoration(
                        labelText: 'Location #',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SizedBox(
                  height: 13,
                  width: MediaQuery.of(context).size.width * 8,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('Address:',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[700])),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == '' ? "Enter #" : null,
                      controller: addressTextController,
                      decoration: const InputDecoration(
                        labelText: 'Street #',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      validator: (val) => val == '' ? "Enter Street" : null,
                      controller: streetTextController,
                      decoration: const InputDecoration(
                        labelText: 'Street Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      validator: (val) => val == '' ? "Enter City" : null,
                      controller: cityTextController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      validator: (val) => val == '' ? "Enter State" : null,
                      controller: stateTextController,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                      validator: (val) =>
                          val == '' || val!.length < 5 ? "Enter Zip" : null,
                      controller: zipTextController,
                      decoration: const InputDecoration(
                        labelText: 'Zip',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(fixedSize: const Size(200, 50)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // ignore: prefer_interpolation_to_compose_strings
                    String address = addressTextController.text.trim() +
                        " " +
                        streetTextController.text.trim() +
                        ', ' +
                        cityTextController.text.trim() +
                        ', ' +
                        stateTextController.text.trim() +
                        ' ' +
                        zipTextController.text.trim();
                    //    If all data are correct then save data to out variables
                    List<Location> locations =
                        await locationFromAddress(address);

                    LotLocation newLoc = LotLocation(
                      name: nameTextController.text.trim(),
                      number: int.parse(numberTextController.text.trim()),
                      address: int.parse(addressTextController.text.trim()),
                      street: streetTextController.text.trim(),
                      city: cityTextController.text.trim(),
                      state: stateTextController.text.trim(),
                      zip: int.parse(zipTextController.text.trim()),
                      lat: locations[0].latitude,
                      long: locations[0].longitude,
                    );

                    await lotProv.addLocation(newLoc);
                    await lotProv.fetchLots();

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Successfully Added Location!")));
                    FocusManager.instance.primaryFocus?.unfocus();
                    nameTextController.clear();
                    numberTextController.clear();
                    addressTextController.clear();
                    streetTextController.clear();
                    cityTextController.clear();
                    zipTextController.clear();
                  } else {
                    //    If all data are not valid then start auto validation.
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Fix Errors")));
                  }
                },
                icon: const Icon(Icons.file_upload),
                label: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
