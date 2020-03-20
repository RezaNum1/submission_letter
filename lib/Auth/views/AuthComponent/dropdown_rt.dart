import 'package:flutter/material.dart';

class DropDownRT extends StatefulWidget {
  String rtText;
  Function(String) callBacks;
  bool validate;

  DropDownRT(this.rtText, this.callBacks, this.validate);
  @override
  _DropDownRTState createState() => _DropDownRTState();
}

class _DropDownRTState extends State<DropDownRT> {
  List<String> _rt = [
    'Pilih RT Anda',
    'RT 1',
    'RT 2',
    'RT 3',
    'RT 4',
    'RT 5',
    'RT 6',
    'RT 7',
    'RT 8'
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    widget.rtText = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> _items2 = new List();
    for (String city in _rt) {
      _items2.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return _items2;
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      widget.callBacks(selectedCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[100],
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Anda Merupakan Ketua RT: "),
          new DropdownButton(
            isExpanded: true,
            value: widget.rtText,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          ),
          (widget.validate == false
              ? Text("Anda Harus Memilih Salah Satu!",
                  style: TextStyle(color: Colors.red))
              : Container()),
        ],
      ),
    );
  }
}
