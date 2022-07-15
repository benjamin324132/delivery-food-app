import 'package:delivery_app/components/default_button.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/screens/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/services/services.dart';

class UserAddresses extends StatefulWidget {
  const UserAddresses({Key? key}) : super(key: key);

  @override
  State<UserAddresses> createState() => _UserAddressesState();
}

class _UserAddressesState extends State<UserAddresses> {
  Services services = Services();
  dynamic? user;
  bool isLoading = true;

  @override
  void initState() {
    getMe();
    super.initState();
  }

  void getMe() async {
    var response = await services.getMe();
    print(response);
    setState(() {
      user = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: SingleChildScrollView(
                      physics:const ScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const Text(
                            "Mis Direcciones",
                            style: TextStyle(fontSize: 22),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Column(
                            children: List.generate(
                                user['addresses'].length,
                                (index) => Container(
                                    padding:
                                        const EdgeInsets.all(defaultPadding),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Center(
                                        child: Text(user['addresses'][index]
                                            ['address'])))),
                          ),
                          DefaultButton(
                            press: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MapScreen()));
                            },
                            text: "Agregar",
                          )
                        ],
                      ),
                    ),
                  )));
  }
}
