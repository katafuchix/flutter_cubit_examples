import 'package:freezed_annotation/freezed_annotation.dart';

part 'job.freezed.dart';

part 'job.g.dart';

enum JobType { normal, accepted, rejected }

// https://6169a28b09e030001712c4dc.mockapi.io/jobs
@freezed
class Job with _$Job {
  const factory Job({
    required int id,
    @Default('') String title,
    required Address pickup,
    @JsonKey(name: 'drop_off') required Address dropOff, // スネークケースをキャメルケースに変換
    @JsonKey(name: 'date_posted') required DateTime datePosted,
    @JsonKey(name: 'expected_delivery_date')
    required DateTime expectedDeliveryDate,
    @Default(JobType.normal) JobType jobType,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}

/*
// こう言う書き方もあり
@Freezed(fromJson: true)
@JsonSerializable(fieldRename: FieldRename.snake) // これを追加！
class ProductDelivery with _$ProductDelivery {
  const factory ProductDelivery({
    required int id,
    required String title,
    required Address pickup,
    required Address dropOff, // @JsonKeyなしでも自動で 'drop_off' を探してくれる
    required DateTime datePosted, // 自動で 'date_posted' を探してくれる
  }) = _ProductDelivery;

  factory ProductDelivery.fromJson(Map<String, dynamic> json) =>
      _$ProductDeliveryFromJson(json);
}
 */

@freezed
class Address with _$Address {
  const factory Address({
    @Default('') String addressLine1,
    @Default('') String postcode,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

/*
// 自動的にキャメルケースに基づいてキーを探す指定
@Freezed(fromJson: true)
@JsonSerializable(fieldRename: FieldRename.snake) // これを追加！
class ProductDelivery with _$ProductDelivery {
  const factory ProductDelivery({
    required int id,
    required String title,
    required Address pickup,
    required Address dropOff, // @JsonKeyなしでも自動で 'drop_off' を探してくれる
    required DateTime datePosted, // 自動で 'date_posted' を探してくれる
  }) = _ProductDelivery;

  factory ProductDelivery.fromJson(Map<String, dynamic> json) =>
      _$ProductDeliveryFromJson(json);
}
 */
