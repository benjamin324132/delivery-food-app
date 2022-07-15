import 'package:delivery_app/components/default_button.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/dish.dart';
import 'package:delivery_app/provider/app_provider.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/size_config.dart';
import 'package:delivery_app/utils/showSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class DishScreen extends StatefulWidget {
  const DishScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<DishScreen> createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen> {
  late Dish dish;
  bool loading = true;
  Services services = Services();
  final TextEditingController _comments = TextEditingController();
  int qty = 1;

  @override
  void initState() {
    // TODO: implement initState
    getDish();
    super.initState();
  }

  void getDish() async {
    var response = await services.getDish(widget.id);
    Dish result = Dish.fromJson(response);
    setState(() {
      dish = result;
      loading = false;
    });
  }

  void addDishToCart() {
    final dynamic item = {
      "name": dish.name,
      "image": dish.image,
      "price": dish.price,
      "qty": qty,
      "coments": _comments.text,
      "dishId": dish.id
    };
    Provider.of<AppProvider>(context, listen: false).add(item);
    //showSnackBar(context, "Se agrego exitosamente");
    showSimpleNotification(
      const Text("Platillo agregado"),
      background: Colors.grey.shade50,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  dish.image!,
                  height: SizeConfig.screenHeight * .4,
                  width: SizeConfig.screenWidth,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: defaultPadding),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding / 2),
                            child: Text(
                              dish.name!,
                              style: const TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding / 2),
                            child: Text(
                              "\$${dish.price!}",
                              style: const TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding / 2),
                        child: Text(
                          dish.desc!,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Comments",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    controller: _comments,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (qty >= 2) qty -= 1;
                          });
                        },
                        icon: const Icon(Boxicons.bx_minus)),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    Text(
                      "$qty",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            qty += 1;
                          });
                        },
                        icon: const Icon(Boxicons.bx_plus)),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  child: DefaultButton(
                    press: addDishToCart,
                    text: "Agregar",
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
