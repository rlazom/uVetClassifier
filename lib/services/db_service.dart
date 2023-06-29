import 'dart:async';
import 'package:flutter/foundation.dart';
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
    debugPrint('DbService - searchByBarcode()...');
    var response;
    Map? data = {};

    debugPrint('DbService - searchByBarcode() - fetching data from m_barcode... [barcode eq "$barcode"]');
    try {
      // response = await _supabase.from('m_barcode').select('id_product').eq('barcode', barcode).single();
      response = await _supabase.from('m_barcode').select('id_product').eq('barcode', barcode).limit(1);
      debugPrint('DbService - searchByBarcode() - fetching data from m_barcode...DONE - response: "$response"');
    } catch (e) {
      debugPrint('DbService - searchByBarcode() - fetching data from m_barcode...ERROR - e: "$e"');
      return null;
    }

    data = (response as List).firstOrNull;

    String? idProduct = data?['id_product'];
    debugPrint('DbService - searchByBarcode() - idProduct: "$idProduct"');

    if(idProduct != null) {
      debugPrint('DbService - searchByBarcode() - fetching data from c_products... [uuid eq "$idProduct"]');
      try {
        response = await _supabase.from('c_products').select().eq('uuid', idProduct).single();
      } catch (e) {
        debugPrint('DbService - searchByBarcode() - fetching data from c_products...ERROR - e: "$e"');
        return null;
      }
      debugPrint('DbService - searchByBarcode() - fetching data from c_products...DONE - response: "$response"');
      data = response;
    }

    return data;
  }

  Future<List<Map<String,dynamic>>?> searchByName(String name) async {
    debugPrint('DbService - searchByName()...');
    List<dynamic> response;
    List<Map<String,dynamic>>? data;

    debugPrint('DbService - searchByName() - fetching data from c_products... [id or name like "$name"]');
    // response = await _supabase.from('c_products').select().like('name', '%$name%');
    response = await _supabase
        .from('c_products')
        .select()
        .or('product_id.ilike.%$name%,name.ilike.%$name%').order('product_id', ascending: true);
    debugPrint('DbService - searchByName() - fetching data from c_products...DONE - response[${response.length}]: "$response"');

    // for(var item in response) {
    //   debugPrint('searchByName() - item: "$item"');
    // }

    // var decoded = response.map((e) => json.decode(e)).toList();
    data = response.map((e) => e).cast<Map<String, dynamic>>().toList();

    return data;
  }

  Future<List<Map<String,dynamic>>?> searchByProductUuid(String productUuid) async {
    debugPrint('DbService - searchByProductUuid()...');
    var response;
    List<Map<String,dynamic>>? data;

    debugPrint('DbService - searchByProductUuid() - fetching data from m_barcode... [productUuid eq "$productUuid"]');
    try {
      // response = await _supabase.from('m_barcode').select('id_product').eq('barcode', barcode).single();
      // response = await _supabase.from('m_barcode').select('barcode').eq('id_product', productUuid);
      response = await _supabase.from('m_barcode').select().eq('id_product', productUuid);
      debugPrint('DbService - searchByProductUuid() - fetching data from m_barcode...DONE - response: "$response"');
    } catch (e) {
      debugPrint('DbService - searchByProductUuid() - fetching data from m_barcode...ERROR - e: "$e"');
      return null;
    }

    data = response.map((e) => e).cast<Map<String, dynamic>>().toList();
    return data;
  }

  Future<List<Map<String,dynamic>>?> addBarcodeToProduct({required String barcode, required String productUuid}) async {
    debugPrint('DbService - addBarcodeToProduct()...');
    var response;
    List<Map<String,dynamic>>? data;

    debugPrint('DbService - addBarcodeToProduct() - inserting data to m_barcode... [barcode: "$barcode", productUuid: "$productUuid"]');
    try {
      // response = await _supabase.from('m_barcode').select('id_product').eq('barcode', barcode).single();
      // response = await _supabase.from('m_barcode').select('barcode').eq('id_product', productUuid);
      response = await _supabase.from('m_barcode').insert({'barcode': barcode, 'id_product': productUuid}).select();
      debugPrint('DbService - addBarcodeToProduct() - inserting data to m_barcode...DONE - response: "$response"');
    } catch (e) {
      debugPrint('DbService - addBarcodeToProduct() - inserting data to m_barcode...ERROR - e: "$e"');
      return null;
    }

    data = response.map((e) => e).cast<Map<String, dynamic>>().toList();
    return data;
  }

  Future<List<Map<String,dynamic>>?> deleteBarcodeUuid(String uuid) async {
    debugPrint('DbService - deleteBarcodeUuid()...');
    var response;
    List<Map<String,dynamic>>? data;

    debugPrint('DbService - deleteBarcodeUuid() - deleting data from m_barcode... [uuid eq "$uuid"]');
    try {
      // response = await _supabase.from('m_barcode').select('id_product').eq('barcode', barcode).single();
      // response = await _supabase.from('m_barcode').select('barcode').eq('id_product', productUuid);
      response = await _supabase.from('m_barcode').delete().match({'id': uuid}).select();
      debugPrint('DbService - deleteBarcodeUuid() - deleting data from m_barcode...DONE - response: "$response"');
    } catch (e) {
      debugPrint('DbService - deleteBarcodeUuid() - deleting data from m_barcode...ERROR - e: "$e"');
      return null;
    }

    data = response.map((e) => e).cast<Map<String, dynamic>>().toList();
    return data;
  }

  Future<bool?> updateProduct({required String productUuid, required String productId, required String name, required String? provider, required String? classification, required String? image}) async {
    debugPrint('DbService - updateProduct()...');
    var response;

    debugPrint('DbService - updateProduct() - productUuid: "$productUuid"');
    debugPrint('DbService - updateProduct() - productId: "$productId"');
    debugPrint('DbService - updateProduct() - name: "$name"');
    debugPrint('DbService - updateProduct() - provider: "$provider"');
    debugPrint('DbService - updateProduct() - classification: "$classification"');
    debugPrint('DbService - updateProduct() - image: "$image"');

    debugPrint('DbService - updateProduct() - updating data to c_products...');
    try {
      response = await _supabase.from('c_products').update({'product_id': productId, 'name': name, 'provider': provider, 'classification': classification}).match({ 'uuid': productUuid });
      debugPrint('DbService - updateProduct() - updating data to c_products...DONE - response: "$response"');
    } catch (e) {
      debugPrint('DbService - updateProduct() - updating data to c_products...ERROR - e: "$e"');
      return null;
    }

    return true;
  }
}
