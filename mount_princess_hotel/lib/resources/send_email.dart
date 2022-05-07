import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mount_princess_hotel/utils/utils.dart';

// Email to the admin ////
Future sendEmail({
  required BuildContext context,
  required String name,
  required String phoneNumber,
  required String email,
  required String subject,
  required String message,
}) async {
  final serviceId = 'service_zckc95c';
  final templateId = 'template_xmxpd8n';
  final userId = 'o5HYmxK4h31SqZHS7';

  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  final response = await http.post(
    url,
    headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': name,
        'user_phoneNumber': phoneNumber,
        'to_email': "ishapanta0124@gmail.com",
        'to_name': "Hotel Application",
        'user_email': email,
        'user_subject': subject,
        'user_message': message,
      },
    }),
  );

  print(response.body);
  if (response.body.toString() == "OK") {
    showSnackBar(context, "Email sent successfully.");
  }
}
