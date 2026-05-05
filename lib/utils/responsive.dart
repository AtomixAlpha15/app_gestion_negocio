import 'dart:io';
import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  if (!Platform.isAndroid && !Platform.isIOS) return false;
  return MediaQuery.sizeOf(context).width < 650.0;
}
