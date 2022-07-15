import 'package:delivery_app/components/status_tag.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/screens/order/order_screen.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/utils/parseStatus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Services services = Services();
  List<Order> orders = [];
  int page = 1;
  int pages = 0;

  @override
  void initState() {
    // TODO: implement initState
    getOrders("", "");
    super.initState();
  }

  void getOrders(String keyword, String pageNumber) async {
    var response =
        await services.getMyOrders(keyword: keyword, pageNumber: pageNumber);
    print(response['pages']);
    print(page);
    List<Order> result = (response['orders'] as List)
        .map((data) => Order.fromJson(data))
        .toList();
    List<Order> newList = [...orders, ...result];
    setState(() {
      orders = newList;
      page = response['page'];
      pages = response['pages'];
    });
    //print(response);
  }

  handlePaginate() {
    if (page < pages) {
      String stringPage = (page + 1).toString();
      getOrders("", stringPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo is ScrollEndNotification &&
                scrollInfo.metrics.extentAfter == 0 &&
                scrollInfo.metrics.axis == Axis.vertical) {
              handlePaginate();
              return true;
            }
            return false;
          },
          child: SingleChildScrollView(
            physics:const ScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                const Text(
                  "Mis Ordenes",
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: ListView.separated(
                    itemCount: orders.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DateTime tempDate = DateFormat("yyyy-MM-dd")
                          .parse(orders[index].createdAt!);
                      String date = DateFormat("dd/MM/yyyy").format(tempDate);
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  OrderScreen(id: orders[index].id!)));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(defaultPadding / 2),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.025),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(13)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Orden ${orders[index].id}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                  StatusTag(
                                    status: orders[index].status,
                                  )
                                ],
                              ),
                              Text(
                                "Fecha $date",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              for (Dishes dish in orders[index].dishes!)
                                Text(
                                  "${dish.name} x ${dish.qty}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Subtotal"),
                                  Text("\$${orders[index].subtotal!}"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Delivery"),
                                  Text("\$${orders[index].deliveryFee!}"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("\$${orders[index].total!}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: defaultPadding),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
