import 'package:flutter/material.dart';

class AppPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;

  const AppPagination({this.currentPage = 0, this.totalPages = 1, this.onPageChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: currentPage > 0 ? () => onPageChanged?.call(currentPage - 1) : null,
        ),
        Text('${currentPage + 1} / $totalPages'),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages - 1 ? () => onPageChanged?.call(currentPage + 1) : null,
        ),
      ],
    );
  }
}
