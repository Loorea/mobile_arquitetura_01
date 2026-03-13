import '../../core/network/http_client.dart';
import '../models/product_model.dart';

class ProductRemoteDatasource {
  final HttpClient client;
  static const String _baseUrl = 'https://fakestoreapi.com/products';
  
  ProductRemoteDatasource(this.client);
  
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await client.get(_baseUrl);
      
      if (response.statusCode != 200) {
        throw Exception('Erro ${response.statusCode} ao buscar produtos');
      }
      
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Falha no datasource remoto: $e');
    }
  }
}