import '../Utils/api_parser.dart';

class DashboardResponseModel {
  final String? status;
  final String? message;
  final DashboardStatistics? statistics;
  final List<DashboardOrder>? recentOrders;

  DashboardResponseModel({
    this.status,
    this.message,
    this.statistics,
    this.recentOrders,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardResponseModel(
      status: ApiParser.parseString(json['status']),
      message: ApiParser.parseString(json['message']),
      statistics: json['statistics'] != null
          ? DashboardStatistics.fromJson(json['statistics'] as Map<String, dynamic>)
          : null,
      recentOrders: json['recent_orders'] != null
          ? (json['recent_orders'] as List)
              .map((e) => DashboardOrder.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (statistics != null) {
      data['statistics'] = statistics!.toJson();
    }
    if (recentOrders != null) {
      data['recent_orders'] = recentOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DashboardStatistics {
  final int? totalOrders;
  final int? deliveredOrders;
  final int? inTransitOrders;
  final int? dispatchedOrders;
  final int? cancelledOrders;
  final int? paidOrders;
  final int? pendingPayments;
  final int? partialPayments;
  final double? totalAmount;
  final double? totalDue;

  DashboardStatistics({
    this.totalOrders,
    this.deliveredOrders,
    this.inTransitOrders,
    this.dispatchedOrders,
    this.cancelledOrders,
    this.paidOrders,
    this.pendingPayments,
    this.partialPayments,
    this.totalAmount,
    this.totalDue,
  });

  factory DashboardStatistics.fromJson(Map<String, dynamic> json) {
    return DashboardStatistics(
      totalOrders: ApiParser.parseInt(json['total_orders']),
      deliveredOrders: ApiParser.parseInt(json['delivered_orders']),
      inTransitOrders: ApiParser.parseInt(json['in_transit_orders']),
      dispatchedOrders: ApiParser.parseInt(json['dispatched_orders']),
      cancelledOrders: ApiParser.parseInt(json['cancelled_orders']),
      paidOrders: ApiParser.parseInt(json['paid_orders']),
      pendingPayments: ApiParser.parseInt(json['pending_payments']),
      partialPayments: ApiParser.parseInt(json['partial_payments']),
      totalAmount: ApiParser.parseDouble(json['total_amount']),
      totalDue: ApiParser.parseDouble(json['total_due']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_orders'] = totalOrders;
    data['delivered_orders'] = deliveredOrders;
    data['in_transit_orders'] = inTransitOrders;
    data['dispatched_orders'] = dispatchedOrders;
    data['cancelled_orders'] = cancelledOrders;
    data['paid_orders'] = paidOrders;
    data['pending_payments'] = pendingPayments;
    data['partial_payments'] = partialPayments;
    data['total_amount'] = totalAmount;
    data['total_due'] = totalDue;
    return data;
  }
}

class DashboardOrder {
  final int? id;
  final String? name;
  final String? customerName;
  final String? plantName;
  final String? orderDate;
  final double? amountTotal;
  final double? amountDue;
  final String? state;
  final String? paymentState;

  DashboardOrder({
    this.id,
    this.name,
    this.customerName,
    this.plantName,
    this.orderDate,
    this.amountTotal,
    this.amountDue,
    this.state,
    this.paymentState,
  });

  factory DashboardOrder.fromJson(Map<String, dynamic> json) {
    return DashboardOrder(
      id: ApiParser.parseInt(json['id']),
      name: ApiParser.parseString(json['name']),
      customerName: ApiParser.parseString(json['customer_name']),
      plantName: ApiParser.parseString(json['plant_name']),
      orderDate: ApiParser.parseString(json['order_date']),
      amountTotal: ApiParser.parseDouble(json['amount_total']),
      amountDue: ApiParser.parseDouble(json['amount_due']),
      state: ApiParser.parseString(json['state']),
      paymentState: ApiParser.parseString(json['payment_state']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['customer_name'] = customerName;
    data['plant_name'] = plantName;
    data['order_date'] = orderDate;
    data['amount_total'] = amountTotal;
    data['amount_due'] = amountDue;
    data['state'] = state;
    data['payment_state'] = paymentState;
    return data;
  }
}
