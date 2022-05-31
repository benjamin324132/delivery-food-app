import 'package:delivery_app/components/dish_card.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/dish.dart';
import 'package:delivery_app/services/services.dart';
import 'package:delivery_app/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:geolocator/geolocator.dart';

class SearchScreen extends StatefulWidget {
  final String search;

  const SearchScreen({Key? key, required this.search}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Dish> dishes = [];
  Services services = Services();
  late TextEditingController _searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController(text: widget.search);
    getLocation();
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
    var response = await services.getDishesByLocation(
        lat: lat, long: long, keyword: _searchController.text);
    // var response = await services.getDishesByLocation(lat: 29.060613, long: -110.957102, keyword: _searchController.text);
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
      getLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
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
      )),
    );
  }
}
