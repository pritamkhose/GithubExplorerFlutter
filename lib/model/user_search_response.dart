import './item.dart';

class UserSerachResponse {
  final bool incomplete_results;
  final List<Item> items;
  final int total_count;
  UserSerachResponse(this.incomplete_results, this.items, this.total_count);
}