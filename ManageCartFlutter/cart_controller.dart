class CartController extends GetxController{

  ApiResponse<CartListModel>? cartData;
  var addOnQuantity=1.obs;
  final addOnIndex=Rxn<int>();
  var selectedTipPrice=Rxn<int>();
  var restaurantId=Rxn<int>();
  var address=''.obs;
  var couponCode=''.obs;
  var lat=''.obs;
  var lng=''.obs;
  bool mLoading=false;
  var isCartShow=false.obs;



  void isLoading(bool value){
    mLoading=value;
    update();
  }

  Future<ApiResponse<VendorDetailsModel>> addToCart(CartRequest request) async {
    var response = await locator<AppRepository>().addToCart(request);
    if (response.isSuccess()) {
      getCartList();
      return ApiResponse.success(response.data());
    } else {
      return ApiResponse.error(response.error());
    }
  }

  Future<ApiResponse<CartListModel>?> getCartList() async {
    String tip=selectedTipPrice.value==null?'0':selectedTipPrice.toString();
    print('LATLNG==>${lat.value} ${lng.value} $address ${tip}');
    final request = UserAddressRequest(offerCode:couponCode.value,tip: tip,address: address.toString(),latitude: lat.value.toString(),longitude: lng.value.toString());
    var response = await locator<AppRepository>().cartListing(request);
    if (response.isSuccess()) {
      cartData= ApiResponse.success(response.data());
    } else {
      cartData= ApiResponse.error(response.error());
    }
    update();
    return null;
  }

}
