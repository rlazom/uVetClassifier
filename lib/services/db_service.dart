import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/keys.dart';

class DbService {
  /// singleton boilerplate
  static final DbService _dbService = DbService._internal();

  factory DbService() {
    return _dbService;
  }

  DbService._internal();
  /// singleton boilerplate

  late final SupabaseClient _supabase;
  // SupabaseClient get supabase => _supabase;

  Future initialize() async {
    await Supabase.initialize(
      url: supabase_project_api_url,
      anonKey: supabase_project_anon_key,
    );
    _supabase = Supabase.instance.client;
  }

  Future<Map?> searchByBarcode(String barcode) async {
    print('searchByBarcode()...');
    var response;
    Map? data = {};

    print('searchByBarcode() - fetching data from m_barcode... [barcode eq "$barcode"]');
    try {
      // response = await _supabase.from('m_barcode').select('id_product').eq('barcode', barcode).single();
      response = await _supabase.from('m_barcode').select('id_product').eq('barcode', barcode).limit(1);
      print('searchByBarcode() - fetching data from m_barcode...DONE - response: "$response"');
    } catch (e) {
      print('searchByBarcode() - fetching data from m_barcode...ERROR - e: "$e"');
      return null;
    }

    data = (response as List).firstOrNull;

    String? idProduct = data?['id_product'];
    print('searchByBarcode() - idProduct: "$idProduct"');

    if(idProduct != null) {
      print('searchByBarcode() - fetching data from c_products... [uuid eq "$idProduct"]');
      try {
        response = await _supabase.from('c_products').select().eq('uuid', idProduct).single();
      } catch (e) {
        print('searchByBarcode() - fetching data from c_products...ERROR - e: "$e"');
        return null;
      }
      print('searchByBarcode() - fetching data from c_products...DONE - response: "$response"');
      data = response;
    }

    return data;
  }

  Future<List<Map<String,dynamic>>?> searchByName(String name) async {
    print('searchByName()...');
    List<dynamic> response;
    List<Map<String,dynamic>>? data;

    print('searchByName() - fetching data from c_products... [id or name like "$name"]');
    // response = await _supabase.from('c_products').select().like('name', '%$name%');
    response = await _supabase
        .from('c_products')
        .select()
        .or('product_id.ilike.%$name%,name.ilike.%$name%');
    print('searchByName() - fetching data from c_products...DONE - response[${response.length}]: "$response"');

    // for(var item in response) {
    //   print('searchByName() - item: "$item"');
    // }

    // var decoded = response.map((e) => json.decode(e)).toList();
    data = response.map((e) => e).cast<Map<String, dynamic>>().toList();

    return data;
  }
}
