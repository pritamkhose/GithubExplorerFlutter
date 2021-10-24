import './item.dart';

class UserSearchResponse {
  final bool incomplete_results;
  final List<Item> items;
  final int total_count;
  UserSearchResponse(this.incomplete_results, this.items, this.total_count);
}