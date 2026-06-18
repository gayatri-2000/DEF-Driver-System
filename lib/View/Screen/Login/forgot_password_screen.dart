import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/auth_controller.dart';
import '../../Constant/app_color.dart';
import '../../Utils/app_layout.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController _authController = Get.find<AuthController>();

  bool _isLoading = false;
  bool _isSendingOtp = false;
  bool _obscurePassword = true;

  // Countdown timer for OTP resend
  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _handleSendOtp() async {
    final mobile = _mobileController.text.trim();
    if (mobile.isEmpty) {
      errorSnackBar(
        "Required",
        "Please enter your mobile number first",
      );
      return;
    }

    setState(() {
      _isSendingOtp = true;
    });

    try {
      bool success = await _authController.sendOtp(mobile);
      if (success) {
        _startTimer();
      }
    } catch (e) {
      debugPrint("Send OTP error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isSendingOtp = false;
        });
      }
    }
  }

  void _handleResetPassword() async {
    debugPrint("=== ForgotPasswordScreen: _handleResetPassword initiated ===");
    if (_formKey.currentState == null) {
      debugPrint("Form key state is null!");
    }
    bool isValid = _formKey.currentState!.validate();
    debugPrint("Form validation status: $isValid");
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    final mobile = _mobileController.text.trim();
    final otp = _otpController.text.trim();
    final newPassword = _passwordController.text.trim();
    debugPrint("Form inputs: mobile=$mobile, otp=$otp, newPassword=$newPassword");

    try {
      bool success = await _authController.resetPasswordAction(
        mobile: mobile,
        otp: otp,
        newPassword: newPassword,
      );

      debugPrint("Reset password action result success: $success");

      if (success) {
        debugPrint("Navigating back to Login screen using Get.back.");
        if (mounted) {
          Get.back();
        }
        successSnackBar("Success", "Password reset successfully!");
      }
    } catch (e) {
      debugPrint("Reset password error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff0C243E)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: size.height * 0.02),
                  // Title Header
                  const Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0C243E), // darkColor
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Reset your account password",
                    style: TextStyle(
                      fontSize: 14,
                      color: greyTextColor,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),

                  // Mobile Input with Send OTP button
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      hintText: "Enter your registered number",
                      prefixIcon: const Icon(Icons.phone_outlined, color: appColor),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: UnconstrainedBox(
                          child: ElevatedButton(
                            onPressed: (_secondsRemaining > 0 || _isSendingOtp) ? null : _handleSendOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade200,
                              disabledForegroundColor: Colors.grey.shade500,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: _isSendingOtp
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : Text(
                                    _secondsRemaining > 0 ? "${_secondsRemaining}s" : "Send OTP",
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: textFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: appColor, width: 1.5),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please enter your mobile number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // OTP Input
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "OTP Verification",
                      hintText: "Enter the code sent to WhatsApp",
                      prefixIcon: const Icon(Icons.lock_outline, color: appColor),
                      filled: true,
                      fillColor: textFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: appColor, width: 1.5),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please enter the OTP verification code";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // New Password Input
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      hintText: "Enter your new password",
                      prefixIcon: const Icon(Icons.lock_reset_outlined, color: appColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: greyTextColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: textFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: appColor, width: 1.5),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please enter your new password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 36),

                  // Reset Password Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Reset Password",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Back to Login text link
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Back To Login",
                      style: TextStyle(
                        color: appColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
