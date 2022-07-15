import 'package:delivery_app/components/coustom_bottom_nav_bar.dart';
import 'package:delivery_app/components/dish_card.dart';
import 'package:delivery_app/components/image_carousel.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/enums.dart';
import 'package:delivery_app/models/dish.dart';
import 'package:delivery_app/models/notification.dart';
import 'package:delivery_app/provider/app_provider.dart';
import 'package:delivery_app/screens/cart/cart_screen.dart';
import 'package:delivery_app/screens/cart/cart_screen_2.dart';
import 'package:delivery_app/screens/login/login_screen.dart';
import 'package:delivery_app/screens/search/search_screen.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/size_config.dart';
import 'package:delivery_app/utils/getLocation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FirebaseMessaging _messaging;
  List<Dish> dishes = [];
  Services services = Services();
  final storage = FlutterSecureStorage();
  late VideoPlayerController _controller;
  TextEditingController _searchController = TextEditingController();
  //late int _totalNotifications;
  PushNotification? _notificationInfo;
  String currentAddres = "Delivery";

  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    /* _controller = VideoPlayerController.network(
        'https://stream.mux.com/DA8s5WZXSrVYqzMa1RyKoMjI6bfglPy8/high.mp4?token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InQ5UHZucm9ZY0hQNjhYSmlRQnRHTEVVSkVSSXJ0UXhKIn0.eyJleHAiOjE2NTI4MjgxODksImF1ZCI6InYiLCJzdWIiOiJEQThzNVdaWFNyVllxek1hMVJ5S29Nakk2YmZnbFB5OCJ9.sq75Lkb6lc-_aJUt9QPPfE74iYPMfExhwxdMjNNMHcTSJxgGd7bHhIYsQL0L9MQTCwDJw8rNh7eTXKYghduczag1TgE2D6MX_1SFv-zgMwmA5odrGWMO45zDaRZb8JbhPvvSZ0BsVxPUy-T7LwHqJsZsaZsI_xxNxV3jtYy0bdT9dpceOsEGnbBesi7dGsQ7t4C01cxw3fTVJtXmbd8BZdz9kjmFHRoka3Npe8GgZgB-kzeNATAvhhNEg-8CPDW6b9rHBHbhLKVvqYNi9SjlGLEzqQsOY4B_zRsDH1TYe1TaO2LACNiMzaRVaNBWs7pujSKmt9zT7NxM16Mf8MHkwQ')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });*/
    registerNotification();
    //checkForInitialMessage();

    super.initState();
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
        if (message.notification != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(message.notification!.title!),
            subtitle: Text(message.notification!.body!),
            background: Colors.grey.shade50,
            duration: const Duration(seconds: 2),
          );
        }
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

// For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
      });
    }
  }

  void getLocation() async {
    try {
      Position? position = await getCurrentLocation();

      if (position != null) {
        getDishesByLocation(position.latitude, position.longitude);
        getCurrentAddress(position.latitude, position.longitude);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  void getDishesByLocation(double lat, double long) async {
    var response = await services.getDishesByLocation(lat: lat, long: long);
    //var response =await services.getDishesByLocation(lat: 29.060613, long: -110.957102);
    //var response = await services.getDishes();
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

  void getCurrentAddress(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      Placemark placeMark = placemarks[0];
      String? street = placeMark.street;
      //String name = placeMark.name;
      String? subLocality = placeMark.subLocality;
      String? postalCode = placeMark.postalCode;
      String address = "$street, $subLocality, $postalCode";
      setState(() {
        currentAddres = address;
      });
    } catch (err) {
      print(err);
    }
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
                  Expanded(
                    child: Text(
                      currentAddres,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CartScreen2()));
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
