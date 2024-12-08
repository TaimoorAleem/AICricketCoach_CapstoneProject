import 'package:flutter/material.dart';
import '../widgets/donut_chart.dart';

class AccuracyPage extends StatelessWidget {
  const AccuracyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Arbitrary accuracy percentage and shot details
    const double accuracy = 87.5;
    const String shotName = "Pull Shot";
    const String shotImageUrl = "https://stock.adobe.com/ca/images/cricket-batsman-with-red-uniform-in-a-batting-stance-ready-to-swing-his-bat-isolated-background/916705966"; // Replace with your image URL

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accuracy Results'),
      ),
      body: SingleChildScrollView(  // Added to enable scrolling when content exceeds the screen size
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Results:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'The Most Ideal Shot based off ball metrics and positioning:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              shotName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                shotImageUrl,
                height: 150,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Text("Image not available"),
              ),
            ),
            const SizedBox(height: 24),
            DonutChart(accuracy: accuracy),  // Donut chart now appears under the details
            const SizedBox(height: 8),
            const Text(
              'Accuracy%',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
