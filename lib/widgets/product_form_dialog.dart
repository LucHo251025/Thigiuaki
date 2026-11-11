import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../app_colors.dart';
import '../data/product.dart';
import '../data/product_repository.dart';
import 'feedback_widgets.dart';

class ProductFormDialog extends StatefulWidget {
  const ProductFormDialog({super.key, this.product});

  final Product? product;

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final ProductRepository _repository = ProductRepository();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _soluong;
  String _image = '';
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.product?.name ?? '');
    _price = TextEditingController(
      text: widget.product == null ? '' : _formatNumber(widget.product!.price),
    );
    _soluong = TextEditingController(
      text: widget.product?.soluong.toString() ?? '',
    );
    _image = widget.product?.image ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _soluong.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 900,
        maxHeight: 900,
        imageQuality: 65,
      );
      if (file == null) return;
      final decoded = img.decodeImage(await file.readAsBytes());
      if (decoded == null) throw Exception('Không đọc được ảnh đã chọn.');
      final resized = img.copyResize(
        decoded,
        width: decoded.width > 320 ? 320 : decoded.width,
      );
      final encoded = base64Encode(img.encodeJpg(resized, quality: 45));
      if (encoded.length > 700000) {
        throw Exception('Ảnh quá lớn, vui lòng chọn ảnh nhỏ hơn.');
      }
      if (!mounted) return;
      setState(() {
        _image = encoded;
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = 'Không chọn được ảnh: $e');
    }
  }

  Future<void> _save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final price = double.parse(_price.text.trim().replaceAll(',', '.'));
      final quantity = int.parse(_soluong.text.trim());
      await _repository.save(
        Product(
          id: widget.product?.id ?? '',
          name: _name.text,
          price: price,
          soluong: quantity,
          image: _image,
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => _error = 'Không lưu được sản phẩm: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.product != null;
    final bytes = _decode(_image);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 740),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  editing ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm',
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Nhập tên, giá, số lượng và ảnh sản phẩm.',
                  style: TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9EDFF),
                          borderRadius: BorderRadius.circular(14),
                          image: bytes == null
                              ? null
                              : DecorationImage(
                                  image: MemoryImage(bytes),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: bytes == null
                            ? const Icon(
                                Icons.inventory_2_outlined,
                                color: AppColors.blue,
                                size: 34,
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hình ảnh sản phẩm',
                              style: TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Ảnh nén được lưu trong trường image.',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _busy ? null : _pickImage,
                              icon: const Icon(Icons.add_photo_alternate),
                              label: Text(
                                bytes == null ? 'Chọn ảnh' : 'Đổi ảnh',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: _name,
                  enabled: !_busy,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Tên sản phẩm',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Vui lòng nhập tên sản phẩm'
                      : null,
                ),
                const SizedBox(height: 13),
                TextFormField(
                  controller: _price,
                  enabled: !_busy,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Giá',
                    prefixIcon: Icon(Icons.sell_outlined),
                    suffixText: '₫',
                  ),
                  validator: (value) {
                    final number = double.tryParse(
                      (value ?? '').trim().replaceAll(',', '.'),
                    );
                    return number == null || number < 0
                        ? 'Nhập giá là số không âm'
                        : null;
                  },
                ),
                const SizedBox(height: 13),
                TextFormField(
                  controller: _soluong,
                  enabled: !_busy,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Số lượng',
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                  ),
                  validator: (value) {
                    final number = int.tryParse((value ?? '').trim());
                    return number == null || number < 0
                        ? 'Nhập số lượng là số nguyên không âm'
                        : null;
                  },
                  onFieldSubmitted: (_) => _save(),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 13),
                  ErrorBanner(message: _error!),
                ],
                const SizedBox(height: 19),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _busy
                            ? null
                            : () => Navigator.pop(context, false),
                        child: const Text('Hủy'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _busy ? null : _save,
                        icon: _busy
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(_busy ? 'Đang lưu…' : 'Lưu sản phẩm'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatNumber(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toString();

Uint8List? _decode(String value) {
  if (value.isEmpty) return null;
  try {
    return base64Decode(value);
  } on FormatException {
    return null;
  }
}
