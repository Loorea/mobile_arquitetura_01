import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/product_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductViewModel>();
    final state = viewModel.state;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (state.isFromCache)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.storage, size: 16),
                  SizedBox(width: 4),
                  Text('Offline', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
      body: _buildBody(context, state, viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.loadProducts(),
        tooltip: 'Recarregar',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductState state, ProductViewModel viewModel) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando produtos...'),
          ],
        ),
      );
    }
    
    if (state.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Ops! Algo deu errado',
                style: Theme.of(context).textTheme.titleLarge,  // <-- AGORA FUNCIONA
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => viewModel.retry(),
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (state.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhum produto encontrado',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Clique no botão abaixo para carregar',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => viewModel.loadProducts(),
              icon: const Icon(Icons.download),
              label: const Text('Carregar produtos'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () => viewModel.loadProducts(),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          final product = state.products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage(product.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                'R\$ ${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}