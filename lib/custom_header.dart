import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomHeader extends StatelessWidget {
  final String headerText;
  final VoidCallback onMenuPressed;
  final VoidCallback onNotificationPressed;
  final VoidCallback onProfilePressed;
  final String? profileImage;

  const CustomHeader({
    super.key,
    required this.headerText,
    required this.onMenuPressed,
    required this.onNotificationPressed,
    required this.onProfilePressed,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    if (profileImage == null || profileImage!.isEmpty) {
      _showToast("Profile image URL is empty.");
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: onMenuPressed,
                tooltip: 'Open side menu',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  headerText,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: onNotificationPressed,
              ),
              GestureDetector(
                onTap: onProfilePressed,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: profileImage != null && profileImage!.isNotEmpty
                      ? NetworkImage(profileImage!)
                      : const AssetImage('assets/images/shoes.png')
                          as ImageProvider,
                  child: profileImage == null || profileImage!.isEmpty
                      ? const Icon(Icons.person, size: 20, color: Colors.grey)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
