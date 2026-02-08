import 'dart:convert';
import 'package:dream_pos/constants/api_constants.dart';
import 'package:dream_pos/screens/customers/models/customer_model.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  Future<List<Customer>> getCustomers(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getCustomers),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final data = jsonBody['data'];
        // print("${data}");

        final List<Customer> customers = (data as List)
            .map((c) => Customer.fromJson(c))
            .toList()
            .cast<Customer>();
        print("${customers.length}");
        return customers;
      }
      return [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> deleteCustomer(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.deleteCustomer}/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final jsonBody = jsonDecode(response.body);
      print(jsonBody);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
