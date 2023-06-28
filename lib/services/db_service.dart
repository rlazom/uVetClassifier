import 'dart:async';
import 'dart:convert';
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

  Future<Map> searchByBarcode(String barcode) async {
    print('searchByBarcode()...');
    var response;
    Map data;

    print('searchByBarcode() - fetching data from m_barcode... [barcode eq "$barcode"]');
    response = await _supabase.from('m_barcode').select('id_product').eq('barcode', barcode).single();
    print('searchByBarcode() - fetching data from m_barcode...DONE - response: "$response"');
    data = response;

    String idProduct = data['id_product'];
    print('searchByBarcode() - idProduct: "$idProduct"');

    print('searchByBarcode() - fetching data from c_products... [uuid eq "$idProduct"]');
    response = await _supabase.from('c_products').select().eq('uuid', idProduct).single();
    print('searchByBarcode() - fetching data from c_products...DONE - response: "$response"');
    data = response;

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
