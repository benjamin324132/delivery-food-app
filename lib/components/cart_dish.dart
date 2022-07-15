import 'package:delivery_app/constants.dart';
import 'package:delivery_app/size_config.dart';
import 'package:flutter/material.dart';

class CartDish extends StatelessWidget {
  const CartDish(
      {Key? key,
      required this.id,
      required this.image,
      required this.name,
      required this.price,
      this.qty = 1})
      : super(key: key);

  final String id;
  final String image;
  final String name;
  final int price;
  final int qty;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            image,
            height: 100,
            width: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: defaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             /* Text(
                "Fast Food",
                style: Theme.of(context).textTheme.caption,
              ),*/
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Row(
                children: [
                  Text(
                    "\$$price",
                    style: const TextStyle(color: kPrimaryColor),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                    child: Text(
                      "X",
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ),
                  Text(
                    "$qty",
                    style: const TextStyle(color: kPrimaryColor),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
