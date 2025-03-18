import 'package:flutter/material.dart';
import 'home.dart';
class landingPage extends StatefulWidget {
  const landingPage({super.key});

  @override
  State<landingPage> createState() => _landingPageState();
}

class _landingPageState extends State<landingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10.0),
        child: Column(
          children: [
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child:
                  Image.asset("images/building.jpg",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/1.7,
                    fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            const Text("News from around the\n        world for you",style: TextStyle(color: Colors.black,fontSize: 25.0,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20.0,),
            const Text("Best time to read,take your time to read a\n                little more of this world",style: TextStyle(color: Colors.black45,fontSize: 18.0,fontWeight: FontWeight.w500),),
            const SizedBox(height: 50,),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width/1.2,
                child: Material(
                    borderRadius: BorderRadius.circular(30),
                  elevation: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(30)),
                  child: const Center(child: Text("Get started",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
