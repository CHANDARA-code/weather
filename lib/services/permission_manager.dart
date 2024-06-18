import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionHandler {
  Future<bool> isPermissionGranted(DeviceAppPermission permission);
  Future<bool> requestPermission(DeviceAppPermission permission);
  Future<bool> isPermissionPermanentlyDenied(DeviceAppPermission permission);
  Future<void> openAppSettings();
  Future<Map<DeviceAppPermission, PermissionStatus>> requestPermissions(
      List<DeviceAppPermission> permissions);
  Future<Map<DeviceAppPermission, bool>> arePermissionsGranted(
      List<DeviceAppPermission> permissions);
}

enum DeviceAppPermission { location, notification }

class PermissionManager implements PermissionHandler {
  final PermissionMapper _permissionMapper;

  PermissionManager(this._permissionMapper);

  @override
  Future<bool> isPermissionGranted(DeviceAppPermission permission) async {
    return await _permissionMapper.map(permission).isGranted;
  }

  @override
  Future<bool> requestPermission(DeviceAppPermission permission) async {
    final status = await _permissionMapper.map(permission).request();
    return status.isGranted;
  }

  @override
  Future<bool> isPermissionPermanentlyDenied(
      DeviceAppPermission permission) async {
    return await _permissionMapper.map(permission).isPermanentlyDenied;
  }

  @override
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  @override
  Future<Map<DeviceAppPermission, PermissionStatus>> requestPermissions(
      List<DeviceAppPermission> permissions) async {
    final Map<DeviceAppPermission, PermissionStatus> results = {};
    for (DeviceAppPermission permission in permissions) {
      final status = await _permissionMapper.map(permission).request();
      results[permission] = status;
    }
    return results;
  }

  @override
  Future<Map<DeviceAppPermission, bool>> arePermissionsGranted(
      List<DeviceAppPermission> permissions) async {
    final Map<DeviceAppPermission, bool> results = {};
    for (DeviceAppPermission permission in permissions) {
      results[permission] = await isPermissionGranted(permission);
    }
    return results;
  }
}

// Separate class for mapping DeviceAppPermission to Permission
class PermissionMapper {
  Permission map(DeviceAppPermission permission) {
    switch (permission) {
      case DeviceAppPermission.location:
        return Permission.location;
      case DeviceAppPermission.notification:
        return Permission.notification;
      default:
        throw UnimplementedError(
            'Permission ${permission.toString()} is not implemented.');
    }
  }
}

final permissionManagerProvider = Provider<PermissionManager>((ref) {
  return PermissionManager(PermissionMapper());
});
