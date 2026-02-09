import 'dart:convert';
import 'package:dream_pos/constants/api_constants.dart';
import 'package:dream_pos/screens/customers/models/customer_model.dart';
import 'package:dream_pos/utils/api_result.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  Future<List<Customer>> getCustomers(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.customers),
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

  Future<ApiResult> deleteCustomer(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.customers}/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final jsonBody = jsonDecode(response.body);
      print(jsonBody);
      if (response.statusCode == 200) {
        return Success(jsonBody['data'], jsonBody['message']);
      } else {
        return Failure(
          message: jsonBody['message'],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  Future<ApiResult<Customer>> createCustomer(
    String token,
    Customer customer,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.customers),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(customer.toJson()),
      );
      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = Customer.fromJson(jsonBody['data']);
        return Success(data, jsonBody['message']);
      } else {
        return Failure(
          message: jsonBody['message'],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return Failure(message: e.toString());
    }
  }

  Future<ApiResult<Customer>> updateCustomer(
    String id,
    String token,
    Customer customer,
  ) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.customers}/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(customer.toJson()),
    );
    final jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = Customer.fromJson(jsonBody['data']);
      return Success(data, jsonBody['message']);
    } else {
      return Failure(
        message: jsonBody['message'],
        statusCode: response.statusCode,
      );
    }
  }
}
