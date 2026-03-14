import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_state.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository;
  ProductState _state = const ProductState();
  
  ProductViewModel(this._repository);
  
  ProductState get state => _state;

  bool get isLoading => _state.isLoading;
  bool get hasError => _state.hasError;
  bool get hasProducts => _state.hasProducts;
  String? get error => _state.error;
  List<Product> get products => _state.products;
  
  Future<void> loadProducts() async {
    _updateState(isLoading: true, error: null);
    
    try {
      final products = await _repository.getProducts();
      _updateState(
        isLoading: false, 
        products: products,
      );
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Failure: ')) {
        errorMessage = errorMessage.replaceFirst('Failure: ', '');
      }
      _updateState(
        isLoading: false,
        error: errorMessage,
      );
    }
  }
  
  Future<void> retry() => loadProducts();
  
  void _updateState({
    bool? isLoading,
    List<Product>? products,
    String? error,
    bool? isFromCache,
  }) {
    _state = _state.copyWith(
      isLoading: isLoading,
      products: products,
      error: error,
      isFromCache: isFromCache,
    );
    notifyListeners();  
  }
}