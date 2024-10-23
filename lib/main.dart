import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Cricket Coach'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Notification logic
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Back navigation logic
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Performance History Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Performance History',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Details
                  },
                  child: Text('Details'),
                ),
              ],
            ),
            // Placeholder for the graph
            Container(
              height: 150,
              color: Colors.grey[300], // Placeholder for chart
              child: Center(child: Text('Graph goes here')),
            ),
            SizedBox(height: 20),

            // Sessions History Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sessions History',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Session History
                  },
                  child: Text('View All'),
                ),
              ],
            ),
            // Placeholder for session list (to be added later)
            Expanded(
              child: ListView(
                children: List.generate(3, (index) {
                  return Card(
                    child: ListTile(
                      title: Text('Session ${index + 1}'),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
        ],
        currentIndex: 0, // Home is active
        onTap: (int index) {
          // Handle navigation between pages
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: HomePage()));
}