import 'package:delivery_app/components/cart_dish.dart';
import 'package:delivery_app/components/default_button.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/screens/succes/succes_order.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/size_config.dart';
import 'package:delivery_app/utils/getLocation.dart';
import 'package:delivery_app/utils/showSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../provider/app_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Services services = Services();

  void order(context) async {
    var data = Provider.of<AppProvider>(context, listen: false).items;
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
        print(position == null
            ? 'Unknown'
            : '${position.latitude.toString()}, ${position.longitude.toString()}');
        var response = await services.crateOrder(
            data, addressPostion, position.latitude, position.longitude);
        //print(response);
        //showSnackBar(context, "Orden creada exitosamente");
        Provider.of<AppProvider>(context, listen: false).removeAll();

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SuccesOrder()));
      }
    } catch (err) {
      print(err);
      showSnackBar(context, "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppProvider>(context, listen: true).items;
    var subt = Provider.of<AppProvider>(context, listen: true).totalCart();
    return Scaffold(
      bottomNavigationBar: data.isNotEmpty
          ? Container(
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenWidth(15),
                horizontal: defaultPadding,
              ),
              // height: 174,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -15),
                    blurRadius: 20,
                    color: const Color(0xFFDADADA).withOpacity(0.15),
                  )
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Subotal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("\$$subt"),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Envio",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("\$30"),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("\$${subt + 30}"),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    DefaultButton(
                      text: "Pagar",
                      press: () {
                        order(context);
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: data.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: ListView.separated(
                  itemCount: data.length,
                  // physics: const NeverScrollableScrollPhysics(),
                  //shrinkWrap: true,
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
            : const Center(
                child: Text(
                "Agregar platillos a tu carrito",
                style: TextStyle(color: Colors.black38, fontSize: 22),
              )),
      ),
    );
  }
}
