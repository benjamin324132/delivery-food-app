import 'package:delivery_app/components/default_button.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/screens/map/map_screen.dart';
import 'package:delivery_app/screens/user/add_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/services/services.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';

class UserCards extends StatefulWidget {
  const UserCards({Key? key}) : super(key: key);

  @override
  State<UserCards> createState() => _UserCardsState();
}

class _UserCardsState extends State<UserCards> {
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

  IconData getCardIcon(String? type) {
    switch (type) {
      case "VISA":
        return Boxicons.bxl_visa;
      case "MASTER":
        return Boxicons.bxl_mastercard;
      case "VENMO":
        return Boxicons.bxl_visa;
      case "PAYPAL":
        return Boxicons.bxl_paypal;
      default:
        return Boxicons.bxl_visa;
    }
  }

  Color getCardColor(String? type) {
    switch (type) {
      case "VISA":
        return Colors.yellowAccent;
      case "MASTER":
        return Colors.orangeAccent;
      case "VENMO":
        return Colors.black;
      case "PAYPAL":
        return Colors.blueAccent;
      default:
        return Colors.yellowAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal:defaultPadding),
                    child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const Text(
                            "Mis Tarjetas",
                            style: TextStyle(fontSize: 22),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Column(
                            children: List.generate(
                                user['cards'].length,
                                (index) => Container(
                                      padding: const EdgeInsets.only(
                                        bottom: defaultPadding,
                                        top: 1,
                                        left: 1,
                                        right: 1,
                                      ),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          color: getCardColor(
                                              user['cards'][index]['cardType']),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Container(
                                          padding: const EdgeInsets.all(
                                              defaultPadding * 1.5),
                                          width: double.infinity,
                                          height: 180,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Icon(
                                                    getCardIcon(user['cards']
                                                        [index]['cardType']),
                                                    size: 35,
                                                  ),
                                                  Text(
                                                    user['cards'][index]['exp'],
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Text(
                                                user['cards'][index]['name'],
                                                style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Spacer(),
                                              Text(
                                                user['cards'][index]['number'],
                                                style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )),
                                    )),
                          ),
                          DefaultButton(
                            press: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AddCardScreen()));
                            },
                            text: "Agregar",
                          )
                        ],
                      ),
                    ),
                  )));
  }
}
