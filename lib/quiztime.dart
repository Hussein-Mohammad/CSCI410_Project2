import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

const String _baseURL = 'https://husseinmohamad.000webhostapp.com';
final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

class quiztime extends StatefulWidget {
  final String calculationType;
  quiztime({Key? key, required this.calculationType}) : super(key: key);

  @override
  State<quiztime> createState() => _quiztimeState();
}

class _quiztimeState extends State<quiztime> {
  Random rand = Random();
  double first=0;
  double second=0;
  double rightTotal=0;
  int life=3;
  String hearts='❤️❤️❤️';
  int timing=5;
  String clock='🕛';
  int counter=0;
  late Timer timer;
  List<double> answers=[];
  String quiztitle='';
  int decimal=0;
  int timeTook = 0;

  @override
  void initState(){
    super.initState();
    timeout();
    generator();

  }
  void timeout() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      setState(() {
        timeTook++;
        if (timing > 0) {
          timing--;
          switch (timing){
            case 4:
              clock='🕒';
              break;

            case 3:
              clock='🕧';
              break;
            case 2:
              clock='🕘';
              break;
            case 1:
              clock='🕚';
              break;
            case 0:
              clock='⏰';
              break;
          }
        } else {
          life--;
          generator();
        }
      });
    });
  }
  void generator(){

    resetTimer();
    timer.cancel();
    if(life==0){
      dataInsertion(saveRecords, quiztitle, '0', timeTook.toString());
      timer.cancel();
      hearts = '💔💔💔';
      showRestartDialog();
      return;
    }
    if(counter==10){
      dataInsertion(saveRecords, quiztitle, '1', timeTook.toString());
      timer.cancel();
      showWinDialog();
      return;
    }
    first=rand.nextInt(9)+1.0;//question
    second=rand.nextInt(9)+1.0;//question

    switch(widget.calculationType){

      case '+':
        quiztitle='Addition';
        rightTotal=first+second;
        break;
      case '-':
        quiztitle='Subtraction';
        rightTotal=first-second;
        break;
      case 'x':
        quiztitle='Multiplication';
        rightTotal=first*second;
        break;
      case '/':
        quiztitle='Division';
        rightTotal=first/second;
        decimal=1;
        break;
    }
    switch (life) {
      case 2:
        hearts = '❤️❤️💔';
        break;

      case 1:
        hearts = '❤️💔💔';
        break;

    }
    answers=[rightTotal];
    for(int i=0;i<=2;i++){
      double wrongTotal=0;
      if(widget.calculationType=='/'){
        wrongTotal=rand.nextDouble()*10.0; //question
      }else{
        wrongTotal=rand.nextInt(9)+1.0;
      }
      if(!answers.contains(wrongTotal)){
        answers.add(wrongTotal);
      }else{
        i--;
      }
    }
    answers.shuffle();
    timeout();
  }
void resetTimer(){
    setState(() {
      timing=5;
      clock='🕛';
    });
}
  void saveRecords(String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
  void showRestartDialog(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Game Over'),
        content: const Text('You lost all your lives. Do you want to play again?'),
        actions: [
          ElevatedButton(onPressed: (){
            setState(() {
              timeTook = 0;
              hearts='❤️❤️❤️';
              life = 3;
              counter = 0;
              generator();
            });
            Navigator.of(context).pop();
          },style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
           child: const Text('Restart')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Go Home'),

          ),
        ],
      );
    });
  }
  void showWinDialog(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Congrats'),
        content: const Text('You won!'),
        actions: [
          ElevatedButton(onPressed: (){
            setState(() {
              timeTook = 0;
              life = 3;
              hearts='❤️❤️❤️';
              counter = 0;
              generator();
            });
            Navigator.of(context).pop();
          },style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Play Again')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Go Home'),
          ),
        ],
      );
    });
  }
  void checkResult(double clicked){
    if(clicked==rightTotal){
      setState(() {
        counter++;
      });}
    else{
      setState(() {
        life--;
      });
    }

    generator();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('MyQuiz - $quiztitle',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 24,),
            const Row(
                children: [
                  SizedBox(width: 85,),
                  Text("LIVES", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(width: 65,),
                  Text('TIME', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                ]
            ),
            Row(
                children: [const SizedBox(width: 65),
                  Text('$hearts', style: const TextStyle(fontSize: 30)),
                  const SizedBox(width: 70),
                  Text('${clock}', style: const TextStyle(fontSize: 30),),
                ]
            ),
            const SizedBox(height:30),
            Container(
                width: 340,
                height: 150,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                      radius: 1.5,
                      colors: [

                        Colors.cyan,
                        Colors.teal,
                        Colors.black,


                      ]
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(child: Text('${first.toInt()} ${widget.calculationType} ${second.toInt()}', style: const TextStyle(fontSize: 65,color: Colors.white),),)
            ),
            const SizedBox(height: 60,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 100,width: 120,
                    child: ElevatedButton(onPressed:(){
                      timer.cancel();
                      checkResult(answers[0]);
                    },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),),
                      child: Text(answers[0].toStringAsFixed(decimal), style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w300,color: Colors.white),),
                    )
                ),
                SizedBox(height: 100,width: 120,
                    child: ElevatedButton(onPressed:(){
                      timer.cancel();
                      checkResult(answers[1]);
                    },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),),
                      child: Text(answers[1].toStringAsFixed(decimal), style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w300,color: Colors.white)),
                    )
                ),
              ],
            ),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 100,width: 120,
                    child: ElevatedButton(onPressed:(){
                      timer.cancel();
                      checkResult(answers[2]);
                    },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),),
                      child: Text(answers[2].toStringAsFixed(decimal), style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w300,color: Colors.white)),
                    )
                ),
                SizedBox(height: 100,width: 120,
                    child: ElevatedButton(onPressed:(){
                      timer.cancel();
                      checkResult(answers[3]);
                    },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),),
                      child: Text(answers[3].toStringAsFixed(decimal), style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w300,color: Colors.white)),
                    )
                ),
              ],
            ),
            const SizedBox(height: 60,),
            const Text('Score',style: TextStyle(fontSize: 48,fontWeight: FontWeight.bold),),
            Text('$counter',style: const TextStyle(fontSize: 38,fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
void dataInsertion(Function(String text) saveRecords, String operation, String result,String tt) async{
  try{
    String userID = await _encryptedData.getString('myKey');
    final response = await http.post(
        Uri.parse('$_baseURL/datainsertion.php'),
        headers: <String, String>{
          'Content-Type' : 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'uid': userID,
          'operation': operation,
          'result': result,
          'timetook': tt
        }))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      saveRecords(response.body);
      print(response.body);
    }
  }catch(e){
    saveRecords('connection error');
    print(e);
  }
}
