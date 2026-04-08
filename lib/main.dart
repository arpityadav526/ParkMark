import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FirstPage(),  // Start with First Page
    );
  }
}

// ========== FIRST PAGE ==========
class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Page 1',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 30),
            
            // This button navigates to Second Page
            ElevatedButton(
              onPressed: () {
                // NAVIGATION CODE HERE
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondPage()),
                );
              },
              child: Text('Go to Second Page'),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== SECOND PAGE ==========
class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
        backgroundColor: Colors.green,
        // Back button appears automatically
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You made it to Page 2!',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            SizedBox(height: 30),
            
            // Button to go back (optional - AppBar already has back button)
            ElevatedButton(
              onPressed: () {
                // GO BACK TO PREVIOUS PAGE
                Navigator.pop(context);
              },
              child: Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}