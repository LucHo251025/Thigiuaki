import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../data/product.dart';

class PhoneWelcome extends StatelessWidget {
  const PhoneWelcome({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF4567E8), Color(0xFF738AF0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: AppColors.blue.withValues(alpha: .18),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KHÔNG GIAN QUẢN TRỊ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Xin chào, Admin 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Quản lý danh mục sản phẩm tại đây',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .16),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'sản phẩm',
                style: TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class TabletHeading extends StatelessWidget {
  const TabletHeading({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'QUẢN TRỊ HỆ THỐNG',
        style: TextStyle(
          color: AppColors.blue,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        'Sản phẩm',
        style: TextStyle(
          color: AppColors.navy,
          fontSize: 27,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        '$count sản phẩm trong Firestore',
        style: const TextStyle(color: AppColors.muted, fontSize: 12),
      ),
    ],
  );
}

class WebHeading extends StatelessWidget {
  const WebHeading({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'TỔNG QUAN',
        style: TextStyle(
          color: AppColors.blue,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
      SizedBox(height: 7),
      Text(
        'Quản lý sản phẩm',
        style: TextStyle(
          color: AppColors.navy,
          fontSize: 30,
          fontWeight: FontWeight.w800,
        ),
      ),
      SizedBox(height: 5),
      Text(
        'Theo dõi và cập nhật thông tin sản phẩm.',
        style: TextStyle(color: AppColors.muted),
      ),
    ],
  );
}

class NavigationPanel extends StatelessWidget {
  const NavigationPanel({
    super.key,
    required this.compact,
    required this.onSignOut,
  });
  final bool compact;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        width: 78,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.inventory_2_rounded, color: Colors.white),
            ),
            const SizedBox(height: 38),
            const _RailItem(
              icon: Icons.space_dashboard_rounded,
              selected: true,
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Đăng xuất',
              onPressed: onSignOut,
              icon: const Icon(Icons.logout_rounded, color: AppColors.muted),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 252,
      color: AppColors.navy,
      padding: const EdgeInsets.fromLTRB(20, 25, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.inventory_2_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 11),
              const Text(
                'ProductDesk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 42),
          const Text(
            'MENU',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          const _WebNavItem(
            icon: Icons.space_dashboard_outlined,
            label: 'Tổng quan',
            selected: true,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF8799F4),
                  child: Icon(
                    Icons.admin_panel_settings_rounded,
                    size: 19,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quản trị viên',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Đang hoạt động',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onSignOut,
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Đăng xuất'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({required this.icon, required this.selected});
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(
      color: selected
          ? AppColors.blue.withValues(alpha: .11)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Icon(icon, color: selected ? AppColors.blue : AppColors.muted),
  );
}

class _WebNavItem extends StatelessWidget {
  const _WebNavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });
  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
    decoration: BoxDecoration(
      color: selected
          ? Colors.white.withValues(alpha: .12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      children: [
        Icon(icon, size: 19, color: selected ? Colors.white : Colors.white60),
        const SizedBox(width: 11),
        Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white60,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class WebTopBar extends StatelessWidget {
  const WebTopBar({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) => Container(
    height: 76,
    padding: const EdgeInsets.symmetric(horizontal: 38),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: AppColors.line)),
    ),
    child: Row(
      children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              const CircleAvatar(radius: 4, backgroundColor: Color(0xFF22A06B)),
              const SizedBox(width: 7),
              Text(
                '$count sản phẩm',
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        const CircleAvatar(
          radius: 19,
          backgroundColor: Color(0xFFE9EDFF),
          child: Icon(Icons.person_rounded, color: AppColors.blue, size: 20),
        ),
      ],
    ),
  );
}

class WebProductTable extends StatelessWidget {
  const WebProductTable({
    super.key,
    required this.products,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Product> products;
  final ValueChanged<Product> onEdit;
  final ValueChanged<Product> onDelete;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      // Rows in the table use Expanded, so the horizontal scroll child
      // must have a finite width before it can lay out its columns.
      final tableWidth = constraints.maxWidth < 850
          ? 850.0
          : constraints.maxWidth;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: tableWidth,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F8FC),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _TableHeading('SẢN PHẨM')),
                      Expanded(flex: 2, child: _TableHeading('GIÁ (₫)')),
                      Expanded(flex: 2, child: _TableHeading('SỐ LƯỢNG')),
                      SizedBox(width: 104, child: _TableHeading('THAO TÁC')),
                    ],
                  ),
                ),
                for (var index = 0; index < products.length; index++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              ProductImage(
                                product: products[index],
                                radius: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  products[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.sell_outlined,
                                size: 17,
                                color: AppColors.muted,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${products[index].price.toStringAsFixed(0)} ₫',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF475467),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            products[index].soluong.toString(),
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 15,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 104,
                          child: Row(
                            children: [
                              IconButton.filledTonal(
                                tooltip: 'Chỉnh sửa',
                                onPressed: () => onEdit(products[index]),
                                style: IconButton.styleFrom(
                                  foregroundColor: AppColors.blue,
                                  backgroundColor: const Color(0xFFEEF1FF),
                                  fixedSize: const Size(38, 38),
                                ),
                                icon: const Icon(Icons.edit_outlined, size: 18),
                              ),
                              const SizedBox(width: 7),
                              IconButton.filledTonal(
                                tooltip: 'Xóa',
                                onPressed: () => onDelete(products[index]),
                                style: IconButton.styleFrom(
                                  foregroundColor: const Color(0xFFD64545),
                                  backgroundColor: const Color(0xFFFFEEEE),
                                  fixedSize: const Size(38, 38),
                                ),
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index != products.length - 1)
                    const Divider(
                      height: 1,
                      indent: 18,
                      endIndent: 18,
                      color: AppColors.line,
                    ),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _TableHeading extends StatelessWidget {
  const _TableHeading(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(
      color: AppColors.muted,
      fontSize: 10,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.1,
    ),
  );
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: AppColors.line),
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(14, 13, 9, 12),
      child: Row(
        children: [
          ProductImage(product: product, radius: 27),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.sell_outlined,
                      size: 15,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Giá: ${product.price.toStringAsFixed(0)} ₫',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 15,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Số lượng: ${product.soluong}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Tùy chọn sản phẩm',
            onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Chỉnh sửa'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFD64545),
                  ),
                  title: Text('Xóa sản phẩm'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.product, this.radius = 28});

  final Product product;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final bytes = _decodeImage(product.image);
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFE9EDFF),
      backgroundImage: bytes == null ? null : MemoryImage(bytes),
      child: bytes == null
          ? Text(
              product.name.isEmpty ? '?' : product.name[0].toUpperCase(),
              style: const TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}

class EmptyProducts extends StatelessWidget {
  const EmptyProducts({
    super.key,
    required this.searching,
    required this.onAdd,
  });

  final bool searching;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              searching ? Icons.search_off_rounded : Icons.group_outlined,
              color: AppColors.blue,
              size: 38,
            ),
          ),
          const SizedBox(height: 17),
          Text(
            searching ? 'Không tìm thấy sản phẩm' : 'Chưa có sản phẩm nào',
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            searching
                ? 'Thử tìm bằng tên sản phẩm khác.'
                : 'Thêm sản phẩm đầu tiên để bắt đầu quản lý.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted),
          ),
          if (!searching) ...[
            const SizedBox(height: 17),
            OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_box_rounded),
              label: const Text('Thêm sản phẩm'),
            ),
          ],
        ],
      ),
    ),
  );
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.title = 'ProductDesk'});
  final String title;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.inventory_2_rounded, color: Colors.white),
      ),
      const SizedBox(width: 11),
      Text(
        title,
        style: TextStyle(
          color: AppColors.navy,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

Uint8List? _decodeImage(String value) {
  if (value.isEmpty) return null;
  try {
    return base64Decode(value);
  } on FormatException {
    return null;
  }
}
