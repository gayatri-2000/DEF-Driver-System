import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:def_driver_system/View/Controller/trip_controller.dart';
import 'package:def_driver_system/View/Constant/app_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:def_driver_system/View/Utils/app_layout.dart';
import 'package:def_driver_system/View/Screen/bottom_bar.dart';

class DeliveryVerificationScreen extends StatefulWidget {
  final int stopIndex;
  final String pumpName;
  final int barrelsQty;
  final int cansQty;
  final String expectedOtp;

  const DeliveryVerificationScreen({
    super.key,
    required this.stopIndex,
    required this.pumpName,
    required this.barrelsQty,
    required this.cansQty,
    required this.expectedOtp,
  });

  @override
  State<DeliveryVerificationScreen> createState() => _DeliveryVerificationScreenState();
}

class _DeliveryVerificationScreenState extends State<DeliveryVerificationScreen> {
  final TripController _tripController = Get.find<TripController>();
  
  // Multi-step Wizard state
  int _currentStep = 1; // 1: Verify, 2: OTP, 3: POD

  // OTP inputs
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  // POD inputs
  late SignatureController _signatureController;
  bool _isPhotoUploaded = false;
  bool _isLoading = false;
  bool _isOtpSending = false;
  bool _isOtpVerifying = false;
  final ImagePicker _picker = ImagePicker();
  String? _photoBase64;

  // Financial calculations
  double _baseAmount = 0.0;
  double _gstAmount = 0.0;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.grey.shade50,
    );

    // Dynamic price engine matching Velachery stop (18 Barrels = 45000, 18% GST = 8100, Total = 53100)
    _baseAmount = (widget.barrelsQty * 2500.0) + (widget.cansQty * 500.0);
    _gstAmount = _baseAmount * 0.18;
    _totalAmount = _baseAmount + _gstAmount;
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    _signatureController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'HI',
      symbol: '₹',
      decimalDigits: 0,
    ).format(amount);
  }

  void _sendOtpAction() async {
    setState(() {
      _isOtpSending = true;
    });

    bool success = await _tripController.sendDeliveryOtp(widget.stopIndex);

    setState(() {
      _isOtpSending = false;
    });

    if (success) {
      setState(() {
        _currentStep = 2; // Advance to Step 2: OTP
      });
    }
  }

  void _resendOtpAction() async {
    setState(() {
      _isOtpSending = true;
    });

    // Clear current OTP controllers
    for (var c in _otpControllers) {
      c.clear();
    }

    bool success = await _tripController.sendDeliveryOtp(widget.stopIndex);

    setState(() {
      _isOtpSending = false;
    });

    if (success) {
      // Focus on first input again
      if (mounted) {
        _otpFocusNodes[0].requestFocus();
      }
    }
  }

  void _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _photoBase64 = base64Encode(bytes);
          _isPhotoUploaded = true;
        });
      }
    } catch (e) {
      errorSnackBar(
        "Error picking image",
        e.toString(),
      );
    }
  }

  void _showImageSourceSelector() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Photo Source",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff0C243E),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: appColor),
              title: const Text("Camera (Capture Photo)", style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: appColor),
              title: const Text("Gallery (Upload Existing)", style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  bool _isOtpFilled() {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  String _getEnteredOtp() {
    return _otpControllers.map((c) => c.text).join();
  }

  void _verifyOtpStep() async {
    if (!_isOtpFilled()) return;

    setState(() {
      _isOtpVerifying = true;
    });

    final enteredOtp = _getEnteredOtp();
    bool success = await _tripController.verifyDeliveryOtp(widget.stopIndex, enteredOtp);

    setState(() {
      _isOtpVerifying = false;
    });

    if (success) {
      setState(() {
        _currentStep = 3; // Advance to POD
      });
    }
  }

  void _submitDelivery() async {
    if (_signatureController.isEmpty) {
      errorSnackBar(
        "Signature Required",
        "Please collect the customer's signature.",
      );
      return;
    }

    if (!_isPhotoUploaded) {
      errorSnackBar(
        "POD Photo Required",
        "Please take a photo of the delivered goods.",
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final sigBytes = await _signatureController.toPngBytes();
    String sigBase64 = sigBytes != null ? base64Encode(sigBytes) : "";

    bool success = await _tripController.submitProofOfDelivery(
      widget.stopIndex,
      signatureBase64: sigBase64,
      photoBase64: _photoBase64 ?? "",
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      successSnackBar(
        "Delivery Completed!",
        "Invoice generated and stock levels updated successfully.",
      );
      Get.offAll(() => const AppBottomBar());
    } else {
      errorSnackBar(
        "Error",
        "Something went wrong while completing the delivery.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Delivery Confirmation",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              "Order ORD00${widget.stopIndex}",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Wizard Stepper Header Widget
            _buildStepper(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2. Delivery Details Card
                    _buildDetailsCard(),
                    const SizedBox(height: 16),

                    // 3. Dynamic Step Panel
                    if (_currentStep == 1) _buildVerifyStepPanel(),
                    if (_currentStep == 2) _buildOtpStepPanel(),
                    if (_currentStep == 3) _buildPodStepPanel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: Colors.white,
      child: Row(
        children: [
          // Step 1: Verify
          Column(
            children: [
              _buildStepCircle(1),
              const SizedBox(height: 6),
              _buildStepLabel("Verify", 1),
            ],
          ),
          // Line 1
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                height: 3,
                color: _currentStep > 1 ? greenColor : Colors.grey.shade200,
              ),
            ),
          ),
          // Step 2: OTP
          Column(
            children: [
              _buildStepCircle(2),
              const SizedBox(height: 6),
              _buildStepLabel("OTP", 2),
            ],
          ),
          // Line 2
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                height: 3,
                color: _currentStep > 2 ? greenColor : Colors.grey.shade200,
              ),
            ),
          ),
          // Step 3: POD
          Column(
            children: [
              _buildStepCircle(3),
              const SizedBox(height: 6),
              _buildStepLabel("POD", 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int stepNum) {
    bool isCompleted = _currentStep > stepNum;
    bool isActive = _currentStep == stepNum;

    Color bg = Colors.grey.shade200;
    Widget child = Text(
      stepNum.toString(),
      style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13),
    );

    if (isCompleted) {
      bg = greenColor;
      child = const Icon(Icons.check, color: Colors.white, size: 16);
    } else if (isActive) {
      bg = appColor;
      child = Text(
        stepNum.toString(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Center(child: child),
    );
  }

  Widget _buildStepLabel(String text, int stepNum) {
    bool isActive = _currentStep == stepNum;
    bool isCompleted = _currentStep > stepNum;
    Color textColor = Colors.grey;

    if (isActive || isCompleted) {
      textColor = const Color(0xff0C243E);
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        color: textColor,
      ),
    );
  }

  Widget _buildDetailsCard() {
    String qtyString = "";
    if (widget.barrelsQty > 0 && widget.cansQty > 0) {
      qtyString = "${widget.barrelsQty} Barrels + ${widget.cansQty} Cans";
    } else if (widget.barrelsQty > 0) {
      qtyString = "${widget.barrelsQty} Barrels";
    } else if (widget.cansQty > 0) {
      qtyString = "${widget.cansQty} Cans";
    }

    return Container(
      decoration: _buildCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Delivery Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
          ),
          const SizedBox(height: 12),
          // Location Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, color: greyTextColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pumpName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "321, Velachery Main Road, Chennai - 600042",
                      style: TextStyle(fontSize: 12, color: greyTextColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Items
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: greyTextColor, size: 18),
              const SizedBox(width: 8),
              Text(
                qtyString,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Financial Row Breakdown
          _buildFinancialRow("Amount", _formatCurrency(_baseAmount), isBold: false),
          const SizedBox(height: 8),
          _buildFinancialRow("GST (18%)", _formatCurrency(_gstAmount), isBold: false),
          const SizedBox(height: 12),
          _buildFinancialRow("Total", _formatCurrency(_totalAmount), isBold: true, color: appColor),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value, {required bool isBold, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? const Color(0xff0C243E) : greyTextColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: color ?? const Color(0xff0C243E),
          ),
        ),
      ],
    );
  }

  // PANEL 1: Verify Order
  Widget _buildVerifyStepPanel() {
    return Container(
      decoration: _buildCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Verify Order details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
          ),
          const SizedBox(height: 8),
          Text(
            "Verify that the loaded cargo matches the delivery quantities listed above.",
            style: TextStyle(fontSize: 12, color: greyTextColor),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isOtpSending ? null : _sendOtpAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isOtpSending ? Colors.grey.shade300 : appColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: _isOtpSending
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    "Verify and Proceed",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  // PANEL 2: Enter OTP
  Widget _buildOtpStepPanel() {
    return Container(
      decoration: _buildCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Enter OTP",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
          ),
          const SizedBox(height: 6),
          Text(
            "Please ask the customer for the 6-digit OTP sent to their registered mobile number",
            style: TextStyle(fontSize: 12, color: greyTextColor),
          ),
          const SizedBox(height: 20),

          // 6 digit inputs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 42,
                height: 50,
                child: TextFormField(
                  controller: _otpControllers[index],
                  focusNode: _otpFocusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: textFieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: appColor, width: 2),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    if (value.length == 1) {
                      if (index < 5) {
                        _otpFocusNodes[index + 1].requestFocus();
                      } else {
                        _otpFocusNodes[index].unfocus();
                      }
                    } else if (value.isEmpty) {
                      if (index > 0) {
                        _otpFocusNodes[index - 1].requestFocus();
                      }
                    }
                    setState(() {});
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Resend OTP trigger link
          GestureDetector(
            onTap: _isOtpSending ? null : _resendOtpAction,
            child: Center(
              child: _isOtpSending
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(
                            color: appColor,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Resending OTP...",
                          style: TextStyle(
                            color: appColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      "Resend OTP",
                      style: TextStyle(
                        color: appColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),



          // Verify OTP button
          ElevatedButton(
            onPressed: (_isOtpFilled() && !_isOtpVerifying) ? _verifyOtpStep : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: (_isOtpFilled() && !_isOtpVerifying) ? appColor : Colors.grey.shade300,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: _isOtpVerifying
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "Verify OTP",
                    style: TextStyle(
                      color: (_isOtpFilled() && !_isOtpVerifying) ? Colors.white : Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // PANEL 3: Proof of Delivery (POD)
  Widget _buildPodStepPanel() {
    return Container(
      decoration: _buildCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Proof of Delivery (POD)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
          ),
          const SizedBox(height: 6),
          Text(
            "Capture customer signature and take photo of the delivered barrels/cans.",
            style: TextStyle(fontSize: 12, color: greyTextColor),
          ),
          const SizedBox(height: 20),

          // Photo capture box
          GestureDetector(
            onTap: _showImageSourceSelector,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: textFieldColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isPhotoUploaded ? greenColor : lightGreyColor,
                  width: _isPhotoUploaded ? 1.5 : 1,
                ),
              ),
              child: _isPhotoUploaded && _photoBase64 != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            base64Decode(_photoBase64!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 28),
                              SizedBox(width: 8),
                              Text(
                                "POD Photo Attached",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPhotoUploaded = false;
                                _photoBase64 = null;
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, size: 36, color: greyTextColor),
                        const SizedBox(height: 8),
                        Text(
                          "Tap to Capture Delivery Photo",
                          style: TextStyle(fontSize: 13, color: greyTextColor, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // Signature Pad
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Customer Signature",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
              ),
              TextButton(
                onPressed: () => _signatureController.clear(),
                child: const Text("Clear", style: TextStyle(color: appColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Signature(
                controller: _signatureController,
                height: 140,
                backgroundColor: Colors.grey.shade50,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submit button
          ElevatedButton(
            onPressed: _isLoading ? null : _submitDelivery,
            style: ElevatedButton.styleFrom(
              backgroundColor: appColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Text(
                    "SUBMIT PROOF OF DELIVERY",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
