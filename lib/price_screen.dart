import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurr = 'AUD';
  String value = '?';
  Map<String, String> coinValues ={};
  bool isWaiting = false;

  void getCoinRate() async{
    CoinData coinData = CoinData();
    try{
      isWaiting = true;
      var rate = await coinData.getCoinData(selectedCurr);
      isWaiting = false;
      setState(() {
        coinValues = rate;
      });
    } catch (e){
      print(e);
    }
  }

  CupertinoPicker iosPicker() {
    List<Widget> pickerItems = [];
    for(String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }
     return CupertinoPicker(
      itemExtent: 35,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (selectedIndex){
        setState(() {
          selectedCurr = currenciesList[selectedIndex];
         });
        getCoinRate();
        },
      children: pickerItems,
    );
  }

  DropdownButton<String> androidPicker() {
    List<DropdownMenuItem<String>> androidPicker = [];
    for(String currency in currenciesList){
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      androidPicker.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurr,
      items: androidPicker,
      onChanged: (newValue){
      setState(() {
      selectedCurr = newValue.toString();
       });
      getCoinRate();
      },
    );
  }

  @override
  void initState() {
    getCoinRate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          ListView.builder(
            shrinkWrap: true,                            //so that listView placed inside column does not take the entire available space
            itemCount: cryptoList.length,
              itemBuilder: (ctx, index) {
               String cryptoCurr = cryptoList[index];
               String value = isWaiting ? '?' : coinValues[cryptoCurr];
                return Padding(
                          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                          child: Card(
                            color: Colors.lightBlueAccent,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                              child: Text(
                             '1 $cryptoCurr =  $value $selectedCurr',
                            textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
              },
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidPicker(),
          ),
        ],
      ),
    );
  }
}
