import 'package:flutter/material.dart';
class logoWithTextName extends StatelessWidget {
  const logoWithTextName({super.key});
 @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: [
        Image.asset("assets/logo_gray.png" ,height: 42,),
        Text("HealthVaults" ,style: TextStyle(fontSize: 28 ,color: Colors.grey ,fontWeight: FontWeight.bold),),
      ],
    );
  }
}
