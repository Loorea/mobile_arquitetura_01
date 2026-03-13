import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_state.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository;
  ProductState _state = const ProductState();
  
  ProductViewModel(this._repository);
  
  ProductState get state => _state;
  
  Future<void> loadProducts() async {
    _updateState(isLoading: true, error: null);
    
    try {
      final products = await _repository.getProducts();
      _updateState(isLoading: false, products: products);
    } catch (e) {
      _updateState(
        isLoading: false,
        error: e.toString().replaceAll('Failure: ', ''),
      );
    }
  }
  
  void _updateState({
    bool? isLoading,
    List<Product>? products,
    String? error,
  }) {
    _state = _state.copyWith(
      isLoading: isLoading,
      products: products,
      error: error,
    );
    notifyListeners();
  }
}