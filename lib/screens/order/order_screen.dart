import 'package:delivery_app/components/cart_dish.dart';
import 'package:delivery_app/components/status_tag.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/utils/parseStatus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Services services = Services();
  late Order order;
  bool isLoading = true;
  String? date = "Fecha";

  @override
  void initState() {
    // TODO: implement initState
    getOrder();
    super.initState();
  }

  void getOrder() async {
    var response = await services.getOrderById(widget.id);
    print(response);
    Order ord = Order.fromJson(response);
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(ord.createdAt!);
    String created = DateFormat("dd/MM/yyyy").format(tempDate);

    setState(() {
      order = ord;
      isLoading = false;
      date = created;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: !isLoading
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const Text(
                        "Orden",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Orden No. ${order.id}", style: TextStyle(fontSize: 12),),
                          StatusTag(
                            status: order.status,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Text("Fech: $date"),
                      Text("Direccion: ${order.deliveryAdress}"),
                      for (Dishes dish in order.dishes!)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding / 2),
                          child: CartDish(
                              id: dish.id!,
                              name: dish.name!,
                              price: dish.price!,
                              image: dish.image!,
                              qty: dish.qty!),
                        ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal"),
                          Text("\$${order.subtotal!}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Delivery"),
                          Text("\$${order.deliveryFee!}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("\$${order.total!}"),
                        ],
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator())),
    );
  }
}
