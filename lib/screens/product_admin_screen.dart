import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../data/product.dart';
import '../data/product_repository.dart';
import '../data/admin_auth_repository.dart';
import '../widgets/admin_components.dart';
import '../widgets/feedback_widgets.dart';
import '../widgets/product_form_dialog.dart';

class ProductAdminScreen extends StatefulWidget {
  const ProductAdminScreen({super.key});

  @override
  State<ProductAdminScreen> createState() => _ProductAdminScreenState();
}

class _ProductAdminScreenState extends State<ProductAdminScreen> {
  final ProductRepository _repository = ProductRepository();
  final AdminAuthRepository _auth = AdminAuthRepository();
  final _search = TextEditingController();
  String _query = '';
  String _stockFilter = 'all';
  String _sortBy = 'name';

  bool get _hasActiveFilters =>
      _query.trim().isNotEmpty || _stockFilter != 'all' || _sortBy != 'name';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openForm([Product? product]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => ProductFormDialog(product: product),
    );
    if (saved == true && mounted) _showMessage('Đã lưu sản phẩm.');
  }

  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.delete_outline_rounded,
          color: Color(0xFFD64545),
        ),
        title: const Text('Xóa sản phẩm?'),
        content: Text('Bạn có chắc muốn xóa “${product.name}” khỏi Firestore?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD64545),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa sản phẩm'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _repository.delete(product.id);
      if (mounted) _showMessage('Đã xóa sản phẩm.');
    } catch (e) {
      if (mounted) _showMessage('Không xóa được sản phẩm: $e', error: true);
    }
  }

  void _showMessage(String message, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: error ? const Color(0xFFB42318) : AppColors.navy,
        ),
      );
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Product>>(
    stream: _repository.watchProducts(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return FullPageMessage(
          icon: Icons.cloud_off_outlined,
          title: 'Không tải được dữ liệu',
          detail: snapshot.error.toString(),
        );
      }
      if (!snapshot.hasData) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final products = snapshot.data!;
      final query = _query.trim().toLowerCase();
      final filtered = products.where((product) {
        final matchesQuery = query.isEmpty ||
            product.name.toLowerCase().contains(query) ||
            product.price.toString().contains(query) ||
            product.soluong.toString().contains(query);
        final matchesStock = switch (_stockFilter) {
          'available' => product.soluong > 0,
          'empty' => product.soluong == 0,
          _ => true,
        };
        return matchesQuery && matchesStock;
      }).toList();
      switch (_sortBy) {
        case 'price_asc':
          filtered.sort((a, b) => a.price.compareTo(b.price));
        case 'price_desc':
          filtered.sort((a, b) => b.price.compareTo(a.price));
        case 'quantity_desc':
          filtered.sort((a, b) => b.soluong.compareTo(a.soluong));
        default:
          filtered.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildPhone(products, filtered);
          }
          if (constraints.maxWidth < 1120) {
            return _buildTablet(products, filtered);
          }
          return _buildWeb(products, filtered);
        },
      );
    },
  );

  Widget _searchField() => TextField(
    controller: _search,
    readOnly: false,
    onChanged: (value) => setState(() => _query = value),
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      hintText: 'Tìm tên, giá hoặc số lượng',
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon: _query.isEmpty
          ? null
          : IconButton(
              tooltip: 'Xóa tìm kiếm',
              onPressed: () {
                _search.clear();
                setState(() => _query = '');
              },
              icon: const Icon(Icons.close_rounded),
            ),
    ),
  );

  Widget _filterControls() => Wrap(
    spacing: 8,
    runSpacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      ChoiceChip(
        avatar: const Icon(Icons.all_inclusive_rounded, size: 17),
        label: const Text('Tất cả'),
        selected: _stockFilter == 'all',
        onSelected: (_) => setState(() => _stockFilter = 'all'),
      ),
      ChoiceChip(
        avatar: const Icon(Icons.inventory_2_outlined, size: 17),
        label: const Text('Còn hàng'),
        selected: _stockFilter == 'available',
        onSelected: (_) => setState(() => _stockFilter = 'available'),
      ),
      ChoiceChip(
        avatar: const Icon(Icons.remove_shopping_cart_outlined, size: 17),
        label: const Text('Hết hàng'),
        selected: _stockFilter == 'empty',
        onSelected: (_) => setState(() => _stockFilter = 'empty'),
      ),
      SizedBox(
        width: 190,
        child: DropdownButtonFormField<String>(
          initialValue: _sortBy,
          isExpanded: true,
          decoration: const InputDecoration(
            isDense: true,
            prefixIcon: Icon(Icons.sort_rounded),
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
          items: const [
            DropdownMenuItem(value: 'name', child: Text('Tên A–Z')),
            DropdownMenuItem(value: 'price_asc', child: Text('Giá tăng dần')),
            DropdownMenuItem(value: 'price_desc', child: Text('Giá giảm dần')),
            DropdownMenuItem(
              value: 'quantity_desc',
              child: Text('Số lượng nhiều trước'),
            ),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _sortBy = value);
          },
        ),
      ),
      if (_hasActiveFilters)
        TextButton.icon(
          onPressed: () {
            _search.clear();
            setState(() {
              _query = '';
              _stockFilter = 'all';
              _sortBy = 'name';
            });
          },
          icon: const Icon(Icons.restart_alt_rounded, size: 18),
          label: const Text('Đặt lại'),
        ),
    ],
  );

  Widget _buildPhone(List<Product> products, List<Product> filtered) =>
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const BrandMark(title: 'ProductDesk'),
          actions: [
            IconButton(
              tooltip: 'Đăng xuất',
              onPressed: _auth.signOut,
              icon: const Icon(Icons.logout_rounded),
            ),
            const SizedBox(width: 5),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openForm(),
          icon: const Icon(Icons.add_box_rounded),
          label: const Text('Thêm sản phẩm'),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 17, 18, 14),
                child: PhoneWelcome(count: products.length),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: _searchField(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 4),
                child: _filterControls(),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyProducts(
                        searching: _hasActiveFilters,
                        onAdd: () => _openForm(),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) => ProductCard(
                          product: filtered[index],
                          onEdit: () => _openForm(filtered[index]),
                          onDelete: () => _confirmDelete(filtered[index]),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTablet(
    List<Product> products,
    List<Product> filtered,
  ) => Scaffold(
    body: SafeArea(
      child: Row(
        children: [
          NavigationPanel(compact: true, onSignOut: _auth.signOut),
          const VerticalDivider(width: 1, color: AppColors.line),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabletHeading(count: products.length),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: _searchField()),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: () => _openForm(),
                            icon: const Icon(Icons.add_box_rounded),
                            label: const Text('Thêm mới'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _filterControls(),
                    ],
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? EmptyProducts(
                          searching: _hasActiveFilters,
                          onAdd: () => _openForm(),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(28, 4, 28, 28),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                mainAxisExtent: 166,
                              ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) => ProductCard(
                            product: filtered[index],
                            onEdit: () => _openForm(filtered[index]),
                            onDelete: () => _confirmDelete(filtered[index]),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildWeb(List<Product> products, List<Product> filtered) => Scaffold(
    body: Row(
      children: [
        NavigationPanel(compact: false, onSignOut: _auth.signOut),
        Expanded(
          child: Column(
            children: [
              WebTopBar(count: products.length),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(38, 30, 38, 38),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1380),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Expanded(child: WebHeading()),
                              FilledButton.icon(
                                onPressed: () => _openForm(),
                                icon: const Icon(Icons.add_box_rounded),
                                label: const Text('Thêm sản phẩm'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          Card(
                            margin: EdgeInsets.zero,
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                              side: const BorderSide(color: AppColors.line),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Danh sách sản phẩm',
                                          style: TextStyle(
                                            color: AppColors.navy,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 360,
                                        child: _searchField(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  _filterControls(),
                                  const SizedBox(height: 18),
                                  if (filtered.isEmpty)
                                    SizedBox(
                                      height: 260,
                                      child: EmptyProducts(
                                        searching: _hasActiveFilters,
                                        onAdd: () => _openForm(),
                                      ),
                                    )
                                  else
                                    WebProductTable(
                                      products: filtered,
                                      onEdit: (product) => _openForm(product),
                                      onDelete: _confirmDelete,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
