import 'package:anyride_captain/business/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? phoneController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userNotifierProvider);
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phone);
  }

  void saveProfile() {
    final user = ref.read(userNotifierProvider.notifier);
    user.updateUserName(nameController!.text);
    user.updateUserEmail(emailController!.text);
    user.updateUserName(nameController!.text);

    Get.snackbar(
      "Success",
      "Profile Updated",
      backgroundColor: Color.fromRGBO(226, 56, 14, 0.573),
      colorText: Colors.white,
      barBlur: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 24),
            ElevatedButton(onPressed: saveProfile, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
