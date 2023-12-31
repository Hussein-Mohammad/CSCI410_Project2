import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

const String _baseURL = 'https://husseinmohamad.000webhostapp.com';
final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();
List<String> filters = [
  'All',
  'Addition',
  'Subtraction',
  'Multiplication',
  'Division'
];

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  String filter = filters.first;
  double wins = 0;
  double loses = 0;
  bool _loadPage = false;
  double avgtime=0;
  String iqresult='';
  bool showFilter=false;
  Color status=Colors.black;

  void saveaverage(double iq){
    setState(() {
      avgtime=iq;
      calculateIqLevel();
    });
  }
  @override
  void initState() {
    pieChartData(displayStatus, saveData, filter);
    iqlevel(displayStatus, saveaverage);
    super.initState();

  }

  void saveData(double w, double l) {
    setState(() {
      wins = w;
      loses = l;
      _loadPage = true;
    });
  }

  void displayStatus(String text) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
  void reseting(String text) {
    pieChartData(displayStatus, saveData, filter);
    iqlevel(displayStatus, saveaverage);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  }
  void calculateIqLevel(){
    setState(() {
      if(loses>wins){
        iqresult='LOW';
        status=Colors.red;
      }
      else if(loses==wins){
        iqresult='MODERATE';
        status=Colors.yellow;
      }

      if(avgtime>20){
        iqresult='LOW';
        status=Colors.red;
      }
      else if(avgtime<20 && avgtime>15){
        iqresult='MODERATE';
        status=Colors.yellow;
      }
      else if(avgtime<15 && avgtime>0){
        iqresult='HIGH';
        status=Colors.green;
      }else{
        iqresult='To Be Calculated...';
      }



    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Statiology',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,

            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            IconButton(onPressed: (){
              setState(() {
                if(showFilter){
                  showFilter=false;
                }else{
                  showFilter=true;
                }
              });
            }, icon: const Icon(Icons.filter_alt),color:Colors.white,)
          ],
        ),
        body: !_loadPage
            ? const Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Column(children: [
                    SizedBox(height: 40,),
                    Visibility(visible: showFilter,
                      child:
                    DropdownMenu(
                      dropdownMenuEntries:
                          filters.map<DropdownMenuEntry<String>>((String text) {
                        return DropdownMenuEntry(value: text, label: text);
                      }).toList(),
                      initialSelection: filters.first,
                      onSelected: (String? text) {
                        setState(() {
                          filter = text as String;

                          pieChartData(displayStatus, saveData, text);
                        });
                      },
                    ),),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'WIN/LOSS:',
                      style: TextStyle(fontSize: 24),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            Text(
                              'Wins: ${wins.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.green),
                            ),
                            Text(
                              'Loses: ${loses.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.red),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 220,
                          height: 300,
                          child: PieChart(
                            PieChartData(
                                centerSpaceRadius: 1,
                                sectionsSpace: 0,
                                sections: [
                                  PieChartSectionData(
                                    showTitle: false,
                                    value: wins,
                                    color: Colors.green,
                                    radius: 100,
                                  ),
                                  PieChartSectionData(
                                    showTitle: false,
                                    value: loses,
                                    color: Colors.red,
                                    radius: 100,
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('IQ level: ',style: TextStyle(fontSize: 25),),
                        Text(iqresult,style: TextStyle(color: status, fontSize: 25)),
                      ],
                    ),
                    ElevatedButton(onPressed: (){
                      ResetData(displayStatus);

                    }, child: Text('Reset Data')),

                  ]),
                ),
              ));
  }
}

void pieChartData(Function(String message) displayStatus,
    Function(double wins, double loses) saveData, String operation) async {
  try {
    String userID = await _encryptedData.getString('myKey');
    final response = await http
        .post(Uri.parse('$_baseURL/piechartData.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: convert.jsonEncode(
                <String, String>{'uid': userID, 'operation': operation}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      var row = jsonResponse[0];
      saveData(double.parse(row['wins']), double.parse(row['loses']));
    }
  } catch (e) {
    displayStatus('Error retrieving data');
  }
}
void ResetData(Function(String msg) reseting) async {
  try {
    String userID = await _encryptedData.getString('myKey');
    final response = await http
        .post(Uri.parse('$_baseURL/datadeletion.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: convert.jsonEncode(
            <String, String>{'uid': userID}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      reseting(response.body);


    }
  } catch (e) {
    reseting('Error reseting data');
  }
}
void iqlevel(Function(String msg) displayStatus,Function(double iq) saveaverage) async {
  try {
    String userID = await _encryptedData.getString('myKey');
    final response = await http
        .post(Uri.parse('$_baseURL/iqlevel.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: convert.jsonEncode(
            <String, String>{'uid': userID}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      
      final jsonResponse = convert.jsonDecode(response.body);
      var row = jsonResponse[0];
      saveaverage(double.parse(row['average_time']));
    }
  } catch (e) {
    displayStatus('Error reseting data');
  }
}

