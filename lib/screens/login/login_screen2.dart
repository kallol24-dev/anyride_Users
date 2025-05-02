import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../wigets/loginwidgets.dart';

class LoginScreen2 extends ConsumerWidget {
  LoginScreen2({Key? key}) : super(key: key);

  
  
   final countryPicker = const FlCountryCodePicker();

  CountryCode countryCode = CountryCode(
    name: 'India',
    code: "IN",
    dialCode: "+91",
  );

 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bannerWidget(),
              const SizedBox(height: 50),
              loginWidget(countryCode, () async {
                final code = await countryPicker.showPicker(context: context);
                if (code != null) countryCode = code;
                
              }, (String mobileNumber, CountryCode code) => onSubmit(ref, mobileNumber, code)),
            ],
          ),
        ),
      ),
    );
  }

}


