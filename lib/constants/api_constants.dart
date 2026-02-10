class ApiConstants {
  static const String baseUrl = 'http://localhost:5000/api';

  // Auth
  static const String login = '$baseUrl/users/login';
  static const String register = '$baseUrl/users/register';

  // Products
  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/products/categories';
  static String productById(String id) => '$baseUrl/products/$id';
  static String productByBarcode(String barcode) =>
      '$baseUrl/products/barcode/$barcode';

  //Customers
  static const String customers = '$baseUrl/customers';
  //cart
  static const String cart = '$baseUrl/cart';
}
