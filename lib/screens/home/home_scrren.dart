import 'package:delivery_app/components/coustom_bottom_nav_bar.dart';
import 'package:delivery_app/components/dish_card.dart';
import 'package:delivery_app/components/image_carousel.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/enums.dart';
import 'package:delivery_app/models/dish.dart';
import 'package:delivery_app/provider/app_provider.dart';
import 'package:delivery_app/screens/cart/cart_screen.dart';
import 'package:delivery_app/screens/login/login_screen.dart';
import 'package:delivery_app/screens/search/search_screen.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Dish> dishes = [];
  Services services = Services();
  final storage = FlutterSecureStorage();
  late VideoPlayerController _controller;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    //getDishes();
    getLocation();
    /* _controller = VideoPlayerController.network(
        'https://stream.mux.com/DA8s5WZXSrVYqzMa1RyKoMjI6bfglPy8/high.mp4?token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InQ5UHZucm9ZY0hQNjhYSmlRQnRHTEVVSkVSSXJ0UXhKIn0.eyJleHAiOjE2NTI4MjgxODksImF1ZCI6InYiLCJzdWIiOiJEQThzNVdaWFNyVllxek1hMVJ5S29Nakk2YmZnbFB5OCJ9.sq75Lkb6lc-_aJUt9QPPfE74iYPMfExhwxdMjNNMHcTSJxgGd7bHhIYsQL0L9MQTCwDJw8rNh7eTXKYghduczag1TgE2D6MX_1SFv-zgMwmA5odrGWMO45zDaRZb8JbhPvvSZ0BsVxPUy-T7LwHqJsZsaZsI_xxNxV3jtYy0bdT9dpceOsEGnbBesi7dGsQ7t4C01cxw3fTVJtXmbd8BZdz9kjmFHRoka3Npe8GgZgB-kzeNATAvhhNEg-8CPDW6b9rHBHbhLKVvqYNi9SjlGLEzqQsOY4B_zRsDH1TYe1TaO2LACNiMzaRVaNBWs7pujSKmt9zT7NxM16Mf8MHkwQ')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });*/
    super.initState();
  }

  void getDishes() async {
    var response = await services.getDishes();
    List<Dish> result = (response['dishes'] as List)
        .map((data) => Dish.fromJson(data))
        .toList();

    setState(() {
      dishes = result;
    });
  }

  void getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (kDebugMode) {
        print(position == null
            ? 'Unknown'
            : '${position.latitude.toString()}, ${position.longitude.toString()}');
      }

      getDishesByLocation(position.latitude, position.longitude);
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  void getDishesByLocation(double lat, double long) async {
    var response = await services.getDishesByLocation(lat: lat, long: long);
    //var response = await services.getDishesByLocation(lat: 29.060613, long: -110.957102);
    if (kDebugMode) {
      print(response);
    }
    List<Dish> result = (response['dishes'] as List)
        .map((data) => Dish.fromJson(data))
        .toList();

    setState(() {
      dishes = result;
    });
  }

  void onSearchDish(text) {
    if (text.length > 0) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SearchScreen(search: text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppProvider>(context, listen: true).items;
    return Scaffold(
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.home),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () async {
                        await storage.delete(key: "jwt");
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LogInScreen()));
                      },
                      icon: const Icon(Boxicons.bx_exit)),
                  const Text(
                    "Delivery App",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Stack(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CartScreen()));
                          },
                          icon: const Icon(Boxicons.bx_cart)),
                      if (data.isNotEmpty)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryColor,
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Container(
                  height: 50,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: const BorderRadius.all(Radius.circular(13)),
                  ),
                  child: TextField(
                      textInputAction: TextInputAction.go,
                      controller: _searchController,
                      onSubmitted: onSearchDish,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: InputBorder.none,
                        hintText: "Search for dishes",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: SizedBox(
                            width: 50,
                            child: Icon(
                              Boxicons.bx_search,
                              color: Colors.grey,
                            )),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              /* Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(),
                ),
              ),*/
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: ImageCarousel(),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: ListView.separated(
                  itemCount: dishes.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => DishCard(
                    id: dishes[index].id!,
                    name: dishes[index].name!,
                    price: dishes[index].price!,
                    image: dishes[index].image!,
                    category: dishes[index].category!,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: defaultPadding),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
