import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/service_locator.dart';
import '../../domain/entities/delivery.dart';
import '../../../../resources/dio_client.dart';

class DeliveryDetailsPage extends StatefulWidget {
  final Delivery delivery;
  final String sessionId;
  final String playerId;

  const DeliveryDetailsPage({
    Key? key,
    required this.delivery,
    required this.sessionId,
    required this.playerId,
  }) : super(key: key);

  @override
  _DeliveryDetailsPageState createState() => _DeliveryDetailsPageState();
}

class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
  final TextEditingController _feedbackController = TextEditingController();
  double _battingRating = 5.0;
  bool isSubmitting = false;
  bool isCoach = false;

  late Delivery _updatedDelivery;

  @override
  void initState() {
    super.initState();
    _updatedDelivery = widget.delivery;
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? role = prefs.getString('role');
    setState(() {
      isCoach = role == 'coach';
    });
  }

  Future<void> _submitFeedback() async {
    setState(() => isSubmitting = true);

    final DioClient dioClient = sl<DioClient>();
    final String url = "add-feedback";

    final Map<String, dynamic> requestBody = {
      "playerId": widget.playerId,
      "sessionId": widget.sessionId,
      "deliveryId": widget.delivery.deliveryId,
      "battingRating": _battingRating,
      "feedback": _feedbackController.text,
    };

    try {
      final response = await dioClient.post(url, data: requestBody);
      if (response.statusCode == 200) {
        setState(() {
          _updatedDelivery = Delivery(
            deliveryId: _updatedDelivery.deliveryId,
            speed: _updatedDelivery.speed,
            bounceHeight: _updatedDelivery.bounceHeight,
            ballLength: _updatedDelivery.ballLength,
            horizontalPosition: _updatedDelivery.horizontalPosition,
            rightHandedBatsman: _updatedDelivery.rightHandedBatsman,
            accuracy: _updatedDelivery.accuracy,
            executionRating: _updatedDelivery.executionRating,
            idealShot: _updatedDelivery.idealShot,
            videoUrl: _updatedDelivery.videoUrl,
            feedback: _feedbackController.text,
            battingRating: _battingRating,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Feedback added successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit feedback: $e")),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Details:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text('Speed: ${_updatedDelivery.speed} km/h'),
            Text('Ball Length: ${_updatedDelivery.ballLength}'),
            Text('Horizontal Position: ${_updatedDelivery.horizontalPosition}'),
            Text('Ideal Shot: ${_updatedDelivery.idealShot}'),
            if (_updatedDelivery.feedback != null && _updatedDelivery.feedback!.isNotEmpty)
              Text('Feedback: ${_updatedDelivery.feedback!}'),
            if (_updatedDelivery.battingRating != null)
              Text('Batting Rating: ${_updatedDelivery.battingRating!.toStringAsFixed(1)} / 10'),

            const SizedBox(height: 20),

            if (isCoach) _buildFeedbackSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Coach Feedback:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: _feedbackController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter feedback...",
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        const Text("Batting Rating (Out of 10):", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Slider(
          value: _battingRating,
          min: 1,
          max: 10,
          divisions: 9,
          label: _battingRating.toString(),
          onChanged: (value) {
            setState(() {
              _battingRating = value;
            });
          },
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: isSubmitting ? null : _submitFeedback,
            child: isSubmitting ? const CircularProgressIndicator() : const Text("Submit Feedback"),
          ),
        ),
      ],
    );
  }
}
