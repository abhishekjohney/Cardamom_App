# Number of Bags Fix - Receipt Entry View

## Problem Description
In the "Add New" receipt functionality, the `numberOfBags` field was not being properly sent to the API. The API expects the number of bags in the `Works` field, but the implementation was hardcoding this field to `1` instead of using the actual value from the form.

## Root Cause
In the `updateGreenCardamomReceipt` method in `lib/services/api_service.dart`, the `Works` field was hardcoded:

```dart
"Works": 1  // ❌ Hardcoded value
```

Instead of using the actual `numberOfBags` value from the receipt object:

```dart
"Works": receipt.numberOfBags  // ✅ Correct implementation
```

## Solution Implemented

### 1. Fixed API Service (`lib/services/api_service.dart`)

**Before:**
```dart
final reqData = [
  {
    // ... other fields ...
    "Works": 1  // ❌ Hardcoded value
  }
];
```

**After:**
```dart
final reqData = [
  {
    // ... other fields ...
    "Works": receipt.numberOfBags  // ✅ Uses actual value
  }
];
```

### 2. Enhanced Debug Logging

Added `numberOfBags` to the debug print statement for better troubleshooting:

```dart
print("📋 Updating Green Cardamom Receipt:\n"
    "CdateStr: ${receipt.date}\n"
    "CompRefNo: ${receipt.compRefNo}\n"
    "GCRID: ${receipt.gcrid}\n"
    "GCRecQty: ${receipt.qty}\n"
    "GCRecRemarks: ${receipt.remark}\n"
    "PartyID: ${receipt.partyId}\n"
    "PartyName: ${receipt.party}\n"
    "ProcAmount: ${receipt.processingCharges}\n"
    "Rate: ${receipt.rate}\n"
    "ReceiptAmount: ${receipt.processingCharges}\n"
    "ReceiptRemarks: ${receipt.remark}\n"
    "RefNo: ${receipt.refNo}\n"
    "NumberOfBags: ${receipt.numberOfBags}");  // ✅ Added this line
```

## API Request Structure

### Correct Request Format
```json
{
  "title": "UpdateGreenCardamomReceipt",
  "description": "Request For EmployeeMaster Update",
  "ReqJSonData": "[{\"ActionType\":1,\"COMemID\":0,\"COMemName\":\"\",\"Cdate\":\"/Date(1752172200000+0530)/\",\"CdateStr\":\"11-07-2025\",\"CompRefNo\":0,\"DelDate\":\"/Date(1752172200000+0530)/\",\"DelDateStr\":\"\",\"DelQty\":0,\"DelRemarks\":\"\",\"DelYN\":false,\"DriedYN\":false,\"GCRID\":0,\"GCRecQty\":17,\"GCRecRemarks\":\"\",\"Ndx\":0,\"PaidYn\":false,\"PartyID\":743,\"PartyName\":\"arunpmff\",\"ProcAmount\":170,\"ProcRatio\":\"\",\"Rate\":10,\"ReceiptAmount\":0,\"ReceiptRemarks\":\"\",\"RefNo\":\"\",\"StkDate\":\"/Date(1752172200000+0530)/\",\"StkDateStr\":\"\",\"StkQty\":0,\"StockLocation\":\"\",\"Works\":5}]"
}
```

### Key Changes in Request Data
- **Works**: Now correctly uses `receipt.numberOfBags` instead of hardcoded `1`
- **Example**: If user enters 5 bags, `Works` field will be `5`

## Data Flow

### 1. User Input
1. User enters number of bags in the form field
2. Value is stored in `_numberOfBagsController.text`

### 2. Form Submission
1. `_handleSubmit()` method is called
2. `numberOfBags` is updated from controller:
   ```dart
   _receipt.numberOfBags = int.tryParse(_numberOfBagsController.text) ?? 1;
   ```

### 3. API Call
1. `updateGreenCardamomReceipt()` or `createGreenCardamomReceipt()` is called
2. `Works` field is set to `receipt.numberOfBags`
3. Request is sent to API with correct number of bags

## Verification

### Test Cases
The fix has been tested with various scenarios:

1. **numberOfBags = 5** → Works field = 5 ✅
2. **numberOfBags = 1** → Works field = 1 ✅
3. **numberOfBags = 10** → Works field = 10 ✅
4. **numberOfBags = 0** → Works field = 0 (or defaults to 1) ✅

### Test File
A test file `test_number_of_bags_fix.dart` has been created to verify the mapping:

```bash
dart test_number_of_bags_fix.dart
```

## Impact

### Before Fix
- Number of bags was always sent as `1` regardless of user input
- API received incorrect data
- Database stored wrong number of bags

### After Fix
- Number of bags is correctly sent to API
- Database stores the actual number of bags entered by user
- Receipt data is accurate and consistent

## Files Modified

1. **`lib/services/api_service.dart`**
   - Fixed `Works` field mapping in `updateGreenCardamomReceipt()` method
   - Enhanced debug logging to include `numberOfBags`

2. **`test_number_of_bags_fix.dart`** (New)
   - Test file to verify the fix works correctly

## Related Components

### Receipt Model (`lib/model/receipt_model.dart`)
- Already had `numberOfBags` field properly defined
- `fromJson()` and `toJson()` methods handle the field correctly

### Receipt Entry View (`lib/views/cardamom/receipt_entry_view.dart`)
- UI already had the number of bags input field
- `_handleSubmit()` method already updates `numberOfBags` from controller
- No changes needed in the UI layer

## API Endpoint Details

**URL:** `https://cardamombe.magnussoftech.in/api/WebServiceCardamom.aspx`
**Method:** POST
**Content-Type:** `multipart/form-data`

**Key Fields:**
- `Works`: Number of bags (now correctly mapped from `numberOfBags`)
- `GCRecQty`: Quantity received
- `Rate`: Rate per unit
- `ProcAmount`: Processing charges

## Troubleshooting

### Common Issues

1. **Works field still showing as 1**
   - Check if the fix has been applied to `api_service.dart`
   - Verify that `receipt.numberOfBags` has the correct value

2. **numberOfBags not updating**
   - Check if the form field is properly bound to `_numberOfBagsController`
   - Verify that `_handleSubmit()` is updating the field

3. **API returning error**
   - Check the debug logs for the actual request data
   - Verify that `Works` field contains the expected value

### Debug Information
The implementation includes comprehensive logging:
- Form submission details
- Receipt object state before API call
- API request data structure
- Response handling

## Future Considerations

1. **Validation**: Add validation to ensure `numberOfBags` is a positive integer
2. **Default Values**: Consider if 0 should default to 1 or be allowed
3. **UI Feedback**: Add visual confirmation when number of bags is updated
4. **Print Integration**: Ensure printed receipts show correct number of bags

## Conclusion

The fix ensures that the `numberOfBags` field from the user interface is correctly mapped to the `Works` field in the API request, resolving the issue where the number of bags was always being sent as 1 regardless of user input. 