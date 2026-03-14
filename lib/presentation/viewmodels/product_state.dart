import '../../domain/entities/product.dart';

class ProductState {
  final bool isLoading;
  final List<Product> products;
  final String? error;
  final bool isFromCache;
  
  const ProductState({
    this.isLoading = false,
    this.products = const [],
    this.error,
    this.isFromCache = false,
  });
  
  bool get hasError => error != null;
  bool get hasProducts => products.isNotEmpty;
  bool get isEmpty => !isLoading && !hasError && products.isEmpty;
  
  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
    bool? isFromCache,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
  
  @override
  String toString() {
    return 'ProductState(isLoading: $isLoading, products: ${products.length}, error: $error, isFromCache: $isFromCache)';
  }
}