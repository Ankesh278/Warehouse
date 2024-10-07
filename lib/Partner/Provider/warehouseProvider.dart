import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WarehouseProvider with ChangeNotifier {
  Map<String, bool> _warehouseStatus = {};

  Map<String, bool> get warehouseStatus => _warehouseStatus;

  // Initialize status from the pre-fetched data
  void initializeStatus(String warehouseId, bool status) {
    _warehouseStatus[warehouseId] = status;
  }

  // Update warehouse availability status
  Future<void> updateWarehouseStatus(String warehouseId, bool status) async {
    final url = Uri.parse(
        'http://xpacesphere.com/api/Wherehousedt/UpdIsAvailable'); // Updated to HTTPS

    try {
      // Send the HTTP POST request
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        // Setting the header for JSON data
        body: json.encode({
          'Id': warehouseId,
          // The Id parameter, should match the correct field name
          'isavailable': status?1:0
          // The isavailable status
        }),
      );

      // Check for success or failure
      if (response.statusCode == 200) {
        print('Warehouse status updated successfully');
        _warehouseStatus[warehouseId] = status;
         notifyListeners();
      } else {
        print('Failed to update warehouse status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error updating warehouse status: $e');
    }
  }
}

// _warehouseStatus[warehouseId] = status;
// notifyListeners();