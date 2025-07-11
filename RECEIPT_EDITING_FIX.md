# Receipt Editing Fix - Number of Bags Issue

## Problem Description
When editing an existing receipt, the "Number of Bags" field was always showing as `1` regardless of the actual value stored in the database. This was happening because the `Receipt.fromJson` method was looking for the wrong field name in the API response.

## Root Cause
The issue was in the `Receipt.fromJson` method in `lib/model/receipt_model.dart`. It was looking for `json['NumberOfBags']` but the API response uses `json['Works']` for the number of bags field.

**Before Fix:**
```dart
numberOfBags: int.tryParse(json['NumberOfBags']?.toString() ?? '1') ?? 1,  // ❌ Wrong field name
```

**After Fix:**
```dart
numberOfBags: int.tryParse(json['Works']?.toString() ?? '1') ?? 1,  // ✅ Correct field name
```

## Solution Implemented

### 1. Fixed Receipt Model (`lib/model/receipt_model.dart`)

**Updated fromJson method:**
```dart
factory Receipt.fromJson(Map<String, dynamic> json) {
  return Receipt(
    gcrid: json['GCRID'] ?? 0,
    compRefNo: json['CompRefNo']?.toString() ?? '',
    date: json['CdateStr'] ?? '',
    refNo: json['RefNo'] ?? '',
    party: json['PartyName'] ?? '',
    partyId: json['PartyID'] ?? 0,
    qty: double.tryParse(json['GCRecQty']?.toString() ?? '0') ?? 0,
    rate: double.tryParse(json['Rate']?.toString() ?? '0') ?? 0,
    processingCharges: double.tryParse(json['ProcAmount']?.toString() ?? '0') ?? 0,
    numberOfBags: int.tryParse(json['Works']?.toString() ?? '1') ?? 1,  // ✅ Fixed
    remark: json['GCRecRemarks'] ?? '',
  );
}
```

**Updated toJson method:**
```dart
Map<String, dynamic> toJson() {
  return {
    'GCRID': gcrid,
    'CompRefNo': compRefNo,
    'CdateStr': date,
    'RefNo': refNo,
    'PartyName': party,
    'PartyID': partyId,
    'GCRecQty': qty,
    'Rate': rate,
    'ProcAmount': processingCharges,
    'Works': numberOfBags,  // ✅ Consistent with API
    'GCRecRemarks': remark,
  };
}
```

## Data Flow for Editing

### 1. Load Receipt for Editing
1. User clicks edit on a receipt
2. `getGreenCardamomReceiptByCode()` is called with GCRID
3. API returns receipt data with `Works` field containing number of bags
4. `Receipt.fromJson()` parses the response and correctly maps `Works` to `numberOfBags`
5. UI controllers are updated with the correct values

### 2. Display in UI
1. `_updateControllers()` method is called
2. `_numberOfBagsController.text = _receipt.numberOfBags.toString()`
3. UI shows the correct number of bags

### 3. Save Changes
1. User modifies the number of bags
2. `_handleSubmit()` updates `_receipt.numberOfBags` from controller
3. API call uses `Works: receipt.numberOfBags` in the request
4. Database is updated with the correct value

## API Response Structure

### Example API Response for Editing
```json
{
  "GCRID": 123,
  "CompRefNo": "12345",
  "CdateStr": "11-07-2025",
  "RefNo": "REF001",
  "PartyName": "Test Party",
  "PartyID": 456,
  "GCRecQty": 17.0,
  "Rate": 10.0,
  "ProcAmount": 170.0,
  "Works": 5,  // ✅ This field contains the number of bags
  "GCRecRemarks": "Test remark"
}
```

### Parsed Receipt Object
```dart
Receipt(
  gcrid: 123,
  compRefNo: "12345",
  date: "11-07-2025",
  refNo: "REF001",
  party: "Test Party",
  partyId: 456,
  qty: 17.0,
  rate: 10.0,
  processingCharges: 170.0,
  numberOfBags: 5,  // ✅ Correctly parsed from Works field
  remark: "Test remark"
)
```

## Verification

### Test Cases
The fix has been tested with various scenarios:

1. **Works = 5** → numberOfBags = 5 ✅
2. **Works = 1** → numberOfBags = 1 ✅
3. **Works = 10** → numberOfBags = 10 ✅
4. **Works = null** → numberOfBags = 1 (default) ✅

### Test File
A comprehensive test file `test_receipt_editing.dart` has been created:

```bash
dart test_receipt_editing.dart
```

**Test Coverage:**
- API response parsing
- Round-trip conversion (JSON → Object → JSON)
- UI controller updates
- Default value handling

## Impact

### Before Fix
- Number of bags always showed as `1` when editing
- User couldn't see the actual stored value
- Confusion about what value was actually saved

### After Fix
- Number of bags correctly displays the stored value
- User can see and modify the actual number of bags
- Consistent behavior between add and edit modes

## Files Modified

1. **`lib/model/receipt_model.dart`**
   - Fixed `fromJson()` method to use `json['Works']` instead of `json['NumberOfBags']`
   - Updated `toJson()` method to use `'Works'` field name for consistency

2. **`test_receipt_editing.dart`** (New)
   - Comprehensive test file for editing functionality

## Related Components

### Receipt Entry View (`lib/views/cardamom/receipt_entry_view.dart`)
- Already had proper UI handling for `numberOfBags`
- `_updateControllers()` method correctly updates the controller
- No changes needed in the UI layer

### API Service (`lib/services/api_service.dart`)
- Already correctly sends `Works` field in API requests
- No changes needed in the service layer

## Troubleshooting

### Common Issues

1. **Still showing 1 when editing**
   - Check if the fix has been applied to `receipt_model.dart`
   - Verify that the API response contains the `Works` field
   - Check debug logs for the actual API response

2. **API response doesn't have Works field**
   - Check if the database actually stores the correct value
   - Verify that the API endpoint returns the `Works` field
   - Check for any data migration issues

3. **UI not updating**
   - Check if `_updateControllers()` is being called
   - Verify that `_numberOfBagsController.text` is being set
   - Check for any UI state management issues

### Debug Information
The implementation includes comprehensive logging:
- API response data structure
- Parsed receipt object values
- UI controller updates
- Form submission data

## API Endpoint Details

**URL:** `https://cardamombe.magnussoftech.in/api/WebServiceCardamom.aspx`
**Method:** POST
**Content-Type:** `multipart/form-data`

**Get Receipt Request:**
```json
{
  "title": "GetGreenCardamomReceiptByCode",
  "description": "",
  "ReqGCRID": 123
}
```

**Expected Response Fields:**
- `Works`: Number of bags (now correctly parsed)
- `GCRecQty`: Quantity received
- `Rate`: Rate per unit
- `ProcAmount`: Processing charges

## Future Considerations

1. **Data Migration**: Ensure existing records have correct `Works` values
2. **Validation**: Add validation for `Works` field in API responses
3. **Error Handling**: Improve error handling for missing `Works` field
4. **Backward Compatibility**: Consider handling both field names during transition

## Conclusion

The fix ensures that when editing existing receipts, the "Number of Bags" field correctly displays the actual value stored in the database by properly parsing the `Works` field from the API response. This resolves the issue where the field always showed as 1 regardless of the stored value. 