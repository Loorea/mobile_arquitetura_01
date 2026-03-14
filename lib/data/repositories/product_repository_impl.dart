import '../../core/errors/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../datasources/product_cache_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;
  final ProductCacheDatasource cacheDatasource;
  
  ProductRepositoryImpl(this.remoteDatasource, this.cacheDatasource);
  
  @override
  Future<List<Product>> getProducts() async {
    try {
      //print('Tentando buscar produtos da API...');
      final models = await remoteDatasource.getProducts();
      
      cacheDatasource.save(models);
      //print('Produtos salvos no cache');
      
      return models.map((model) => model.toEntity()).toList();
      
    } catch (e) {
      //print('Erro ao buscar da API: $e');
      
      final cachedModels = cacheDatasource.get();
      
      if (cachedModels != null) {
        //print('Usando dados do cache');
        return cachedModels.map((model) => model.toEntity()).toList();
      }
      
      //print('Sem cache disponível');
      throw Failure('Não foi possível carregar os produtos. Verifique sua conexão.');
    }
  }
}