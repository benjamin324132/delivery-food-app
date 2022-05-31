import 'package:delivery_app/constants.dart';
import 'package:delivery_app/screens/dish/dish_screen.dart';
import 'package:delivery_app/size_config.dart';
import 'package:flutter/material.dart';

class DishCard extends StatelessWidget {
  const DishCard(
      {Key? key,
      required this.id,
      required this.image,
      required this.name,
      required this.price,
      required this.category})
      : super(key: key);

  final String id;
  final String image;
  final String name;
  final String category;
  final int price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DishScreen(id: id)));
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              image,
              height: 220,
              width: SizeConfig.screenWidth,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: Theme.of(context).textTheme.caption,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding / 3),
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
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: kPrimaryColor,
                    ),
                  ),
                  const Text(
                    "3m ago",
                    style: TextStyle(color: kPrimaryColor),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
