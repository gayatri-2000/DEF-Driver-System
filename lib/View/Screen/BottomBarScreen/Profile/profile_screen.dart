import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/auth_controller.dart';
import '../../../Constant/app_color.dart';
import '../../Login/login_screen.dart';
import '../../../Utils/app_layout.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = Get.find<AuthController>();
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final driver = _authController.currentDriver;

    // Fallback static driver info if session has no driver
    final name = driver?.name ?? "Rajesh Kumar";
    final id = driver?.id ?? "DRV12345";
    final rating = driver?.rating ?? 4.8;
    final totalDeliveries = driver?.totalDeliveries ?? 2847;
    final onTimeRate = driver?.onTimeRate ?? 98.0;
    final thisMonthDeliveries = driver?.thisMonthDeliveries ?? 156;
    final phone = driver?.phone ?? "+91 98765 43210";
    final email = driver?.email ?? "rajesh.kumar@defdelivery.com";
    final baseLocation = driver?.baseLocation ?? "Chennai Plant";
    final vehicleReg = driver?.vehicleReg ?? "TN 01 AB 1234";
    final vehicleLicense = driver?.vehicleLicense ?? "TN-1234567890";

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Blue Profile Header Area
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [appColor, Color(0xff0950C4)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.only(top: 60, bottom: 40, left: 24, right: 24),
              child: Column(
                children: [
                  // Profile Photo/Avatar
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color: appColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Name & ID
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "ID: $id",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Rating Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    rating.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Three Metrics Grid (Overlaying top)
                  Transform.translate(
                    offset: const Offset(0, -24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatBox(Icons.bookmark_outline, totalDeliveries.toString(), "Deliveries", Colors.blue),
                        _buildStatBox(Icons.access_time, "${onTimeRate.toStringAsFixed(0)}%", "On-Time", Colors.green),
                        _buildStatBox(Icons.trending_up, thisMonthDeliveries.toString(), "This Month", Colors.purple),
                      ],
                    ),
                  ),

                  // Contact Information Heading
                  const Text(
                    "Contact Information",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0C243E),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Contact Info Card
                  Container(
                    decoration: _buildSectionBoxDecoration(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        _buildInfoTile(Icons.phone_outlined, Colors.blue.shade50, Colors.blue, "Phone Number", phone),
                        const Divider(height: 1, indent: 56),
                        _buildInfoTile(Icons.mail_outline_rounded, Colors.green.shade50, Colors.green, "Email Address", email),
                        const Divider(height: 1, indent: 56),
                        _buildInfoTile(Icons.location_on_outlined, Colors.purple.shade50, Colors.purple, "Base Location", baseLocation),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Vehicle Information Heading
                  const Text(
                    "Vehicle Information",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0C243E),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Vehicle Info Card
                  Container(
                    decoration: _buildSectionBoxDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: appColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.local_shipping_outlined, color: appColor, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vehicleReg,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0C243E),
                                  ),
                                ),
                                const Text(
                                  "Assigned Vehicle",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: textFieldColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "License Number",
                                style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                vehicleLicense,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0C243E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Settings Heading
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0C243E),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Settings Card
                  Container(
                    decoration: _buildSectionBoxDecoration(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        // Notification Toggle
                        ListTile(
                          leading: const Icon(Icons.notifications_none_outlined, color: Color(0xff0C243E)),
                          title: const Text(
                            "Notifications",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
                          ),
                          subtitle: const Text(
                            "Push notifications for new trips",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          trailing: Switch(
                            value: _pushNotifications,
                            onChanged: (val) {
                              setState(() {
                                _pushNotifications = val;
                              });
                            },
                            activeColor: appColor,
                          ),
                        ),
                        const Divider(height: 1, indent: 56),
                        // Privacy tile
                        _buildSettingsNavigationTile(Icons.shield_outlined, "Privacy & Security", "Manage your privacy settings"),
                        const Divider(height: 1, indent: 56),
                        // App Settings tile
                        _buildSettingsNavigationTile(Icons.settings_outlined, "App Settings", "Language, theme, and more"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Logout Button
                  InkWell(
                    onTap: () {
                      _authController.logout();
                      Get.offAll(() => const LoginScreen());
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: redColor.withOpacity(0.06),
                        border: Border.all(color: redColor.withOpacity(0.2), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.exit_to_app, color: redColor, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: redColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Build details version footer
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "DEF Driver App v1.0.0",
                          style: TextStyle(color: greyTextColor, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Member since Jan 2024",
                          style: TextStyle(color: greyTextColor.withOpacity(0.6), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildSectionBoxDecoration() {
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

  Widget _buildStatBox(IconData icon, String value, String title, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 3,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff0C243E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: greyTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, Color bgIcon, Color iconColor, String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgIcon,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          color: greyTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xff0C243E),
        ),
      ),
    );
  }

  Widget _buildSettingsNavigationTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff0C243E)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff0C243E)),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: () {
        successSnackBar(
          title,
          "This setting menu is static for this preview.",
        );
      },
    );
  }
}
