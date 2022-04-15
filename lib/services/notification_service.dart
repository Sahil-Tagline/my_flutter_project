import 'package:eat_it_ppsu/services/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future showNotification({
    id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notification.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  static Future _notificationDetails() async {
    final bigPicturePath = await Utils.downloadFile(
        'https://media.istockphoto.com/vectors/order-success-icon-vector-id882905872?k=20&m=882905872&s=170667a&w=0&h=oKyeMMsffutor2B0f2ZDvbwUj74KW22IZa52e9V2QEA=',
        'bigPicture');

    final largeIcon = await Utils.downloadFile(
        'https://p.kindpng.com/picc/s/431-4312134_transparent-success-icon-hd-png-download.png',
        'largeIcon');

    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIcon),
    );

    return NotificationDetails(
      android: AndroidNotificationDetails('id', 'channel',
          importance: Importance.max, styleInformation: styleInformation
          //icon: '@mipmap/ic_launcher',
          //largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          ),
      iOS: IOSNotificationDetails(),
    );
  }
}
