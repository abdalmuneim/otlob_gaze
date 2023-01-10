import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/navigator_utils.dart';
import 'package:otlob_gas/common/constants/strings.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/checkout/domain/entities/order.dart';
import 'package:otlob_gas/features/checkout/domain/entities/real_time_order.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/assign_order_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/cancel_order_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/create_order_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/delivered_check_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/delivered_un_check_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/disconnect_checkout_pusher_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/init_checkout_pusher_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/listen_to_checkout_use_case.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/order_delivered_use_case.dart';
import 'package:otlob_gas/widget/custom_text.dart';

class CreateOrderProvider extends ChangeNotifier {
  final CreateOrderUseCase _createOrderActivityUseCase;
  final InitCheckoutPusherUseCase _initPusherUseCase;
  final DisconnectCheckoutPusherUseCase _disconnectPusherUseCase;
  final ListenToCheckoutUseCase _listenUseCase;
  final AssignOrderUseCase _assignOrderUseCase;
  final DeliveredCheckedUseCase _deliveredCheckedUseCase;
  final DeliveredUnCheckedUseCase _deliveredUnCheckedUseCase;
  final OrderDeliveredUseCase _orderDeliveredUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;
  BuildContext get _context => NavigationService.context;
  CreateOrderProvider(
    this._createOrderActivityUseCase,
    this._initPusherUseCase,
    this._disconnectPusherUseCase,
    this._listenUseCase,
    this._assignOrderUseCase,
    this._deliveredCheckedUseCase,
    this._orderDeliveredUseCase,
    this._cancelOrderUseCase,
    this._deliveredUnCheckedUseCase,
  );

  /// wallet balance and it's coming from auth provider by Dependency Injection of provider
  double? wallet;

  /// specify if the payment method will be either cash-on-delivery or wallet
  bool get isCash => order!.paymentMethod == 0;

  /// formatter to format order quantity
  final NumberFormat _formatter = NumberFormat("00");

  /// order quantity in 2 format number
  String get count => _formatter.format(order!.quantity).toString();

  /// order quantity in int type
  int get _countInt => order!.quantity ?? 1;

  double get deliveryCost {
    return (order!.distancePrice! + ((_countInt - 1) * order!.unitPrice!));
  }

  bool isLoading = true;

  /// current Order
  OrderEntity? order;

  /// car marker direction on map
  double _heading = 0.0;

  /// driver icon on map
  Uint8List? _driverIcon;

  /// user icon on map
  Uint8List? _userIcon;

  /// method to change count of cylinders
  void changeCount({required bool increase}) {
    order!.quantity ??= 1;
    if (increase) {
      order!.quantity = order!.quantity! + 1;
    } else {
      if (order!.quantity == 1) {
        return;
      }
      order!.quantity = order!.quantity! - 1;
    }
    notifyListeners();
  }

  /// method to change payment method
  set setCashSwitch(bool cashSwitch) {
    if (wallet! < deliveryCost) {
      return;
    }
    order!.paymentMethod = cashSwitch ? 0 : 1;

    notifyListeners();
  }

  /// compass stream
  late StreamSubscription<CompassEvent> _compassStream;
  UserLocation? location;

  /// markers on the map (driver icon, user icon)
  List<Marker> markers = <Marker>[];

  LatLng get userPositionLatLong =>
      LatLng(double.parse(location!.lat!), double.parse(location!.long!));

  late LatLng _driverPositionLatLen =
      LatLng(double.parse(order!.pickupLat!), double.parse(order!.pickupLong!));

  String? driverNotes;

  /// created controller for displaying Google Maps
  late Completer<GoogleMapController> controller;

  ///   controller for managing moving camera on map
  late GoogleMapController controllerGoogleMap;

//  lines for  destinations
  late Set<Polyline> polyLines = {
    Polyline(
      geodesic: true,
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
      polylineId: const PolylineId("route"),
      points: _polylineCoordinates,
      color: const Color(0xFF7B61FF),
    ),
  };

//   destinations points
  final List<LatLng> _polylineCoordinates = [];

  // init create order page
  Future<void> init({
    required UserLocation? location,
    required int? quantity,
    required String? driverNotes,
  }) async {
    if (isLoading) {
      await _createOrder();
    }
    if (quantity != null) {
      order!.quantity = quantity;
    }
    order!.paymentMethod ??= 0;
    await Future.wait(<Future<dynamic>>[
      _loadMapData(),
      _initPusherUseCase(driverId: order!.driverId!),
    ]);
    _positionCameraBetweenTwoCoords();
    _compassListen();
    _listenToCheckout();
    isLoading = false;
    notifyListeners();
  }

//dispose page
  Future<void> disposePage() async {
    await _disconnectPusherUseCase();
    _polylineCoordinates.clear();
    _compassStream.cancel();
  }

//method that draw icons on map
  _loadMapData() async {
    markers.clear();
    //    driver icon
    _driverIcon ??=
        await Utils.getBytesFromAsset(Assets.carIc, width: 150, height: 75);

    //  user icon
    _userIcon ??=
        await Utils.getBytesFromAsset(Assets.currentIc, width: 80, height: 80);

    // add driver icon to markers
    markers.insert(
        0,
        Marker(
          // given marker id
          markerId: const MarkerId('0'),
          rotation: _heading,

          // given marker icon
          icon: BitmapDescriptor.fromBytes(_driverIcon!),

          // given position
          position: _driverPositionLatLen,

          flat: true,
        ));
    markers.insert(
        1,
        Marker(
          // given marker id
          markerId: MarkerId('${order?.customerId ?? 1}'),
          // given marker icon
          icon: BitmapDescriptor.fromBytes(_userIcon!),
          // given position
          position: userPositionLatLong,
          flat: true,
        ));
    if (_polylineCoordinates.isEmpty) {
      await _getPolyPoints();
    }
    if (controller.isCompleted) {
      controllerGoogleMap
          .animateCamera(CameraUpdate.newLatLng(_driverPositionLatLen));
    }
  }

//get lines between 2 destinations
  Future<void> _getPolyPoints() async {
    _polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      // Your Google Map Key
      Strings.googleMapApiKey,
      PointLatLng(
          _driverPositionLatLen.latitude, _driverPositionLatLen.longitude),
      PointLatLng(userPositionLatLong.latitude, userPositionLatLong.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        _polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
    }
  }

  /// submit order method
  Future<void> submitOrder() async {
    Utils.showLoading();
    final result = await _assignOrderUseCase(
      notes: driverNotes!,
      orderId: order!.id!,
      paymentMethod: order!.paymentMethod!,
      quantity: _countInt,
    );

    Utils.hideLoading();
    result.fold((failure) {
      Utils.handleFailures(failure);
    }, (order) {
      this.order = order;
      notifyListeners();
    });
  }

  /// create order method
  Future<void> _createOrder() async {
    final result = await _createOrderActivityUseCase(locationId: location!.id!);
    result.fold((failure) {
      Utils.handleFailures(failure);
    }, (order) async {
      this.order = order;
      _driverPositionLatLen = LatLng(double.parse(order.driverData!.latitude!),
          double.parse(order.driverData!.longitude!));
    });
  }

  /// listen to chat message stream
  void _listenToCheckout() {
    _listenUseCase().listen((RealTimeOrder realTimeOrder) async {
      if (realTimeOrder.lat != null && realTimeOrder.long != null) {
        _driverPositionLatLen = LatLng(double.parse(realTimeOrder.lat!),
            double.parse(realTimeOrder.long!));
        await _loadMapData();

        _showToastIfAvailable(realTimeOrder.message);
      }
      if (realTimeOrder.order != null) {
        final int? oldDriverId = order!.driverId;
        final int? currentDriverId = realTimeOrder.order!.driverId;
        final int? oldStatus = order?.status;
        order = realTimeOrder.order!;
        if (realTimeOrder.order?.status == 1 && oldStatus != 1) {}

        if (realTimeOrder.order!.status == 2) {
          // reset create order provider so we can create new order then go to rate service
          _resetProviderData();
          _showToastIfAvailable(realTimeOrder.message);
          return;
        } else if (currentDriverId != oldDriverId) {
          // reset the pusher on the new channel
          await _renewPusherChannel(realTimeOrder);
        }
        // change driver position every time it change

        // a message that tell him that there is no drivers available
        else if (realTimeOrder.order!.status == 5) {
          _noDriversDialog(realTimeOrder.message ?? '');
        } else if (realTimeOrder.order!.status == 7) {
          // driver canceled order after accepting it
          _resetProviderData();
          // ignore: use_build_context_synchronously
          _context.pop();
          Utils.showErrorToast(realTimeOrder.message!);
          return;
        }

        _showToastIfAvailable(realTimeOrder.message);
      }
      if (realTimeOrder.time != null && order != null) {
        order!.time = realTimeOrder.time;
      }
      notifyListeners();
    });
  }

  void _showToastIfAvailable(String? message) {
    if (message != null && message.isNotEmpty) {
      Utils.showToast(
        message,
      );
    }
  }

  /// renew pusher channel if driver id changed
  Future<void> _renewPusherChannel(RealTimeOrder realTimeOrder) async {
    await _disconnectPusherUseCase();

    await _initPusherUseCase(driverId: realTimeOrder.order!.driverId!);
    _listenToCheckout();
    _loadMapData();
    _positionCameraBetweenTwoCoords();
  }

  /// reset create order provider so we can create new order then go to rate service
  void _resetProviderData() {
    driverNotes = null;
    location = null;
    NavigatorUtils.goToRateServicePage(order!.id!);
    order = OrderEntity();
  }

  /// a message that tell him that there is no drivers available
  _noDriversDialog(String message) {
    const dialogName = 'no-drivers';
    Utils.showCustomDialog(
      name: dialogName,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          lottie.LottieBuilder.asset(Assets.cantFind),
          const SizedBox(height: 10.0),
          CustomText(
            message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                  child: CustomText(Utils.localization?.cancel),
                  onPressed: () {
                    Utils.hideCustomDialog(name: dialogName);
                    _context.pop();
                  }),
            ],
          ),
        ],
      ),
    );
  }

  ///cancel order
  cancelOrder() async {
    Utils.showLoading();
    final result = await _cancelOrderUseCase(orderId: order!.id!);
    Utils.hideLoading();

    result.fold((failure) => Utils.handleFailures(failure), (_) {
      _resetProviderData();
      _context.pop();
    });
  }

  /// toggle between check and delivered
  toggleBetweenDeliveredAndCheck() async {
    if (order!.status == 6 && order!.userEndTrip == order!.driverId) {
      // order delivered success
      await _orderDelivered();
    } else {
      // order check delivered
      await _deliveredChecked();
    }
  }

  /// this function should be called if the driver pressed DeliveredCheck
  _orderDelivered() async {
    Utils.showLoading();
    final result = await _orderDeliveredUseCase(orderId: order!.id!);
    Utils.hideLoading();

    result.fold((failure) => Utils.handleFailures(failure), (_) {
      // to reset coordinates so polylines method will start again in new order
      _polylineCoordinates.clear();
      markers.removeAt(1);
    });
  }

  /// this function should be called if there is no one pressed it before and it should be step before orderDelivered method
  _deliveredChecked() async {
    Utils.showLoading();
    final result = await _deliveredCheckedUseCase(orderId: order!.id!);
    Utils.hideLoading();

    result.fold((failure) => Utils.handleFailures(failure), (r) {});
  }

  /// this function should be called if there is no order received it should be step after deliveredChecked method
  deliveredUnChecked() async {
    Utils.showLoading();
    final result = await _deliveredUnCheckedUseCase(orderId: order!.id!);
    Utils.hideLoading();

    result.fold((failure) => Utils.handleFailures(failure), (r) {});
  }

  /// move camera between 2 polyline points (Recenter)
  Future<void> _positionCameraBetweenTwoCoords() async {
    LatLngBounds bound;
    if (userPositionLatLong.latitude > _driverPositionLatLen.latitude &&
        userPositionLatLong.longitude > _driverPositionLatLen.longitude) {
      bound = LatLngBounds(
          southwest: _driverPositionLatLen, northeast: userPositionLatLong);
    } else if (userPositionLatLong.longitude >
        _driverPositionLatLen.longitude) {
      bound = LatLngBounds(
          southwest: LatLng(
              userPositionLatLong.latitude, _driverPositionLatLen.longitude),
          northeast: LatLng(
              _driverPositionLatLen.latitude, userPositionLatLong.longitude));
    } else if (userPositionLatLong.latitude > _driverPositionLatLen.latitude) {
      bound = LatLngBounds(
          southwest: LatLng(
              _driverPositionLatLen.latitude, userPositionLatLong.longitude),
          northeast: LatLng(
              userPositionLatLong.latitude, _driverPositionLatLen.longitude));
    } else {
      bound = LatLngBounds(
          southwest: userPositionLatLong, northeast: _driverPositionLatLen);
    }

    controllerGoogleMap.animateCamera(CameraUpdate.newLatLngBounds(bound, 150));
  }

  /// listen to compass to change rotation of the car depends on compass sensor
  void _compassListen() {
    _compassStream = FlutterCompass.events!.listen((event) async {
      final currentHeading = event.heading ?? 0.0;

// changing all values to positive to can compare it with each other
// so i can only update marker if there is a big change in the compass
// not only vibrations changes
      final headingPositive = _heading.isNegative ? _heading * -1 : _heading;
      final currentHeadingPositive =
          currentHeading.isNegative ? currentHeading * -1 : currentHeading;
      /*
        '>>>>>>>>>>>> first check if heading more or less >>>>>>>>>>> \n'
        headingPositive > currentHeadingPositive


        '>>>>>>>>>>>> second check if changes more than 1 >>>>>>>>>>> \n'
        (headingPositive - currentHeadingPositive) > 1

        
        '>>>>>>>>>>>> else check if changes less than 1 >>>>>>>>>>> \n'
        (currentHeadingPositive - headingPositive) > 1
      */
      if ((headingPositive > currentHeadingPositive
              ? (headingPositive - currentHeadingPositive) > 1
              : (currentHeadingPositive - headingPositive) > 1) &&
          _driverIcon != null) {
        _heading = event.heading ?? 0.0;

        markers[0] = markers[0].copyWith(
          rotationParam: _heading,
        );
        notifyListeners();
      }
    });
  }
}
