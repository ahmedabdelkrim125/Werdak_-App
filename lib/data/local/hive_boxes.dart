// lib/data/local/hive_boxes.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../models/plan_model.dart';

class HiveBoxes {
  static const String plansBoxName = 'plans';

  static Box<PlanModel> get plans => Hive.box<PlanModel>(plansBoxName);

  static Future<void> openBoxes() async {
    await Hive.openBox<PlanModel>(plansBoxName);
  }
}
