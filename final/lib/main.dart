import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pollen Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/splash.json',
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello Indians',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to our app',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
                  );
                },
                child: Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Role'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'What role suits you the best?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FarmerScreen()),
                );
              },
              child: Text('Farmer'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PharmacistScreen()),
                );
              },
              child: Text('Pharmacist'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PollenDashboardScreen()),
                );
              },
              child: Text('None of the above'),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Screen'),
      ),
      body: Center(
        child: Text('You are a farmer'),
      ),
    );
  }
}

class PharmacistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacist Screen'),
      ),
      body: Center(
        child: Text('You are a pharmacist'),
      ),
    );
  }
}

class PollenDashboardScreen extends StatefulWidget {
  @override
  _PollenDashboardScreenState createState() => _PollenDashboardScreenState();
}

class _PollenDashboardScreenState extends State<PollenDashboardScreen> {
  Map<String, dynamic> pollenData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPollenData();
  }

  Future<void> fetchPollenData() async {
    final response = await http.get(
      Uri.parse('https://api.ambeedata.com/latest/pollen/by-lat-lng?lat=23.237560&lng=72.647781'),
      headers: {
        'x-api-key': 'e0c0f6c784b732e42cd47ff1faeceb6c3193ba2da273f4d5772997ff5cc6d30c', // Replace with your actual API key
        'Content-type': 'application/json'
      },
    );  

    if (response.statusCode == 200) {
      setState(() {
        pollenData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load pollen data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pollen Dashboard'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pollenData.isEmpty
          ? Center(child: Text('Failed to load data'))
          : ListView.builder(
        itemCount: pollenData['data'].length,
        itemBuilder: (context, index) {
          var pollen = pollenData['data'][index];
          return ListTile(
            title: Text('${pollen['species']} - ${pollen['count']}'),
            subtitle: Text('Risk: ${pollen['risk']}'),
          );
        },
      ),
    );
  }
}
