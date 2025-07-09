# Android Party List Implementation Guide

## Overview
This guide provides complete implementation details for integrating the Cardamom ERP Party List functionality into an Android application. The party list module manages customer/supplier information, balances, and locations.

## API Endpoints

### Base URL
```
https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx
```

### Environment Configuration
```
Production: https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx
Test: https://test.magnussoftech.in/WebDataProcessingReact.aspx
Live: https://shoperp.cypherinfosolution.com/WebDataProcessingReact.aspx
```

## Core APIs

### 1. Get Party List with Balances

**Endpoint:** `POST https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx`

**Content-Type:** `multipart/form-data`

**Payload:**
```json
{
  "title": "GetAccountsPartyNBalanceList",
  "description": "Request For Party Display List",
  "ReqUserCode": "USER_CODE",
  "ReqUserId": "USER_ID", 
  "ReqYear": "2024",
  "ReqRoute": "",
  "ReqGroups": "Sundry Debtors"
}
```

**Response Format:**
```json
[
  {
    "JSONData1": "[{\"PartyList\":[{\"AccAutoID\":123,\"AccAutoIDClient\":\"P123\",\"Byr_Cd\":\"001\",\"Byr_nam\":\"Customer Name\",\"AccAddress\":\"Address Line 1\",\"AccAddress1\":\"Address Line 2\",\"AccAddress2\":\"Address Line 3\",\"AccCity\":\"City Name\",\"AccState\":\"State\",\"PhoneNo\":\"9876543210\",\"VATNO\":\"GST123456\",\"Balance\":1500.00,\"BalColor\":\"GREEN\",\"MaxCreditAmount\":50000,\"MaxCreditDays\":30,\"LocationString\":\"Location Details\",\"LocAprYN\":true,\"LocLatLong\":\"10.123,76.456\",\"PartyRemarks\":\"Remarks\",\"Groups\":\"Sundry Debtors\"}]}]"
  }
]
```

### 2. Add New Party

**Endpoint:** `POST https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx`

**Content-Type:** `multipart/form-data`

**Get Blank Template Payload:**
```json
{
  "title": "GetPartyMasterByCode",
  "description": "Request For Party Display List",
  "ReqPartyCode": "0"
}
```

**Create Party Payload:**
```json
{
  "title": "UpdateAccountBook",
  "description": "Request For Party Display List",
  "ReqJSonData": "[{\"ACCORGAUTOID\":1,\"ACCOUNTNO\":\"\",\"ACCQRYSTR\":\"\",\"ACTYP\":\"LED\",\"AccAddress\":\"Customer Address\",\"AccAddress1\":\"\",\"AccAddress2\":\"\",\"AccAutoID\":0,\"AccCity\":\"City\",\"AccState\":\"Kerala\",\"AccountLedger\":null,\"ActionType\":1,\"BALTYPE\":0,\"Byr_Cd\":\"NEW001\",\"Byr_nam\":\"New Customer\",\"CLBalColor\":\"\",\"CLBalance\":0,\"CLIENTPRFIX\":\"\",\"CLIENTTRANSID\":\"\",\"CMNT\":\"\",\"CNTRY1\":\"\",\"CONTACTPERSON\":\"Contact Person\",\"CONTACTTITLE\":\"\",\"COPBLS\":0,\"CSTNO\":\"\",\"CUSTYPE\":\"\",\"EMAIL\":\"\",\"EMAIL2\":\"\",\"FOB1\":\"\",\"GROUPS\":\"Sundry Debtors\",\"GRPHANDLE\":\"\",\"GRPUNDER\":\"\",\"ISDROPPED\":false,\"ImpCode\":0,\"LCNO\":\"\",\"LEDTYPE\":\"\",\"LTYPE\":\"\",\"LateBillsAmount\":0,\"MNGRP\":\"\",\"MSSB\":0,\"MaxCreditAmount\":0,\"MaxCreditDays\":0,\"NATURE\":\"\",\"NofLateBills\":0,\"NofPendingBills\":0,\"OPBLS\":0,\"OPCRBLC\":0,\"OPDRBLC\":0,\"ORDERBY\":\"\",\"Old_Byr_nam\":\"\",\"OrgAutoid\":1,\"PANNO\":\"\",\"PLBAL\":\"\",\"PhoneNo\":\"9876543210\",\"PinCode\":\"682022\",\"REFNO1\":\"0\",\"REFNO2\":\"\",\"REFNO3\":\"\",\"RELID\":32,\"RELTYPE\":\"\",\"STNO\":\"\",\"SVRUPDYN\":0,\"TDSYN\":false,\"TRANSPORT\":\"\",\"VATNO\":\"GST123\",\"WORKTYPE\":\"\",\"pcap\":0,\"sbgrp\":\"\"}]"
}
```

### 3. Get Party Payment Details

**Endpoint:** `POST https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx`

**Payload:**
```json
{
  "title": "GetPartyPaymentDetails",
  "description": "Request For Party Payment Details",
  "ReqYear": "2024",
  "ReqBuyerName": "Customer Name",
  "ReqAccAutoID": "123",
  "ReqFromDate": "",
  "ReqToDate": ""
}
```

### 4. Update Party Location

**Endpoint:** `POST https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx`

**Payload:**
```json
{
  "title": "UpdatePartyLocationDetails", 
  "description": "Update Party Location",
  "ReqPartyId": "P123",
  "ReqLatitude": "10.123456",
  "ReqLongitude": "76.654321",
  "ReqAddress": "Updated Address",
  "ReqPlace": "Location Place"
}
```

## Android Implementation

### 1. Data Models

```kotlin
// PartyItem.kt
data class PartyItem(
    val accAutoID: Int,
    val accAutoIDClient: String,
    val byrCd: String,
    val byrNam: String,
    val accAddress: String,
    val accAddress1: String?,
    val accAddress2: String?,
    val accCity: String?,
    val accState: String?,
    val phoneNo: String?,
    val vatno: String?,
    val balance: Double,
    val balColor: String,
    val maxCreditAmount: Double,
    val maxCreditDays: Int,
    val locationString: String?,
    val locAprYN: Boolean,
    val locLatLong: String?,
    val partyRemarks: String?,
    val groups: String
)

// PartyListResponse.kt
data class PartyListResponse(
    val partyList: List<PartyItem>
)

// AddPartyRequest.kt
data class AddPartyRequest(
    val accorgautoid: Int = 1,
    val accountno: String = "",
    val accqrystr: String = "",
    val actyp: String = "LED",
    val accAddress: String,
    val accAddress1: String = "",
    val accAddress2: String = "",
    val accAutoID: Int = 0,
    val accCity: String,
    val accState: String,
    val accountLedger: Any? = null,
    val actionType: Int = 1,
    val baltype: Int = 0,
    val byrCd: String,
    val byrNam: String,
    val clBalColor: String = "",
    val clBalance: Int = 0,
    val clientprfix: String = "",
    val clienttransid: String = "",
    val cmnt: String = "",
    val cntry1: String = "",
    val contactperson: String,
    val contacttitle: String = "",
    val copbls: Int = 0,
    val cstno: String = "",
    val custype: String = "",
    val email: String = "",
    val email2: String = "",
    val fob1: String = "",
    val groups: String,
    val grphandle: String = "",
    val grpunder: String = "",
    val isdropped: Boolean = false,
    val impCode: Int = 0,
    val lcno: String = "",
    val ledtype: String = "",
    val ltype: String = "",
    val lateBillsAmount: Int = 0,
    val mngrp: String = "",
    val mssb: Int = 0,
    val maxCreditAmount: Double,
    val maxCreditDays: Int,
    val nature: String = "",
    val nofLateBills: Int = 0,
    val nofPendingBills: Int = 0,
    val opbls: Int = 0,
    val opcrblc: Double,
    val opdrblc: Double,
    val orderby: String = "",
    val oldByrNam: String = "",
    val orgAutoid: Int = 1,
    val panno: String = "",
    val plbal: String = "",
    val phoneNo: String,
    val pinCode: String,
    val refno1: String,
    val refno2: String = "",
    val refno3: String = "",
    val relid: Int,
    val reltype: String = "",
    val stno: String = "",
    val svrupdyn: Int = 0,
    val tdsyn: Boolean = false,
    val transport: String = "",
    val vatno: String,
    val worktype: String = "",
    val pcap: Int = 0,
    val sbgrp: String = ""
)
```

### 2. API Service

```kotlin
// PartyApiService.kt
interface PartyApiService {
    @Multipart
    @POST("WebDataProcessingReact.aspx")
    suspend fun getPartyList(
        @Part("title") title: RequestBody,
        @Part("description") description: RequestBody,
        @Part("ReqUserCode") userCode: RequestBody,
        @Part("ReqUserId") userId: RequestBody,
        @Part("ReqYear") year: RequestBody,
        @Part("ReqRoute") route: RequestBody,
        @Part("ReqGroups") groups: RequestBody
    ): Response<String>
    
    @Multipart
    @POST("WebDataProcessingReact.aspx")
    suspend fun addNewParty(
        @Part("title") title: RequestBody,
        @Part("description") description: RequestBody,
        @Part("ReqJSonData") jsonData: RequestBody
    ): Response<String>
    
    @Multipart
    @POST("WebDataProcessingReact.aspx")
    suspend fun getPartyTemplate(
        @Part("title") title: RequestBody,
        @Part("description") description: RequestBody,
        @Part("ReqPartyCode") partyCode: RequestBody
    ): Response<String>
    
    @Multipart
    @POST("WebDataProcessingReact.aspx")
    suspend fun getPartyPaymentDetails(
        @Part("title") title: RequestBody,
        @Part("description") description: RequestBody,
        @Part("ReqYear") year: RequestBody,
        @Part("ReqBuyerName") buyerName: RequestBody,
        @Part("ReqAccAutoID") accAutoID: RequestBody,
        @Part("ReqFromDate") fromDate: RequestBody,
        @Part("ReqToDate") toDate: RequestBody
    ): Response<String>
}
```

### 3. Repository

```kotlin
// PartyRepository.kt
class PartyRepository(private val apiService: PartyApiService) {
    
    suspend fun getPartyList(
        userCode: String,
        userId: String,
        year: String,
        route: String = "",
        groups: String = "Sundry Debtors"
    ): Result<PartyListResponse> {
        return try {
            val response = apiService.getPartyList(
                title = "GetAccountsPartyNBalanceList".toRequestBody(),
                description = "Request For Party Display List".toRequestBody(),
                userCode = userCode.toRequestBody(),
                userId = userId.toRequestBody(),
                year = year.toRequestBody(),
                route = route.toRequestBody(),
                groups = groups.toRequestBody()
            )
            
            if (response.isSuccessful) {
                val responseBody = response.body()
                responseBody?.let { 
                    val parsedData = parsePartyListResponse(it)
                    Result.success(parsedData)
                } ?: Result.failure(Exception("Empty response"))
            } else {
                Result.failure(Exception("API Error: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun addNewParty(partyData: AddPartyRequest): Result<Boolean> {
        return try {
            val jsonData = Gson().toJson(listOf(partyData))
            val response = apiService.addNewParty(
                title = "UpdateAccountBook".toRequestBody(),
                description = "Request For Party Display List".toRequestBody(),
                jsonData = jsonData.toRequestBody()
            )
            
            if (response.isSuccessful) {
                val responseBody = response.body()
                val success = responseBody?.contains("||JasonEnd") == true
                Result.success(success)
            } else {
                Result.failure(Exception("Failed to add party"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    private fun parsePartyListResponse(rawResponse: String): PartyListResponse {
        val endMarkerPos = rawResponse.indexOf("||JasonEnd")
        val jsonString = if (endMarkerPos != -1) {
            rawResponse.substring(0, endMarkerPos)
        } else rawResponse
        
        val responseArray = Gson().fromJson(jsonString, Array<Map<String, Any>>::class.java)
        val jsonData1 = responseArray[0]["JSONData1"] as String
        val partyData = Gson().fromJson(jsonData1, Map::class.java)
        val partyList = partyData["PartyList"] as List<Map<String, Any>>
        
        val parties = partyList.map { party ->
            PartyItem(
                accAutoID = (party["AccAutoID"] as Double).toInt(),
                accAutoIDClient = party["AccAutoIDClient"] as String,
                byrCd = party["Byr_Cd"] as String,
                byrNam = party["Byr_nam"] as String,
                accAddress = party["AccAddress"] as String,
                accAddress1 = party["AccAddress1"] as String?,
                accAddress2 = party["AccAddress2"] as String?,
                accCity = party["AccCity"] as String?,
                accState = party["AccState"] as String?,
                phoneNo = party["PhoneNo"] as String?,
                vatno = party["VATNO"] as String?,
                balance = party["Balance"] as Double,
                balColor = party["BalColor"] as String,
                maxCreditAmount = party["MaxCreditAmount"] as Double,
                maxCreditDays = (party["MaxCreditDays"] as Double).toInt(),
                locationString = party["LocationString"] as String?,
                locAprYN = party["LocAprYN"] as Boolean,
                locLatLong = party["LocLatLong"] as String?,
                partyRemarks = party["PartyRemarks"] as String?,
                groups = party["Groups"] as String
            )
        }
        
        return PartyListResponse(parties)
    }
    
    private fun String.toRequestBody() = toRequestBody("text/plain".toMediaType())
}
```

### 4. ViewModel

```kotlin
// PartyViewModel.kt
class PartyViewModel(private val repository: PartyRepository) : ViewModel() {
    
    private val _partyList = MutableLiveData<List<PartyItem>>()
    val partyList: LiveData<List<PartyItem>> = _partyList
    
    private val _filteredPartyList = MutableLiveData<List<PartyItem>>()
    val filteredPartyList: LiveData<List<PartyItem>> = _filteredPartyList
    
    private val _loading = MutableLiveData<Boolean>()
    val loading: LiveData<Boolean> = _loading
    
    private val _error = MutableLiveData<String>()
    val error: LiveData<String> = _error
    
    private val _totalSum = MutableLiveData<TotalSum>()
    val totalSum: LiveData<TotalSum> = _totalSum
    
    fun loadPartyList(userCode: String, userId: String, year: String, groups: String = "Sundry Debtors") {
        viewModelScope.launch {
            _loading.value = true
            repository.getPartyList(userCode, userId, year, "", groups)
                .onSuccess { response ->
                    _partyList.value = response.partyList
                    _filteredPartyList.value = response.partyList
                    calculateTotalSum(response.partyList)
                    _loading.value = false
                }
                .onFailure { exception ->
                    _error.value = exception.message
                    _loading.value = false
                }
        }
    }
    
    fun searchParties(query: String) {
        val currentList = _partyList.value ?: return
        val filtered = if (query.isEmpty()) {
            currentList
        } else {
            currentList.filter { party ->
                party.byrNam.contains(query, ignoreCase = true) ||
                party.accAddress.contains(query, ignoreCase = true)
            }
        }
        _filteredPartyList.value = filtered
    }
    
    fun sortParties(sortType: String) {
        val currentList = _filteredPartyList.value?.toMutableList() ?: return
        when (sortType) {
            "A-Z" -> currentList.sortBy { it.byrNam }
            "Z-A" -> currentList.sortByDescending { it.byrNam }
            "L-H" -> currentList.sortBy { it.balance }
            "H-L" -> currentList.sortByDescending { it.balance }
        }
        _filteredPartyList.value = currentList
    }
    
    fun filterByGroup(group: String) {
        loadPartyList(getCurrentUserCode(), getCurrentUserId(), getCurrentYear(), group)
    }
    
    fun excludeZeroBalance(exclude: Boolean) {
        val currentList = _partyList.value ?: return
        _filteredPartyList.value = if (exclude) {
            currentList.filter { it.balance != 0.0 }
        } else {
            currentList
        }
    }
    
    fun addNewParty(partyData: AddPartyRequest) {
        viewModelScope.launch {
            _loading.value = true
            repository.addNewParty(partyData)
                .onSuccess { success ->
                    if (success) {
                        // Refresh party list
                        loadPartyList(getCurrentUserCode(), getCurrentUserId(), getCurrentYear())
                    }
                    _loading.value = false
                }
                .onFailure { exception ->
                    _error.value = exception.message
                    _loading.value = false
                }
        }
    }
    
    private fun calculateTotalSum(parties: List<PartyItem>) {
        var greenTotal = 0.0
        var blueTotal = 0.0
        var redTotal = 0.0
        var grandTotal = 0.0
        
        parties.forEach { party ->
            grandTotal += party.balance
            when (party.balColor.uppercase()) {
                "GREEN" -> greenTotal += party.balance
                "BLUE" -> blueTotal += party.balance
                "RED" -> redTotal += party.balance
            }
        }
        
        _totalSum.value = TotalSum(
            due = greenTotal,
            advance = blueTotal,
            total = redTotal,
            grandTotal = grandTotal
        )
    }
    
    // Helper functions to get current user data from SharedPreferences or session
    private fun getCurrentUserCode(): String = "USER_CODE"
    private fun getCurrentUserId(): String = "USER_ID"
    private fun getCurrentYear(): String = "2024"
}

data class TotalSum(
    val due: Double,
    val advance: Double,
    val total: Double,
    val grandTotal: Double
)
```

### 5. State Codes Helper

```kotlin
// StateCodesHelper.kt
object StateCodesHelper {
    private val stateCodes = mapOf(
        "Andaman and Nicobar Islands" to 35,
        "Andhra Pradesh" to 37,
        "Arunachal Pradesh" to 12,
        "Assam" to 18,
        "Bihar" to 10,
        "Chandigarh" to 4,
        "Chhattisgarh" to 22,
        "Dadra and Nagar Haveli and Daman and Diu" to 26,
        "Delhi" to 7,
        "Goa" to 30,
        "Gujarat" to 24,
        "Haryana" to 6,
        "Himachal Pradesh" to 2,
        "Jammu and Kashmir" to 1,
        "Jharkhand" to 20,
        "Karnataka" to 29,
        "Kerala" to 32,
        "Ladakh" to 38,
        "Lakshadweep" to 31,
        "Madhya Pradesh" to 23,
        "Maharashtra" to 27,
        "Manipur" to 14,
        "Meghalaya" to 17,
        "Mizoram" to 15,
        "Nagaland" to 13,
        "Odisha" to 21,
        "Puducherry" to 34,
        "Punjab" to 3,
        "Rajasthan" to 8,
        "Sikkim" to 11,
        "Tamil Nadu" to 33,
        "Telangana" to 36,
        "Tripura" to 16,
        "Uttar Pradesh" to 9,
        "Uttarakhand" to 5,
        "West Bengal" to 19
    )
    
    fun getStateCode(stateName: String): Int {
        return stateCodes[stateName] ?: 0
    }
    
    fun getAllStates(): List<String> {
        return stateCodes.keys.toList().sorted()
    }
}
```

## Frontend UI Components

### 1. Party List Fragment/Activity

```kotlin
// PartyListFragment.kt
class PartyListFragment : Fragment() {
    
    private lateinit var binding: FragmentPartyListBinding
    private lateinit var viewModel: PartyViewModel
    private lateinit var adapter: PartyListAdapter
    
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentPartyListBinding.inflate(inflater, container, false)
        return binding.root
    }
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        setupRecyclerView()
        setupObservers()
        setupListeners()
        
        viewModel.loadPartyList("USER_CODE", "USER_ID", "2024")
    }
    
    private fun setupRecyclerView() {
        adapter = PartyListAdapter { party ->
            // Handle party item click - show details
            showPartyDetails(party)
        }
        binding.recyclerViewParties.adapter = adapter
    }
    
    private fun setupObservers() {
        viewModel.filteredPartyList.observe(viewLifecycleOwner) { parties ->
            adapter.submitList(parties)
        }
        
        viewModel.loading.observe(viewLifecycleOwner) { isLoading ->
            binding.progressBar.isVisible = isLoading
        }
        
        viewModel.totalSum.observe(viewLifecycleOwner) { totalSum ->
            binding.textGrandTotal.text = "GT: ${totalSum.grandTotal}"
            binding.textDue.text = totalSum.due.toString()
            binding.textAdvance.text = totalSum.advance.toString()
            binding.textTotal.text = totalSum.total.toString()
        }
    }
    
    private fun setupListeners() {
        binding.searchView.setOnQueryTextListener(object : SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(query: String?): Boolean = false
            
            override fun onQueryTextChange(newText: String?): Boolean {
                viewModel.searchParties(newText ?: "")
                return true
            }
        })
        
        binding.spinnerSort.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                val sortTypes = arrayOf("", "A-Z", "Z-A", "L-H", "H-L")
                if (position > 0) {
                    viewModel.sortParties(sortTypes[position])
                }
            }
            
            override fun onNothingSelected(parent: AdapterView<*>?) {}
        }
        
        binding.spinnerGroup.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                val groups = arrayOf("", "Sundry Debtors", "Sundry Creditors")
                if (position > 0) {
                    viewModel.filterByGroup(groups[position])
                }
            }
            
            override fun onNothingSelected(parent: AdapterView<*>?) {}
        }
        
        binding.checkboxExcludeZero.setOnCheckedChangeListener { _, isChecked ->
            viewModel.excludeZeroBalance(isChecked)
        }
        
        binding.fabAddParty.setOnClickListener {
            showAddPartyDialog()
        }
    }
    
    private fun showPartyDetails(party: PartyItem) {
        // Navigate to party details screen or show dialog
        findNavController().navigate(
            PartyListFragmentDirections.actionPartyListToPartyDetails(party.accAutoID)
        )
    }
    
    private fun showAddPartyDialog() {
        // Show add party dialog or navigate to add party screen
        findNavController().navigate(
            PartyListFragmentDirections.actionPartyListToAddParty()
        )
    }
}
```

### 2. Add New Party Form

```kotlin
// AddPartyFragment.kt
class AddPartyFragment : Fragment() {
    
    private lateinit var binding: FragmentAddPartyBinding
    private lateinit var viewModel: PartyViewModel
    
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentAddPartyBinding.inflate(inflater, container, false)
        return binding.root
    }
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        setupStateSpinner()
        setupGroupSpinner()
        setupListeners()
    }
    
    private fun setupStateSpinner() {
        val states = StateCodesHelper.getAllStates()
        val adapter = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_item, states)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.spinnerState.adapter = adapter
    }
    
    private fun setupGroupSpinner() {
        val groups = arrayOf("Sundry Debtors", "Sundry Creditors", "Cash Account", "Bank Account")
        val adapter = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_item, groups)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.spinnerGroups.adapter = adapter
    }
    
    private fun setupListeners() {
        binding.buttonSave.setOnClickListener {
            saveParty()
        }
        
        binding.buttonCancel.setOnClickListener {
            findNavController().popBackStack()
        }
    }
    
    private fun saveParty() {
        val selectedState = binding.spinnerState.selectedItem as String
        val selectedGroup = binding.spinnerGroups.selectedItem as String
        
        val partyData = AddPartyRequest(
            byrCd = binding.editTextCode.text.toString(),
            byrNam = binding.editTextPartyName.text.toString(),
            accAddress = binding.editTextAddress.text.toString(),
            accAddress1 = binding.editTextAddress1.text.toString(),
            accAddress2 = binding.editTextAddress2.text.toString(),
            accCity = binding.editTextCity.text.toString(),
            accState = selectedState,
            phoneNo = binding.editTextPhone.text.toString(),
            vatno = binding.editTextGST.text.toString(),
            groups = selectedGroup,
            cmnt = binding.editTextRemarks.text.toString(),
            opcrblc = if (binding.checkboxCredit.isChecked) binding.editTextOpening.text.toString().toDoubleOrNull() ?: 0.0 else 0.0,
            opdrblc = if (!binding.checkboxCredit.isChecked) binding.editTextOpening.text.toString().toDoubleOrNull() ?: 0.0 else 0.0,
            maxCreditAmount = binding.editTextMaxCreditAmount.text.toString().toDoubleOrNull() ?: 0.0,
            maxCreditDays = binding.editTextMaxCreditDays.text.toString().toIntOrNull() ?: 0,
            contactperson = binding.editTextContactPerson.text.toString(),
            refno1 = binding.editTextDiscount.text.toString(),
            accountno = binding.editTextBankDetails.text.toString(),
            pinCode = binding.editTextPinCode.text.toString(),
            relid = StateCodesHelper.getStateCode(selectedState)
        )
        
        if (validateForm(partyData)) {
            viewModel.addNewParty(partyData)
        }
    }
    
    private fun validateForm(partyData: AddPartyRequest): Boolean {
        if (partyData.byrNam.isEmpty()) {
            binding.editTextPartyName.error = "Party name is required"
            return false
        }
        return true
    }
}
```

## Error Handling

### Common Issues and Solutions

1. **HTML Response Instead of JSON:**
   - Check if backend server is running
   - Verify authentication tokens
   - Ensure correct endpoint URL

2. **Response Parsing:**
   - Look for `||JasonEnd` marker in response
   - Parse only content before the marker
   - Handle nested JSON in `JSONData1` field

3. **Authentication:**
   - Include valid UserCode and UserId in requests
   - Ensure user session is active

## Testing

### Sample Test Cases

```kotlin
// PartyRepositoryTest.kt
@Test
fun testGetPartyList() = runTest {
    // Mock API response
    val mockResponse = """[{"JSONData1":"[{\"PartyList\":[{\"AccAutoID\":123,\"Byr_nam\":\"Test Party\"}]}]"}]||JasonEnd"""
    
    // Test repository call
    val result = repository.getPartyList("USER123", "ID123", "2024")
    
    assertTrue(result.isSuccess)
    assertEquals(1, result.getOrNull()?.partyList?.size)
}
```

## Performance Optimization

1. **Pagination:** Implement server-side pagination for large party lists
2. **Caching:** Cache party list data locally using Room database
3. **Search Optimization:** Implement debounced search to reduce API calls
4. **Image Loading:** Use Glide or Picasso for loading party images efficiently

## Security Considerations

1. **API Security:** Use HTTPS for all API calls
2. **Data Validation:** Validate all input data before sending to server
3. **Session Management:** Implement proper session timeout handling
4. **Data Encryption:** Encrypt sensitive data in local storage

This comprehensive guide provides everything needed to implement the party list functionality in an Android application, including all necessary API endpoints, data models, and UI components.
