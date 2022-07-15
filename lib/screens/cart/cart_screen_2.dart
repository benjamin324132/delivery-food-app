import 'package:delivery_app/components/cart_dish.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/provider/app_provider.dart';
import 'package:delivery_app/screens/succes/succes_order.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/utils/getLocation.dart';
import 'package:delivery_app/utils/showSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class CartScreen2 extends StatefulWidget {
  const CartScreen2({Key? key}) : super(key: key);

  @override
  State<CartScreen2> createState() => _CartScreen2State();
}

class _CartScreen2State extends State<CartScreen2> {
  Services services = Services();
  String address = "";

  @override
  void initState() {
    // TODO: implement initState
    getAddress() ;
    super.initState();
  }

  void getAddress() async {
    try {
      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position? position = await getCurrentLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position!.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placeMark = placemarks[0];
        String? street = placeMark.street;
        //String? name = placeMark.name;
        String? subLocality = placeMark.locality;
        String? postalCode = placeMark.postalCode;
        String addressPostion = "$street, $subLocality, $postalCode";
        setState(() {
          address = addressPostion;
        });
      }
    } catch (err) {
      print(err);
      showSnackBar(context, "Error");
    }
  }

  void order(context) async {
    var data = Provider.of<AppProvider>(context, listen: false).items;
    try {
      Position? position = await getCurrentLocation();
      var response = await services.crateOrder(
          data, address, position!.latitude, position.longitude);
      Provider.of<AppProvider>(context, listen: false).removeAll();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SuccesOrder()));
    } catch (err) {
      print(err);
      showSnackBar(context, "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var data = Provider.of<AppProvider>(context, listen: true).items;
    var subt = Provider.of<AppProvider>(context, listen: true).totalCart();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: data.isNotEmpty
              ? SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Carrito",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.blueAccent.withOpacity(0.08)),
                                  child: const Icon(
                                    Boxicons.bx_plus,
                                    color: Colors.blueAccent,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: ListView.separated(
                                itemCount: data.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => CartDish(
                                  id: data[index]['dishId'],
                                  name: data[index]['name'],
                                  price: data[index]['price'],
                                  image: data[index]['image'],
                                  qty: data[index]['qty'],
                                ),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: defaultPadding),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Direccion",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Cambiar",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 110,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.black12.withOpacity(0.05),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12))),
                                    child: const Icon(Boxicons.bx_map_pin),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Casa",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          address,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black26),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Metodo de Pago",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.black12.withOpacity(0.05),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xff1A1F71),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      child: const Icon(
                                        Boxicons.bxl_visa,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "Pago",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            "8845 09567 2345 7634",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black26),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Boxicons.bx_chevron_right),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Subtotal",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "\$$subt",
                              style: const TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Envio",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "\$${30}",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Descuento",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "\$0.00 ",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "\$${subt + 30}",
                                    style: const TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                order(context);
                              },
                              child: Container(
                                width: 130,
                                height: 60,
                                decoration: const BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: const Center(
                                    child: Text(
                                  "Pagar",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                  "Agregar platillos a tu carrito",
                  style: TextStyle(color: Colors.black38, fontSize: 22),
                )),
        ));
  }
}
