import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  bool _connected = false;

  void connectAndSubscribe() {
    if (_connected) return;
    socket = IO.io(
      'http://192.168.29.2:8003',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      _connected = true;
      print('Connected to socket');
      // socket.emit('subscribeToPincode', pincode);
    });

    // socket.on('driverLocationUpdate', (data) {
    //   print('Driver location in pincode $pincode: $data');

    //   // Update map markers or UI here
    // });

    socket.onDisconnect((_) {
      _connected = false;
      print('Socket disconnected');
    });
  }

  void sendUsersLocation({
    required String userID,
    required String pincode,
    required double lat,
    required double lng,
  }) {
    socket.emit('passenger:nearbyDrivers', {
      'userID': userID,
      'pincode': pincode,
      'lat': lat,
      'lng': lng,
    });
  }

  void validateTripDetails({required String userID, required int bookingID}) {
    socket.emit('live:trip', {'bookingId': bookingID, 'userId': userID});
    
  }

  // void _updateTripDetails({required String userID, required int bookingID}) {
  //   socket.on(
  //     'trip:update:$bookingID',
  //     (data) => {print('Nearby driver location:$data')},
  //   );
  // }

  Stream<dynamic> getLiveTripUpdates({required int bookingID}) {
    final controller = StreamController<dynamic>();

    socket.on('trip:update:$bookingID', (dynamic data) {
      print("Trip Updates : ${data}");
      controller.add(data);
    });

    return controller.stream;
  }


  Stream<dynamic> getNearByDriversStream() {
    final controller = StreamController<dynamic>();

    socket.on('drivers:nearby', (dynamic data) {
      print("current Nearby Drivers : ${data}");
      controller.add(data);
    });

    return controller.stream;
  }

  void dispose() {
    if (_connected) {
      socket.disconnect();
      _connected = false;
    }
  }
}
