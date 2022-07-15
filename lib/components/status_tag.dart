import 'package:delivery_app/utils/parseStatus.dart';
import 'package:flutter/material.dart';

class StatusTag extends StatelessWidget {
  const StatusTag({ Key? key, this.status = "PENDING" }) : super(key: key);
 final String? status;

  Color parseStatusColor(String? status) {
    switch (status) {
      case "PENDING":
        return Colors.blueAccent;
      case "COOKING":
        return Colors.pinkAccent;
      case "INTRANSIT":
        return Colors.purpleAccent;
      case "DELIVERED":
        return Colors.greenAccent;
      case "CANCELED":
        return Colors.redAccent;
      default:
        return Colors.blueAccent;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: parseStatusColor(status),
        borderRadius:const BorderRadius.all(Radius.circular(8))
      ),
      child: Text(parseStatus(status), style:const TextStyle(color: Colors.white),),
    );
  }
}