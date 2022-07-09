import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gpa_calc/new_ui/screens/fisrt_screen.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3 ), () {
           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>FirstScreen()), (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
      Column(
         children: [
           Stack(

             children: [
               Container(
                 color: HexColor('FFB42B'),
                 height:MediaQuery.of(context).size.height-24,
                 width:MediaQuery.of(context).size.width,
               ),
               Image.asset('assets/images/sa.png'),
               Container(
                 alignment: AlignmentDirectional.center,
                 height:MediaQuery.of(context).size.height-24,
                 width:MediaQuery.of(context).size.width,

                 child: Center(child:
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Image.asset('assets/images/calculator.png'),
                       SizedBox(height: 15,),
                       Image.asset('assets/images/gpa calculater.png'),
                     ],
                   ),),
               ),
               Container(
                 alignment: AlignmentDirectional.centerEnd,
                   height:MediaQuery.of(context).size.height-24,
                   child: Center(
                       child: Column(
                         children: [
                           SizedBox(height: 600,),
                           Image.asset('assets/images/sp.png'),
                         ],
                       ))),

             ],
           )
         ],
      )
        // Image.asset('assets/SPLASH.png'),
      ),
    );
  }
}