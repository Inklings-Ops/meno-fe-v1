import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../features/network/presentation/network_toast.dart';

extension MToastExtensions on BuildContext {
  Widget _buildPosition(context, child) {
    return Positioned(
      top: 24.0,
      left: 16.0,
      right: 16.0,
      child: child,
    );
  }

  void showNetworkError(FToast toast) {
    toast.showToast(
      child: const NetworkToast(type: ToastType.error),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(days: 365),
      positionedToastBuilder: _buildPosition,
    );
  }

  void showNetworkSuccess(FToast toast) {
    toast.showToast(
      child: const NetworkToast(type: ToastType.success),
      gravity: ToastGravity.TOP,
      positionedToastBuilder: _buildPosition,
    );
  }

  void get closeAllToasts => Fluttertoast.cancel();
}
