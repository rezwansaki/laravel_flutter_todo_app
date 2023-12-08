// This file contains all kinds of Global variables.

import 'package:flutter_dotenv/flutter_dotenv.dart';

// get API_PROJECT_HOST from env file (.env and .env.dev)
// ignore: non_constant_identifier_names
String API_PROJECT_HOST_FROM_ENV =
    dotenv.env['API_PROJECT_HOST'] ?? 'API_PROJECT_HOST not found';

// base Api url
// ignore: non_constant_identifier_names
String API_BASE_URL = '$API_PROJECT_HOST_FROM_ENV/api';

// headers without authentication
const Map<String, String> headers = {
  "Content-Type": "application/json",
  'Accept': 'application/json'
};
