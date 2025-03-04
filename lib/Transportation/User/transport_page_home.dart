import 'package:Lisofy/Transportation/User/adress_booking.dart';
import 'package:Lisofy/Transportation/common/custom_app_bar/custom_button.dart';
import 'package:Lisofy/Transportation/common/custom_app_bar/cutom_app_bar.dart';
import 'package:flutter/material.dart';

class TransportPageHome extends StatefulWidget {
  const TransportPageHome({super.key});

  @override
  State<TransportPageHome> createState() => _TransportPageHomeState();
}

class _TransportPageHomeState extends State<TransportPageHome> {
  String? selectedContainer;
  String? expandedContainer;
  final List<String> items = ["Unshared", "Shared", "Specialized"];

  final Map<String, String> itemDetails = {
    "Unshared":
        "Unshared transport provides exclusive use of a vehicle, ensuring privacy and direct service.",
    "Shared":
        "Shared transport allows multiple passengers to split the cost, making it more economical.",
    "Specialized":
        "Specialized transport is tailored for specific goods or needs, like refrigerated or fragile items."
  };

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double paddingHorizontal = mediaQuery.size.width * 0.07;
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "TRANSPORTATION",
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: mediaQuery.size.height * 0.12),
                const Text(
                  "Choose your booking",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 18),
                ),
                SizedBox(height: mediaQuery.size.height * 0.05),
                ...items.map((item) => Column(
                      children: [
                        buildContainer(item),
                        SizedBox(
                            height: mediaQuery.size.height *
                                0.02),
                      ],
                    )),
                SizedBox(height: mediaQuery.size.height * 0.05),
                if (selectedContainer != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: mediaQuery.size.height * 0.02),
                      child: CustomButton(
                        text: "Book Now",
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const GoogleMapScreen()));
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContainer(String title) {
    bool isSelected = selectedContainer == title;
    bool isExpanded = expandedContainer == title;
    final mediaQuery = MediaQuery.of(context);
    double paddingHorizontal = mediaQuery.size.width * 0.05;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (isExpanded) {
                expandedContainer = null;
                selectedContainer = title;
              } else {
                selectedContainer = title;
              }
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal, vertical: mediaQuery.size.height*0.005),
            decoration: BoxDecoration(
              color: isExpanded
                  ? Colors.grey.shade300
                  : (isSelected ? Colors.blue : Colors.white),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(mediaQuery.size.width * 0.02),
                topRight: Radius.circular(mediaQuery.size.width * 0.02),
                bottomLeft: isExpanded
                    ? Radius.zero
                    : Radius.circular(mediaQuery.size.width * 0.02),
                bottomRight: isExpanded
                    ? Radius.zero
                    : Radius.circular(mediaQuery.size.width * 0.02),
              ),
              border: Border.all(
                  color: isExpanded ? Colors.grey.shade300 : Colors.grey,
                  width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isExpanded && isSelected
                        ? Colors.black
                        : isSelected
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    color: isExpanded && isSelected
                        ? Colors.black
                        : isSelected
                        ? Colors.white
                        : Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      expandedContainer = isExpanded ? null : title;
                    });
                  },
                ),

              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          constraints: isExpanded
              ?  BoxConstraints(minHeight: mediaQuery.size.height*0.1, maxHeight: mediaQuery.size.height*0.2)
              : const BoxConstraints(maxHeight: 0),
          padding: EdgeInsets.symmetric(
            horizontal: mediaQuery.size.width * 0.05,
            vertical: isExpanded ? mediaQuery.size.height * 0.015 : 0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(mediaQuery.size.width * 0.02),
              bottomRight: Radius.circular(mediaQuery.size.width * 0.02),
            ),
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isExpanded ? 1.0 : 0.0,
            child: isExpanded
                ? Text(
                    itemDetails[title] ?? "No details available.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
