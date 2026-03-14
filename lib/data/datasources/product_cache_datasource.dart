import '../models/product_model.dart';

class ProductCacheDatasource {
  List<ProductModel>? _cache;
  
  void save(List<ProductModel> products) {
    _cache = products;
  }
  
  List<ProductModel>? get() {
    return _cache;
  }
  
  void clear() {
    _cache = null;
  }
  
  bool hasCache() => _cache != null;
}