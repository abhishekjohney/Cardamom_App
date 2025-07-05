// // lib/controllers/receipt_controller.dart
// import 'dart:convert';

// import 'package:get/get.dart';
// import 'package:shopapp/model/receipt_model.dart';
// import '../services/api_service.dart';

// class ReceiptController extends GetxController {
//   final ApiService _apiService = ApiService();

//   final receipt = Rx<Receipt?>(null);
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     if (Get.arguments != null && Get.arguments['GCRID'] != null) {
//       loadReceiptDetails(Get.arguments['GCRID']);
//     }
//   }

//   Future<void> loadReceiptDetails(int gcrid) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       final result = await _apiService.getGreenCardamomReceiptByCode(gcrid);

//       if (result['success'] && result['data'] != null) {
//         final receiptData = result!['data'][0];
//         receipt.value = Receipt.fromJson(receiptData);
//       } else {
//         errorMessage.value = 'Failed to load receipt details';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: $e';
//       print('Error loading receipt details: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool> updateReceipt(Receipt updatedReceipt) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       final formData = FormData.fromMap({
//         'title': 'UpdateGreenCardamomReceipt',
//         'ReqJSonData': json.encode([updatedReceipt.toJson()])
//       });

//       final result = await _apiService.getFormattedResponse(formData);

//       if (result['success']) {
//         Get.back(result: true);
//         return true;
//       } else {
//         errorMessage.value = 'Failed to update receipt';
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: $e';
//       print('Error updating receipt: $e');
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
