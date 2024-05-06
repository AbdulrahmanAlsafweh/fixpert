import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchTextController = TextEditingController();
  String baseUrl = "https://switch.unotelecom.com/fixpert/getWorker.php";
  List<dynamic> services = [];
  List<dynamic> worker = [];
  bool filterAvailable = false;
  bool isLoading = false; // Flag to indicate data fetching

  Future<void> searchWorker(String workerName) async {
    setState(() {
      isLoading = true; // Set loading flag while fetching data
    });
    String url = baseUrl;
    if (workerName.isNotEmpty) {
      url = "$baseUrl?workerName=$workerName";
    }
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final workerData = jsonDecode(response.body);
        setState(() {
          worker.clear();
          worker = workerData;
          isLoading = false; // Clear loading flag after successful fetch
        });
      } else {
        // Handle HTTP error (e.g., display error message)
        print('Error fetching worker data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors (e.g., network issues)
      print('Error searching workers: $error');
    }
  }

  Future<void> getServices() async {
    String url = 'https://switch.unotelecom.com/fixpert/getServicesFilter.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final servicesData = jsonDecode(response.body);
        setState(() {
          services.clear();
          services = servicesData;
        });
      } else {
        // Handle HTTP error
        print('Error fetching services data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error fetching services: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    searchWorker("");
    getServices();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: searchTextController,
              onChanged: (value) {
                searchWorker(searchTextController.text);
              },
              decoration: InputDecoration(
                labelText: 'Search by worker name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchWorker(searchTextController.text);
                  },
                ),
              ),
            ),
          ),
          // Expanded(child: Row(
          //   children:<Widget> [
          //     ListView.builder(itemBuilder: (context, index) {
          //       return(Text('g'));
          //     },)
          //
          //   ],
          // )),
          // Expanded(child: ListView.builder(
          //   itemCount: worker.length,
          //   itemBuilder: (context, index) {
          //     return Text("services[index]['name']");
          //   },)),
          SizedBox(
            height: 10,
          ),
          Container(
          height: 100,
            child:
            ListView.builder(

              padding: EdgeInsets.only(left: 10 ,right: 10),
              scrollDirection: Axis.horizontal,
              itemCount: services.length,

              itemBuilder:(context, index) {

              return(Text(services[index]['name'].toString())
              );
            },),
          ),

          Switch(
            // thumb color (round icon)
            activeColor: Colors.amber,
            activeTrackColor: Colors.cyan,
            inactiveThumbColor: Colors.blueGrey.shade600,
            inactiveTrackColor: Colors.grey.shade400,
            splashRadius: 50.0,
            // boolean variable value
            value: filterAvailable,
            // changes the state of the switch

            onChanged: (value) => setState(() => filterAvailable = value),
          ),
          SizedBox(
            height: 10,
          ),

          Expanded(
              child: ListView.builder(
            itemCount: worker.length,
            itemBuilder: (context, index) {
              return (GestureDetector(
                child: Padding(
                    padding: EdgeInsets.only(left: 5, bottom: 2),
                    child: Container(
                      height: screenHeight / 11,
                      child: Row(
                        children: [
                          // This continer is to indicate if the worker is avialable or not
                          Container(
                            width: 5,
                            color: (worker[index]['availability']
                                        .toString()
                                        .trim() ==
                                    "1")
                                ? Colors.green
                                : Colors.red,
                          ),
                          Image.network(
                              width: 52,
                              height: 52,
                              "https://switch.unotelecom.com/fixpert/assets/${worker[index]['profile_pic'].toString()}"),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                worker[index]['username'],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(worker[index]['name'].toString())
                            ],
                          )
                        ],
                      ),
                    )),
              ));
            },
          ))
        ],
      ),
    );
  }
}
