import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> checkMultiplePermissions(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> status = await permissions.request();
    bool allGranted = true;
    status.forEach((permission, permissionStatus) {
      if (permissionStatus != PermissionStatus.granted) {
        allGranted = false;
      }
    });
    return allGranted;
  }
}