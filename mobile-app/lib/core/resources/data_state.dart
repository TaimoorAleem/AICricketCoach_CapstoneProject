/**
 This file defines a generic structure to represent the state of a data operation,
 either a success or a failure. It is used to standardize how data responses
 (e.g., from API calls or database queries) are handled in the application.
 By encapsulating both successful data and error details, this structure
 provides a clean way to manage and propagate the result of data operations.
 */

// Importing the Dio package, a popular HTTP client for making API requests in Flutter.
import 'package:dio/dio.dart';

// Abstract class to represent the state of data, either success or failure.
// This class is generic, allowing flexibility to handle any type of data (T).
abstract class DataState<T> {
  final T? data; // Holds the successful data response if available.
  final DioException? error; // Holds the error details if the request fails.

  // Constructor to initialize the data and error properties.
  // Both properties are optional since only one will be set at a time.
  const DataState({this.data, this.error});
}

// Class representing a successful data state.
// Extends the DataState class and provides a specific implementation for success.
class DataSuccess<T> extends DataState<T> {
  // Constructor that requires the successful data and passes it to the parent class.
  const DataSuccess(T data) : super(data: data);
}

// Class representing a failed data state.
// Extends the DataState class and provides a specific implementation for failures.
class DataFailed<T> extends DataState<T> {
  // Constructor that requires the error object and passes it to the parent class.
  const DataFailed(DioException error) : super(error: error);
}
