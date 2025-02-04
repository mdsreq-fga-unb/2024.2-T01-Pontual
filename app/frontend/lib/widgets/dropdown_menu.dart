import 'package:flutter/material.dart';

class DropdownMenuCustom extends StatefulWidget {
  final List<String> list;
  final ValueChanged<String?> onChanged;

  const DropdownMenuCustom(
      {super.key, required this.list, required this.onChanged});

  @override
  State<DropdownMenuCustom> createState() => _DropdownMenuCustomState();
}

class _DropdownMenuCustomState extends State<DropdownMenuCustom> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.list.isNotEmpty ? widget.list.first : "";
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue.isNotEmpty ? dropdownValue : null,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Color(0xFF060606)),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
        widget.onChanged(value);
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
