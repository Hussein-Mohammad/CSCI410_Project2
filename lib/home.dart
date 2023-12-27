import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quiztime.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/image1.png'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.teal[900],
      body: Center(
        child: Column(

          children: [
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  quiztime(calculationType: '+'),
                  ),
                );
              },


              style: ElevatedButton.styleFrom(backgroundColor: Colors.black ,shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),)),
              child:Image.asset('assets/addition.png',height: 150,width: 350),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  quiztime(calculationType: '-'),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(backgroundColor: Colors.black,shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),)),
              child: Image.asset('assets/subtraction.png',height: 150,width: 350),

            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  quiztime(calculationType: 'x'),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(backgroundColor: Colors.black ,shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),)),
              child: Image.asset('assets/multiplication.png',height: 150,width: 350),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  quiztime(calculationType: '/'),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(backgroundColor: Colors.black ,shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),)),
              child: Image.asset('assets/division.png',height: 150,width: 350),

            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {

                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black ,shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),)),
              child: Text('Quit',style: TextStyle(fontSize: 25,color: Colors.blueGrey[800]),),

            ),
          ],
        ),
      ),
    );
  }
}