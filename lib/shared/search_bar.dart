import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final Function(int)? setCategoryFilter;
  final String hintText;

  const CustomSearchBar({
    Key? key,
    required this.onChanged,
    required this.hintText,
    this.setCategoryFilter,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final controller = TextEditingController();
  int? selectedRadio = 0;

  _displayDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8.0),
                  const Text(
                    'Filtrar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    children: [
                      Radio<int>(
                        value: 0,
                        groupValue: selectedRadio,
                        onChanged: (int? value) {
                          setState(() => selectedRadio = value);
                        },
                      ),
                      const Text('Todos'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: selectedRadio,
                        onChanged: (int? value) {
                          setState(() => selectedRadio = value);
                        },
                      ),
                      const Text('Restaurantes'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 2,
                        groupValue: selectedRadio,
                        onChanged: (int? value) {
                          setState(() => selectedRadio = value);
                        },
                      ),
                      const Text('Supermercados'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 3,
                        groupValue: selectedRadio,
                        onChanged: (int? value) {
                          setState(() => selectedRadio = value);
                        },
                      ),
                      const Text('Cafeterías'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 4,
                        groupValue: selectedRadio,
                        onChanged: (int? value) {
                          setState(() => selectedRadio = value);
                        },
                      ),
                      const Text('Ferreterías'),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: const Border(
            bottom: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.080,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: Colors.blue),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Colors.grey[600]),
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: MediaQuery.of(context).size.height,
                        child: Icon(
                            Icons.close,
                            color: Colors.grey[600]
                        )
                    ),
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      controller.clear();
                      widget.onChanged('');
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  if (widget.setCategoryFilter != null) ...[
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.only(left: 8.0),
                        height: MediaQuery.of(context).size.height,
                        child: Icon(
                          Icons.filter_list,
                          color: Colors.grey[600],
                        ),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        await _displayDialog(context);
                        widget.setCategoryFilter!(selectedRadio!);
                      },
                    ),
                  ]
                ],
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
            ),
            onChanged:  widget.onChanged,
          ),
        ),
      ),
    );
  }
}