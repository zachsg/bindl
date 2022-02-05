import 'package:bodai/models/sort_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cookbook_controller.dart';

final sortOrderProvider = StateNotifierProvider<SortOrderController, SortOrder>(
    (ref) => SortOrderController(ref: ref));

class SortOrderController extends StateNotifier<SortOrder> {
  SortOrderController({required this.ref}) : super(SortOrder.latest);

  final Ref ref;

  void sortMeals(SortOrder sortOrder) {
    state = sortOrder;

    ref.read(cookbookProvider.notifier).load();
  }
}
