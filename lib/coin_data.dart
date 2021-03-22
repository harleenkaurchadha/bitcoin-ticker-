import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'Enter your API keys';
const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {

  Future getCoinData(String currency) async{
    Map<String, String> cryptoPrice = { } ;
    for(String crypto in cryptoList) {
      String url = '$coinAPIURL/$crypto/$currency?apiKey=$apiKey';
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var lastPrice = data['rate'];
        cryptoPrice[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'problem with the get request';
      }
    }
    return cryptoPrice;
  }
}
