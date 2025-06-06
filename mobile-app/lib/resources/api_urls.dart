class ApiUrl {
  static const baseURL = 'https://aicc-gateway2-28bbo1fy.uc.gateway.dev/';

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
  static const addDelivery = 'deliveries/create';
  static const addFeedback = 'deliveries/feedback/add';

  // Performance Analytics
  static const getPerformance = 'performance/get';

  // Video Upload & Processing
  static const uploadVideo = 'videos/upload';
  static const processVideo = 'process-video';

  // Shot Prediction (external service)
  static const predictShot = 'https://shot-recommendation-api-857244658015.us-central1.run.app/predict';

  // Coaches
  static const getPlayers = 'coaches/get-players';
  static const getOpenPlayers = 'coaches/get-open-players';

  // Miscellaneous
  static const createTopic = 'create-a-topic';
}