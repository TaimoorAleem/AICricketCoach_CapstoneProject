import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/delivery.dart';
import 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit() : super(DeliveryInitial());

  void loadDeliveryDetails(Delivery delivery) {
    // Simulate loading of delivery data
    emit(DeliveryLoading());

    try {
      // Add logic if needed to process or validate the delivery
      emit(DeliveryLoaded(delivery: delivery));
    } catch (e) {
      emit(DeliveryError(errorMessage: "Failed to load delivery details."));
    }
  }
}
