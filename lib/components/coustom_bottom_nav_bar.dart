import 'package:delivery_app/screens/map/map_screen.dart';
import 'package:delivery_app/screens/orders/orders_screen.dart';
import 'package:delivery_app/screens/search/search_screen.dart';
import 'package:delivery_app/screens/user/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Boxicons.bx_home_alt,
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Boxicons.bx_search,
                  color: MenuState.search == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SearchScreen(search: "")));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: MenuState.orders == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OrdersScreen()));
                },
              ),
              IconButton(
                icon: Icon(
                  Boxicons.bxs_user,
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                   Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UserScreen()));
                },
              ),
            ],
          )),
    );
  }
}
