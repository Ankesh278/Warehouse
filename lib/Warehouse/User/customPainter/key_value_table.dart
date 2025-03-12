import 'package:Lisofy/Warehouse/User/UserProvider/auth_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeyValueTable extends StatelessWidget {
  final Map<String, String?>? data;
  const KeyValueTable({super.key, this.data});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final showAll = context.watch<AuthUserProvider>().showAll;

    final dataEntries = data ?? {};
    final entries = showAll ? dataEntries.entries.toList() : dataEntries.entries.take(3).toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.1),
        //     blurRadius: 5,
        //     spreadRadius: 1,
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Measurement",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<AuthUserProvider>().toggleShowAll();
                },
                child: Text(
                  showAll ? "View Less" : "View More",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
           SizedBox(height: screenHeight*0.015),
          // Key-Value List
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Column(
              children: entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Key (left column)
                      SizedBox(
                        width: screenWidth * 0.5,
                        child: Text(
                          "${entry.key} :",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      // Value (right column)
                      Expanded(
                        child: Text(
                          entry.value ?? "0",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

