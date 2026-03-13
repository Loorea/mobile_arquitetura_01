import '../../core/errors/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;
  
  ProductRepositoryImpl(this.remoteDatasource);
  
  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remoteDatasource.getProducts();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Failure('Não foi possível carregar os produtos: ${e.toString()}');
    }
  }
}