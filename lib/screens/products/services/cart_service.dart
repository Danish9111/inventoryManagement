

// import 'dart:convert';

// import 'package:dream_pos/utils/api_result.dart';

// class CartService {
//   Future<ApiResult<Cart>> getCart()async{
//     try {
//       final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
//       if(response.statusCode == 200){
//         final data = jsonDecode(response.body);
//         return ApiResult.success(data);
//       }else{
//         return ApiResult.error("Failed to fetch cart");
//       }
//     } catch (e) {
//       return ApiResult.error("Failed to fetch cart");
//     }
//   }
// }