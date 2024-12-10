import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/delivery_cubit.dart';
import '../cubit/delivery_state.dart';

class DeliveryDetailsPage extends StatelessWidget {
  final String deliveryId;

  const DeliveryDetailsPage({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
      ),
      body: BlocProvider(
        create: (_) => DeliveryCubit()..fetchDeliveryDetails(deliveryId),
        child: BlocBuilder<DeliveryCubit, DeliveryState>(
          builder: (context, state) {
            if (state is DeliveryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DeliveryError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is DeliveryLoaded) {
              final delivery = state.delivery;
              final shotImage =
                  delivery.shotImage ?? "assets/images/default_shot.png";
              final shotInstruction =
                  delivery.shotInstruction ?? "No specific instructions.";

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Details Section
                    const Text(
                      'Details:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text('Speed: ${delivery.speed} km/h'),
                    Text('Accuracy: ${delivery.accuracy}%'),
                    Text(
                        'Right-Handed Batsman: ${delivery.rightHandedBatsman ? "Yes" : "No"}'),
                    Text('Bounce Height: ${delivery.bounceHeight}'),
                    Text('Ball Length: ${delivery.ballLength}'),
                    Text('Horizontal Position: ${delivery.horizontalPosition}'),
                    const SizedBox(height: 16.0),

                    // Ideal Shot Section
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Ideal Shot: ${delivery.idealShot}',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Image.asset(
                            shotImage,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Shot Explanation Section
                    const Text(
                      'How to execute:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      shotInstruction,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No delivery details available.'));
          },
        ),
      ),
    );
  }
}