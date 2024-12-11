import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ngdemo15/pages/upload_page.dart';

import '../models/cat_list_res.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<CatListRes> catList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiCatList();
  }

  _apiCatList() async{
    try {
      var response = await Network.GET(Network.API_CAT_LIST, Network.paramsCatList());
      setState(() {
        catList =  Network.parseCatList(response!);
        isLoading = false;
      });
      LogService.d(catList!.length.toString());
    } catch (e) {
      LogService.e(e.toString());
    }
  }

  Future<void> _handleRefresh() async {
    _apiCatList();
  }

  Future _callUploadPage() async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return const UploadPage();
    }));

    if (result) {
      _apiCatList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Cat List", style: TextStyle(fontSize: 45),),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              itemCount: catList.length,
              itemBuilder: (ctx, index) {
                return _itemOfCat(catList[index]);
              },
            ),
          ),
          isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _callUploadPage();
        },
      ),
    );
  }

  Widget _itemOfCat(CatListRes catListRes){
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: catListRes.url,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}