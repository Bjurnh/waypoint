import 'package:hive/hive.dart';

part 'plan_config.g.dart';

@HiveType(typeId: 1)
class PlanConfig extends HiveObject {
  @HiveField(0)
  int length;

  @HiveField(1)
  DateTime startDate;

  @HiveField(2)
  String style;

  PlanConfig({
    required this.length,
    required this.startDate,
    required this.style,
  });

  Map<String, dynamic> toMap() => {
        'length': length,
        'startDate': startDate.toIso8601String(),
        'style': style,
      };

  factory PlanConfig.fromMap(Map<String, dynamic> m) => PlanConfig(
        length: m['length'] as int,
        startDate: DateTime.parse(m['startDate'] as String),
        style: m['style'] as String,
      );
}
