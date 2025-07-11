# Party Search Implementation - Receipt Entry View

## Overview
This document describes the implementation of server-side party searching functionality in the Receipt Entry View. The search feature allows users to search for parties by name, address, or ID using the API's `ReqByrName` parameter.

## Problem Statement
The original implementation loaded all parties at once and performed local filtering, which was inefficient and didn't utilize the API's built-in search capabilities.

## Solution
Implemented server-side searching with the following features:
- **Debounced Search**: Prevents excessive API calls by waiting 500ms after user stops typing
- **Real-time Search**: Searches as user types using the API's `ReqByrName` parameter
- **Fallback Mechanism**: Falls back to local filtering if API search fails
- **Loading States**: Shows loading indicators during search operations
- **Error Handling**: Graceful error handling with user feedback

## API Changes

### Updated API Service (`lib/services/api_service.dart`)
```dart
Future<List<dynamic>> getPartyList({String? route, String? searchByName}) async
```

**New Parameters:**
- `searchByName`: Optional search term to filter parties by name

**API Request Structure:**
```json
{
  "title": "GetPartyNBalanceList",
  "description": "Request  Bill By Code",
  "ReqType": "1",
  "ReqNofRcds": "",
  "ReqAcaStart": "2025",
  "ReqGroups": "Sundry Debtors",
  "ReqCodes": "",
  "ReqByrName": "search_term_here",
  "ReqRoute": ""
}
```

## UI Changes

### Receipt Entry View (`lib/views/cardamom/receipt_entry_view.dart`)

#### New State Variables
```dart
bool _isSearchingParties = false;
Timer? _searchDebounceTimer;
```

#### Enhanced Search Field
- **Loading Indicator**: Shows spinner during search
- **Debounced Input**: Waits 500ms after user stops typing
- **Real-time Results**: Updates dropdown with search results
- **Clear Functionality**: Improved clear button behavior

#### Search Flow
1. User types in search field
2. Timer starts (500ms debounce)
3. If user continues typing, timer resets
4. After 500ms of no typing, API call is made
5. Results are displayed in dropdown
6. Loading states are managed throughout

## Key Features

### 1. Debounced Search
```dart
void _filterParties(String query) {
  _searchDebounceTimer?.cancel();
  
  if (query.isEmpty) {
    setState(() {
      _filteredPartyList = _partyList;
      _showPartyDropdown = true;
    });
  } else {
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // Perform API search
    });
  }
}
```

### 2. Server-Side Search
```dart
await _loadPartyList(searchQuery: query);
```

### 3. Fallback Mechanism
If API search fails, falls back to local filtering:
```dart
} catch (e) {
  // Fall back to local filtering
  setState(() {
    _filteredPartyList = _partyList.where((party) {
      // Local search logic
    }).toList();
  });
}
```

### 4. Loading States
- Shows spinner in search field during API calls
- Shows "Searching parties..." message in dropdown
- Manages loading state for both initial load and search

## Testing

### Test File: `test_party_search.dart`
A comprehensive test file is provided to verify the search functionality:

```bash
dart test_party_search.dart
```

**Test Cases:**
1. Search for "test" parties
2. Search for "john" parties  
3. Search for "company" parties
4. Empty search (returns all parties)

## Usage

### For Users
1. Open Receipt Entry View
2. Click on the Party field
3. Start typing to search for parties
4. Results appear in dropdown after 500ms
5. Click on a party to select it
6. Use clear button (X) to reset selection

### For Developers
1. The search is automatically triggered when user types
2. API calls are debounced to prevent excessive requests
3. Error handling is built-in with fallback to local search
4. Loading states provide user feedback

## Benefits

1. **Performance**: Only loads relevant parties instead of all parties
2. **User Experience**: Real-time search with visual feedback
3. **Efficiency**: Reduces network traffic and improves response times
4. **Reliability**: Fallback mechanism ensures functionality even if API fails
5. **Scalability**: Works efficiently with large party databases

## API Endpoint Details

**URL:** `https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx`
**Method:** POST
**Content-Type:** `multipart/form-data`

**Search Parameters:**
- `ReqByrName`: Party name to search for (case-insensitive)
- `ReqGroups`: Party group filter (default: "Sundry Debtors")
- `ReqAcaStart`: Academic year (default: current year)

**Response Format:**
```json
{
  "PartyList": [
    {
      "AccAutoID": 123,
      "Byr_nam": "Party Name",
      "AccAddress": "Address",
      "Balance": 1500.00,
      "Byr_Cd": "001"
    }
  ]
}
```

## Troubleshooting

### Common Issues

1. **Search not working**: Check API endpoint and network connectivity
2. **No results**: Verify search term and party database
3. **Slow response**: Check network speed and API server status
4. **Loading stuck**: Check for API errors in console logs

### Debug Information
The implementation includes extensive logging:
- API request/response details
- Search term processing
- Error handling information
- Performance metrics

## Future Enhancements

1. **Advanced Search**: Add filters for address, phone, etc.
2. **Search History**: Remember recent searches
3. **Fuzzy Search**: Implement typo-tolerant search
4. **Caching**: Cache search results for better performance
5. **Pagination**: Handle large result sets with pagination 