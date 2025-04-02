class ApiUrl {
  static const baseURL = 'https://my-app-image-174827312206.us-central1.run.app/';

  // Authentication
  static const signup = 'auth/signup';
  static const login = 'auth/login';

  // User Profile
  static const editProfilePicture = 'users/edit-profile-picture';
  static const editProfile = 'users/edit-profile';
  static const getUserProfile = 'users/get-profile';
  static const deleteAccount = 'users/delete-account';

  // Sessions & Deliveries
  static const createSession = 'sessions/create';
  static const getSessions = 'sessions/get';
  static const createDelivery = 'deliveries/create';
  static const addDeliveryFeedback = 'deliveries/feedback/add';

  // Performance Analytics
  static const getPerformance = 'performance/get';

  // Video Upload & Processing
  static const uploadVideo = 'videos/upload';
  static const processVideo = 'https://my-vp-app-174827312206.us-central1.run.app/process-video';

  // Shot Prediction (external service)
  static const predictShot = 'https://shot-recommendation-api-857244658015.us-central1.run.app/predict';

  // Coaches
  static const getPlayers = 'coaches/get-players';
  static const getOpenPlayers = 'coaches/get-open-players';

  // Miscellaneous
  static const createTopic = 'create-a-topic';
}
