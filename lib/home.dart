import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quiztime.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'signin.dart';
import 'stats.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();
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
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> const Stats())
                  );
                }, icon: const Icon(Icons.insert_chart,size: 50,color: Colors.black)),
                ElevatedButton(
                  onPressed: () {

                    SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black ,shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),)),
                  child: Text('Quit',style: TextStyle(fontSize: 25,color: Colors.blueGrey[800]),),

                ),
                IconButton(onPressed: () {
                  _encryptedData.remove('myKey').then((success) {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SignIn())
                    );
                  });
                }, icon: const Icon(Icons.logout,size: 40,color: Colors.black,)),
              ],
            ),

          ],
        ),
      ),
    );
  }
}