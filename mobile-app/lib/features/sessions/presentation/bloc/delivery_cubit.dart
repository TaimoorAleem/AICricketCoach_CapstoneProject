import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_delivery_details_usecase.dart';
import 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  final GetDeliveryDetailsUseCase getDeliveryDetailsUseCase;

  DeliveryCubit({required this.getDeliveryDetailsUseCase})
      : super(DeliveryInitial());

  void fetchDeliveryDetails(String deliveryId) async {
    emit(DeliveryLoading());
    final result = await getDeliveryDetailsUseCase.call(deliveryId);
    result.fold(
          (error) => emit(DeliveryError(message: error)),
          (delivery) => emit(DeliveryLoaded(delivery: delivery)),
    );
  }
}
