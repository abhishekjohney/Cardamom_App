// // lib/controllers/transaction_controller.dart
// import 'package:get/get.dart';
// import 'package:shopapp/model/transaction_model.dart';
// import '../services/api_service.dart';

// class TransactionController extends GetxController {
//   final ApiService _apiService = ApiService();
//   var transactions = <Transaction>[].obs;
//   var isLoading = false.obs;
//   var dateFrom = ''.obs;
//   var dateUpto = ''.obs;
//   var partyName = ''.obs;
//   var refNo = ''.obs;
//   var errorMessage = ''.obs;
//   final RxString selectedFilter = 'all'.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     final today = DateTime.now();
//     dateFrom.value = formatDate(today);
//     dateUpto.value = formatDate(today);
//     loadTransactions();
//   }

//   String formatDate(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}-'
//         '${date.month.toString().padLeft(2, '0')}-'
//         '${date.year}';
//   }

//   Future<void> loadTransactions() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       final result = await _apiService.getCardamomData(dateFrom.value);

//       if (result.isEmpty) {
//         errorMessage.value = 'No data found for the selected date';
//       }

//       transactions.value = result;
//     } catch (e) {
//       errorMessage.value = 'Error loading data: $e';
//       print('Error in loadTransactions: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void filterTransactions({
//     String? fromDate,
//     String? uptoDate,
//     String? party,
//     String? reference,
//   }) {
//     dateFrom.value = fromDate ?? dateFrom.value;
//     dateUpto.value = uptoDate ?? dateUpto.value;
//     partyName.value = party ?? '';
//     refNo.value = reference ?? '';
//     loadTransactions();
//   }

//   void setFilter(String filter) {
//     selectedFilter.value = filter;
//     loadTransactions();
//   }
// }
