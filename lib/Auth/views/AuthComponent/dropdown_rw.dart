import 'package:flutter/material.dart';

class DropDownRW extends StatefulWidget {
  String _rwText;
  Function(String) _callBack;
  bool _validate;

  DropDownRW(this._rwText, this._callBack, this._validate);
  @override
  _DropDownRWState createState() => _DropDownRWState();
}

class _DropDownRWState extends State<DropDownRW> {
  List<String> _rw = [
    'Pilih RW Anda',
    'RW 1',
    'RW 2',
    'RW 3',
    'RW 4',
    'RW 5',
    'RW 6',
    'RW 7',
    'RW 8'
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItemss;

  @override
  void initState() {
    _dropDownMenuItemss = getDropDownMenuItems();
    widget._rwText = _dropDownMenuItemss[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> _items1 = new List();
    for (String city in _rw) {
      _items1.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return _items1;
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      widget._callBack(selectedCity);
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
          new Text("Anda Merupakan Ketua RW: "),
          new DropdownButton(
            isExpanded: false,
            value: widget._rwText,
            items: _dropDownMenuItemss,
            onChanged: changedDropDownItem,
          ),
          (widget._validate == false
              ? Text("Anda Harus Memilih Salah Satu!",
                  style: TextStyle(color: Colors.red))
              : Text("Jika Mendaftar Sebagai RW, Kosongkan Kolom RT",
                  style: TextStyle(color: Colors.red, fontSize: 13))),
        ],
      ),
    );
  }
}
