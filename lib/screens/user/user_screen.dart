import 'package:delivery_app/screens/user/user_addresses.dart';
import 'package:delivery_app/screens/user/user_cards.dart';
import 'package:delivery_app/services/services.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Services services = Services();
  dynamic? user;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
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
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(user['name'],
                        style: const TextStyle(
                            fontSize: 29, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UserAddresses()));
                      },
                      child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: const Center(
                              child: Text("Direcciones",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)))),
                    ),
                    GestureDetector(
                      onTap: () {
                         Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UserCards()));
                      },
                      child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: const Center(
                              child: Text("Tarjetas",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)))),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: const Center(
                              child: Text("Salir",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)))),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
      ),
    );
  }
}
