import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smarted/widgets/snackbar.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  // Handle success status codes
  // if(jsonDecode(response.))
  if (response.statusCode < 300) {
    onSuccess();
  } else {
    // Default error message
    String errorMessage = 'Something went wrong';

    try {
      // Try to parse the response body
      final responseBody = jsonDecode(response.body);
      print(responseBody);
      if (response.statusCode < 500) {
        // Handle client-side errors (4xx)
        errorMessage = responseBody['message'] ?? 'Client-side error';
      } else {
        // Handle server-side errors (5xx)
        errorMessage = responseBody['error'] ?? 'Server-side error';
      }
    } catch (e) {
      // Handle JSON parsing errors
      errorMessage = 'Error parsing response: ${e.toString()}';
    }

    showSnackBar(context, errorMessage);
  }
}
