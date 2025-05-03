import 'package:dingtea/infrastructure/models/data/refund_data.dart';
import 'package:dingtea/infrastructure/models/data/repeat_data.dart';
import 'package:dingtea/infrastructure/models/data/user.dart';

import '../models.dart';
import 'addons_data.dart';

class OrderActiveModel {
  OrderActiveModel({
    this.id,
    this.userId,
    this.totalPrice,
    this.originPrice,
    this.coupon,
    this.rate,
    this.tax,
    this.tips,
    this.commissionFee,
    this.status,
    this.location,
    this.address,
    this.deliveryType,
    this.deliveryMan,
    this.deliveryFee,
    this.otp,
    this.deliveryDate,
    this.deliveryTime,
    this.totalDiscount,
    this.serviceFee,
    this.createdAt,
    this.updatedAt,
    this.shop,
    this.repeat,
    this.user,
    this.details,
    this.currencyModel,
    this.transaction,
    this.review,
    this.refunds,
    this.ponumHistories,
    this.afterDeliveredImage,
  });

  int? id;
  num? userId;
  num? totalPrice;
  num? originPrice;
  num? coupon;
  num? rate;
  num? tax;
  num? commissionFee;
  String? status;
  Location? location;
  AddressModel? address;
  String? deliveryType;
  num? tips;
  String? afterDeliveredImage;
  num? deliveryFee;
  num? otp;
  CurrencyModel? currencyModel;
  DeliveryMan? deliveryMan;
  DateTime? deliveryDate;
  String? deliveryTime;
  num? totalDiscount;
  num? serviceFee;
  DateTime? createdAt;
  DateTime? updatedAt;
  ShopData? shop;
  RepeatData? repeat;
  UserModel? user;
  List<Detail>? details;
  List<RefundModel>? refunds;
  TransactionData? transaction;
  dynamic review;
  List<dynamic>? ponumHistories;

  factory OrderActiveModel.fromJson(Map<String, dynamic> json) =>
      OrderActiveModel(
        id: json["data"]["id"],
        userId: json["data"]["user_id"],
        afterDeliveredImage: json["data"]["image_after_delivered"],
        totalPrice: json["data"]["total_price"],
        originPrice: json["data"]["origin_price"],
        coupon: json["data"]?["coupon"]?["price"],
        rate: json["data"]["rate"],
        tax: json["data"]["tax"],
        tips: json["data"]["tips"],
        currencyModel: json["data"]["currency"] != null
            ? CurrencyModel.fromJson(json["data"]["currency"])
            : null,
        commissionFee: json["data"]["commission_fee"],
        status: json["data"]["status"],
        location: json["data"]["location"] != null
            ? Location.fromJson(json["data"]["location"])
            : null,
        address: json["data"]["address"] != null
            ? AddressModel.fromJson(json["data"]["address"])
            : null,
        deliveryType: json["data"]["delivery_type"],
        deliveryFee: json["data"]["delivery_fee"],
        otp: json["data"]["otp"],
        deliveryMan: json["data"]["deliveryman"] != null
            ? DeliveryMan.fromJson(json["data"]["deliveryman"])
            : null,
        deliveryDate:
            DateTime.tryParse(json["data"]?["delivery_date"] ?? '')?.toLocal(),
        deliveryTime: json["data"]["delivery_time"],
        totalDiscount: json["data"]["total_discount"],
        serviceFee: json["data"]["service_fee"],
        createdAt: DateTime.tryParse(json["data"]["created_at"])?.toLocal(),
        updatedAt: DateTime.tryParse(json["data"]["updated_at"])?.toLocal(),
        shop: json["data"]["shop"] != null
            ? ShopData.fromJson(json["data"]["shop"])
            : null,
        repeat: json["data"]["repeat"] != null
            ? RepeatData.fromJson(json["data"]["repeat"])
            : null,
        user: json["data"]["user"] != null
            ? UserModel.fromJson(json["data"]["user"])
            : null,
        details: List<Detail>.from(
            json["data"]["details"].map((x) => Detail.fromJson(x))),
        transaction: json["data"]["transaction"] != null
            ? TransactionData.fromJson(json["data"]["transaction"])
            : null,
        refunds: json["data"]["order_refunds"] != null
            ? List<RefundModel>.from(json["data"]["order_refunds"]
                .map((x) => RefundModel.fromJson(x)))
            : [],
        review: json["data"]["review"],
      );

  factory OrderActiveModel.fromJsonWithoutData(Map<String, dynamic> json) {
    return OrderActiveModel(
      id: json["id"] ?? 0,
      userId: json["user_id"],
      afterDeliveredImage: json["image_after_delivered"],
      totalPrice: json["total_price"],
      originPrice: json["origin_price"],
      coupon: json["coupon"]?["price"],
      rate: json["rate"],
      tax: json["tax"],
      tips: json["tips"],
      currencyModel: json["currency"] != null
          ? CurrencyModel.fromJson(json["currency"])
          : null,
      commissionFee: json["commission_fee"],
      status: json["status"],
      location:
          json["location"] != null ? Location.fromJson(json["location"]) : null,
      address: AddressModel.fromJson(json["address"]),
      deliveryType: json["delivery_type"],
      deliveryFee: json["delivery_fee"],
      otp: json["otp"],
      serviceFee: json["service_fee"],
      deliveryMan: json["deliveryman"] != null
          ? DeliveryMan.fromJson(json["deliveryman"])
          : null,
      deliveryDate: DateTime.tryParse(json["delivery_date"] ?? '')?.toLocal(),
      deliveryTime: json["delivery_time"],
      totalDiscount: json["total_discount"],
      createdAt: DateTime.tryParse(json["created_at"])?.toLocal(),
      updatedAt: DateTime.tryParse(json["updated_at"])?.toLocal(),
      shop: json["shop"] != null ? ShopData.fromJson(json["shop"]) : null,
      repeat:
          json["repeat"] != null ? RepeatData.fromJson(json["repeat"]) : null,
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
      details: json["details"] != null
          ? List<Detail>.from(json["details"].map((x) => Detail.fromJson(x)))
          : null,
      transaction: json["transaction"] != null
          ? TransactionData.fromJson(json["transaction"])
          : null,
      review: json["review"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "total_price": totalPrice,
        "origin_price": originPrice,
        "rate": rate,
        "tax": tax,
        "tips": tips,
        "commission_fee": commissionFee,
        "status": status,
        "image_after_delivered": afterDeliveredImage,
        "location": location?.toJson(),
        "address": address,
        "delivery_type": deliveryType,
        "delivery_fee": deliveryFee,
        "otp": otp,
        "service_fee": serviceFee,
        "delivery_date":
            "${deliveryDate?.year.toString().padLeft(4, '0')}-${deliveryDate?.month.toString().padLeft(2, '0')}-${deliveryDate?.day.toString().padLeft(2, '0')}",
        "delivery_time": deliveryTime,
        "total_discount": totalDiscount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "shop": shop?.toJson(),
        "repeat": repeat?.toJson(),
        "user": user?.toJson(),
        "details": List<dynamic>.from(details!.map((x) => x.toJson())),
        "transaction": transaction,
        "review": review,
        "ponum_histories": List<dynamic>.from(ponumHistories!.map((x) => x)),
      };
}

class Detail {
  Detail(
      {this.id,
      this.orderId,
      this.stockId,
      this.originPrice,
      this.totalPrice,
      this.tax,
      this.discount,
      this.quantity,
      this.bonus,
      this.bonusShop,
      this.note,
      this.createdAt,
      this.updatedAt,
      this.stock,
      this.addons});

  num? id;
  num? orderId;
  num? stockId;
  num? originPrice;
  num? totalPrice;
  num? tax;
  num? discount;
  String? note;
  int? quantity;
  bool? bonus;
  bool? bonusShop;
  DateTime? createdAt;
  DateTime? updatedAt;
  Stocks? stock;
  List<Addons>? addons;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"] ?? 0,
        orderId: json["order_id"],
        stockId: json["stock_id"],
        originPrice: json["origin_price"],
        totalPrice: json["total_price"],
        tax: json["tax"],
        note: json["note"],
        discount: json["discount"],
        quantity: json["quantity"],
        bonus: (json["bonus"].runtimeType == int)
            ? json["bonus"] == 1
            : json["bonus"],
        bonusShop: (json["bonus_shop"].runtimeType == int)
            ? json["bonus_shop"] == 1
            : json["bonus_shop"],
        createdAt: DateTime.tryParse(json["created_at"])?.toLocal(),
        updatedAt: DateTime.tryParse(json["updated_at"])?.toLocal(),
        addons: json['addons'] != null
            ? List<Addons>.from(json["addons"].map((x) {
                if (x["product"] != null || x["stock"] != null || x != null) {
                  return Addons.fromJson(x);
                }
              }))
            : null,
        stock: json["stock"] != null ? Stocks.fromJson(json["stock"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "stock_id": stockId,
        "origin_price": originPrice,
        "total_price": totalPrice,
        "tax": tax,
        "discount": discount,
        "quantity": quantity,
        "bonus": bonus,
        "bonus_shop": bonusShop,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "stock": stock?.toJson(),
      };
}

class DeliveryMan {
  DeliveryMan(
      {this.id,
      this.uuid,
      this.firstname,
      this.lastname,
      this.phone,
      this.birthday,
      this.gender,
      this.emailVerifiedAt,
      this.registeredAt,
      this.active,
      this.role,
      this.img});

  int? id;
  String? uuid;
  String? firstname;
  String? lastname;
  String? phone;
  String? img;
  DateTime? birthday;
  String? gender;
  DateTime? emailVerifiedAt;
  DateTime? registeredAt;
  bool? active;
  String? role;

  factory DeliveryMan.fromJson(Map<String, dynamic> json) {
    return DeliveryMan(
      id: json["id"] ?? 0,
      uuid: json["uuid"] ?? "",
      firstname: json["firstname"] ?? "",
      lastname: json["lastname"] ?? "",
      phone: json["phone"] ?? "",
      img: json["img"] ?? "",
      gender: json["gender"] ?? "",
      active: json["active"].runtimeType == int
          ? (json["active"] != 0)
          : json["active"],
      role: json["role"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "birthday": birthday?.toIso8601String(),
        "gender": gender,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "registered_at": registeredAt?.toIso8601String(),
        "active": active,
        "role": role,
      };
}

class CurrencyModel {
  int? id;
  String? symbol;
  String? title;
  bool? active;

  CurrencyModel({this.id, this.symbol, this.title, this.active});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    title = json['title'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['symbol'] = symbol;
    data['title'] = title;
    data['active'] = active;
    return data;
  }
}
