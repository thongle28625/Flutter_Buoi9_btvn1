import 'package:flutter/material.dart';
import '../../controllers/expense_controller.dart';
import '../../models/expense.dart';

class ChiTieuScreen extends StatefulWidget {
  const ChiTieuScreen({super.key});

  @override
  State<ChiTieuScreen> createState() => _ChiTieuScreenState();
}

class _ChiTieuScreenState extends State<ChiTieuScreen> {
  List<ChiTieu> _list = [];
  double _tong = 0;
  final _controller = ChiTieuController();

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final data = await _controller.fetchAll();
    final tong = await _controller.tongChiTieu();
    setState(() {
      _list = data;
      _tong = tong;
    });
  }

  void _showDialog({ChiTieu? item}) {
    final noiDungCtrl =
    TextEditingController(text: item?.noiDung ?? '');
    final soTienCtrl =
    TextEditingController(text: item?.soTien.toString() ?? '');
    final ghiChuCtrl = TextEditingController(text: item?.ghiChu ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item == null ? 'Thêm Chi Tiêu' : 'Cập nhật Chi Tiêu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: noiDungCtrl,
              decoration:
              const InputDecoration(labelText: 'Nội dung chi tiêu'),
            ),
            TextField(
              controller: soTienCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Số tiền (VNĐ)'),
            ),
            TextField(
              controller: ghiChuCtrl,
              decoration: const InputDecoration(labelText: 'Ghi chú'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final noiDung = noiDungCtrl.text.trim();
              final soTien = double.tryParse(soTienCtrl.text.trim()) ?? 0;
              if (noiDung.isEmpty || soTien <= 0) return;

              if (item == null) {
                await _controller.insert(ChiTieu(
                  noiDung: noiDung,
                  soTien: soTien,
                  ghiChu: ghiChuCtrl.text.trim(),
                ));
              } else {
                await _controller.update(ChiTieu(
                  id: item.id,
                  noiDung: noiDung,
                  soTien: soTien,
                  ghiChu: ghiChuCtrl.text.trim(),
                ));
              }
              if (ctx.mounted) Navigator.pop(ctx);
              _fetch();
            },
            child: Text(item == null ? 'Thêm' : 'Cập nhật'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(int id) async {
    await _controller.delete(id);
    _fetch();
  }

  String _formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Chi Tiêu'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.orange[50],
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Tổng chi tiêu',
                    style: TextStyle(color: Colors.grey)),
                Text(
                  _formatMoney(_tong),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _list.isEmpty
                ? const Center(child: Text('Chưa có khoản chi tiêu nào.'))
                : ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                final item = _list[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFFFE0B2),
                      child: Icon(Icons.receipt_long,
                          color: Colors.orange),
                    ),
                    title: Text(item.noiDung,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    subtitle: item.ghiChu.isNotEmpty
                        ? Text(item.ghiChu)
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatMoney(item.soTien),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.blue, size: 20),
                          onPressed: () => _showDialog(item: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red, size: 20),
                          onPressed: () => _delete(item.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}