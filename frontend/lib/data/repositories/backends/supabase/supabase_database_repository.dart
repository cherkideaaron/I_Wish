import 'package:supabase_flutter/supabase_flutter.dart';

/// Template for interacting with Supabase Database (PostgreSQL).
/// 
/// HOW TO CALL THIS FROM YOUR SCREENS:
///   1. Create a Riverpod provider for this repository:
///      `final supabaseDbProvider = Provider((ref) => SupabaseDatabaseRepository());`
///   2. Create a FutureProvider or AsyncNotifier in your `features/` folder
///      to manage the state of the data.
///   3. In your UI (e.g. `HomeScreen`), `ref.watch` that state provider!
class SupabaseDatabaseRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Change this to the name of your table in Supabase
  final String tableName = 'wishes'; 

  /// CREATE (Insert)
  Future<void> createRecord(Map<String, dynamic> data) async {
    await _supabase.from(tableName).insert(data);
  }

  /// READ (Select All)
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final response = await _supabase.from(tableName).select();
    // response is a List<Map<String, dynamic>>
    return response; 
  }

  /// READ (Select by ID)
  Future<Map<String, dynamic>?> getRecordById(String id) async {
    final response = await _supabase
        .from(tableName)
        .select()
        .eq('id', id)
        .maybeSingle(); // Returns null if not found
    return response;
  }

  /// UPDATE
  Future<void> updateRecord(String id, Map<String, dynamic> data) async {
    await _supabase.from(tableName).update(data).eq('id', id);
  }

  /// DELETE
  Future<void> deleteRecord(String id) async {
    await _supabase.from(tableName).delete().eq('id', id);
  }
}
