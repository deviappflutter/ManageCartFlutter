class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartController cartController;
  late HomeController homeController;
  bool isCart=false;

  @override
  void initState() {
    isCart=Get.arguments ?? false;
    cartController = Get.put(CartController());
    homeController = Get.find<HomeController>();
    var address = homeController.selectedAddress.value.isEmpty
        ? homeController.mainAddress
        : homeController.selectedAddress.value;
    cartController.lat.value=homeController.latitude.toString();
    cartController.lng.value=homeController.longitude.toString();
    cartController.address.value = address;
    cartController.selectedTipPrice.value = null;
    cartController.getCartList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 15.w),
            child: GetBuilder<CartController>(builder: (controller) {
              var cartData = cartController.cartData?.data();
              if (cartData == null) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: AbsColors.selectColor,
                    )));
              }
              if (cartData.data!.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     isCart?
                     Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 40.h),
                        child: SizedBox(
                          width: 100,
                          child: InkWell(
                            
                              onTap: () {
                                Get.back(
                                    result: true);
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    IconsSvg.back,
                                    height: 17.63.h,
                                    width: 9.93.w,
                                  ),
                                  AddSpace.horizontal(7.53.w),
                                  Text(AppString.back,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp,
                                          color: AbsColors.selectColor)),
                                ],
                              )),
                        ),
                      ):Container(),
                      Expanded(
                        flex: 9,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: SizedBox.fromSize(
                                      size: const Size.fromRadius(100),
                                      child: Image.asset(ImagePng.emptyCart,
                                          width: 100.w, height: 100.h))),
                              AddSpace.vertical(20.h),
                              Text(AppString.cartEmpty,
                                  style: AbsTextStyle.base.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.sp,
                                    color: Colors.black,
                                  )),
                              AddSpace.vertical(10.h),
                              Text(
                                  AppString.cartEmptyDescription,
                                  textAlign: TextAlign.center,
                                  style: AbsTextStyle.base.copyWith(
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                    letterSpacing: 0.5,
                                    fontSize: 15.sp,
                                    color: AbsColors.lightGreyColor,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              var arguments = OrderPlaceArguments(
                  offerCode: cartController.couponCode.value,
                  totalPrice: cartData.total.toString(),
                  address: txtAddress?.text.toString(),
                  lat: cartController.lat.value,
                  lng: cartController.lng.value);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  isCart?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        
                          onTap: () {
                           Get.back(result: true);
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                IconsSvg.back,
                                height: 17.63.h,
                                width: 9.93.w,
                              ),
                              AddSpace.horizontal(7.53.w),
                              Text(AppString.back,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.sp,
                                      color: AbsColors.selectColor)),
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppString.cart,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28.sp,
                                  color: AbsColors.boldTextBlackColor)),
                          MaterialButton(
                              height: 26.h,
                              minWidth: 84.w,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.r)),
                              padding: EdgeInsets.zero,
                              color: AbsColors.selectColor,
                              onPressed: () {
                                Get.toNamed("/paymentScreen", arguments: arguments);
                              },
                              child: Text(AppString.checkOutOnly,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      color: AbsColors.whiteColor)))
                        ],
                      ),
                    ],
                  ):
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 3.w),
                        child: Text(AppString.mainAppTitle,
                            style: AbsTextStyle.base.copyWith(
                                fontSize: 11.sp,
                                color: AbsColors.textGreyColor,
                                fontWeight: FontWeight.w500)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(cartData.restaurantName.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28.sp,
                                  color: AbsColors.boldTextBlackColor)),
                          MaterialButton(
                              height: 26.h,
                              minWidth: 84.w,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.r)),
                              padding: EdgeInsets.zero,
                              color: AbsColors.selectColor,
                              onPressed: () {
                                Get.toNamed("/paymentScreen", arguments: arguments);
                              },
                              child: Text(AppString.checkOutOnly,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      color: AbsColors.whiteColor)))
                        ],
                      ),
                    ],
                  ),
                  AddSpace.vertical(10.h),
                  Obx(() {
                    return Container(
                      padding: EdgeInsets.only(
                          left: 12.w, right: 19.w, top: 12.h, bottom: 12.h),
                      decoration: BoxDecoration(
                          color: AbsColors.lightBoxColor,
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  color: AbsColors.selectColor),
                              AddSpace.horizontal(10.w),
                              SizedBox(
                                width: 200.w,
                                child: RichText(
                                  text: TextSpan(
                                      text: AppString.deliveredTo,
                                      style: AbsTextStyle.base.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp,
                                          color: const Color(0xff484648)),
                                      children: [
                                       
                                        textAddress(
                                            homeController
                                                    .selectedAddress.value.isEmpty
                                                ? homeController.mainAddress
                                                : homeController
                                                    .selectedAddress.value,
                                            AbsTextStyle.base.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.sp,
                                                color: const Color(0xff484648)))
                                       
                                      ]),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              showBarModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.r),
                                    topRight: Radius.circular(10.r),
                                  )),
                                  topControl: Container(),
                                  barrierColor:
                                      const Color(0xff0A0A0A).withOpacity(0.30),
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => AddressScreen('cart'));
                            },
                            child: Text(
                              AppString.change,
                              style: AbsTextStyle.base.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  color: AbsColors.selectColor),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                  AddSpace.vertical(13.h),
                  Container(
                    width: 346.w,
                    padding: EdgeInsets.only(
                        top: 15.h, left: 20.w, right: 15.w, bottom: 15.h),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AbsColors.smallTextColor.withOpacity(0.4),
                            spreadRadius: 0.4,
                            blurRadius: 3,
                          )
                        ],
                        color: AbsColors.whiteColor,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                       
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: cartData.data?.length,
                            itemBuilder: (context, index) {
                              return QuantityAndCustomizeOrderWidget(
                                  cartData.data![index],
                                  index,
                                  cartData.restaurantId!);
                            }),
                      ],
                    ),
                  ),
                  AddSpace.vertical(20.h),
                  Text(
                    AppString.offerAndBenefits,
                    style: AbsTextStyle.boldLargeTitle.copyWith(fontSize: 13.sp),
                  ),
                  AddSpace.vertical(12.h),
                  ApplyCouponsWidget(cartData,controller),
                  AddSpace.vertical(20.h),
                  Text(
                    AppString.tipYourDeliveryPartner,
                    style: AbsTextStyle.boldLargeTitle.copyWith(fontSize: 13.sp),
                  ),
                  AddSpace.vertical(16.h),
                  TipYourDeliveryWidget(),
                  AddSpace.vertical(20.h),
                  Row(
                    children: [
                      Text(
                        AppString.billSummery,
                        style:
                            AbsTextStyle.boldLargeTitle.copyWith(fontSize: 13.sp),
                      ),
                     
                    ],
                  ),
                  AddSpace.vertical(12.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AbsColors.smallTextColor.withOpacity(0.4),
                            spreadRadius: 0.4,
                            blurRadius: 3,
                          )
                        ],
                        color: AbsColors.whiteColor,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Column(
                      children: [
                        cartData.discount!>0?Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${AppString.coupon} (${controller.couponCode.value})",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: AbsColors.selectColor),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${AppString.saved} \$${cartData.discount.toString()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.54.sp,
                                      color: AbsColors.blackColor),
                                ),
                                SizedBox(height:5.h),
                                GestureDetector(
                                  onTap: (){
                                    controller.couponCode.value='';
                                    controller.getCartList();
                                  },
                                  child: Text(
                                    AppString.remove,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.54.sp,
                                        color: AbsColors.selectColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ):Container(),
                        AddSpace.vertical(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppString.itemPrice,
                              style: AbsTextStyle.base.copyWith(
                                  fontSize: 14.sp,
                                  color: AbsColors.mediumBoldTextColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '\$${cartData.subTotal.toString()}',
                              style: AbsTextStyle.base.copyWith(
                                  fontSize: 14.sp,
                                  color: AbsColors.mediumBoldTextColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        AddSpace.vertical(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppString.deliveryCharges,
                              style: AbsTextStyle.base.copyWith(
                                  fontSize: 12.sp,
                                  color: AbsColors.greyLightBasic,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '\$${cartData.deliveryCharges.toString()}',
                              style: AbsTextStyle.base.copyWith(
                                  fontSize: 12.sp,
                                  color: AbsColors.greyLightBasic,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        AddSpace.vertical(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppString.vendorTax,
                              style: AbsTextStyle.base.copyWith(
                                  fontSize: 12.sp,
                                  color: AbsColors.greyLightBasic,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '\$${cartData.vendorTax.toString()}',
                              style: AbsTextStyle.base.copyWith(
                                  fontSize: 12.sp,
                                  color: AbsColors.greyLightBasic,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        AddSpace.vertical(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppString.gst,
                              style: AbsTextStyle.base.copyWith(
                                  fontSize: 12.sp,
                                  color: AbsColors.greyLightBasic,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '\$${cartData.gst.toString()}',
                              style: AbsTextStyle.base.copyWith(
                                  fontSize: 12.sp,
                                  color: AbsColors.greyLightBasic,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        AddSpace.vertical(10.h),
                        Divider(
                          height: 1.h,
                          color: AbsColors.greyLightBasic,
                          thickness: 0.5,
                        ),
                        AddSpace.vertical(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppString.grandTotal,
                              style: AbsTextStyle.boldLargeTitle
                                  .copyWith(fontSize: 16.sp),
                            ),
                            Text(
                              '\$${cartData.total.toString()}',
                              style: AbsTextStyle.boldLargeTitle
                                  .copyWith(fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // AddSpace.vertical(15.h),
                  AbsButton(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                    onPressed: () {
                      Get.toNamed("/paymentScreen", arguments: arguments);
                    },
                    title: '${AppString.checkOutOnly} \$${cartData.total.toString()}',
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Get.back(result: true);
    return Future.value(false);
  }

  TextSpan? txtAddress;

  TextSpan textAddress(text, style) {
    txtAddress = TextSpan(text: text, style: style);
    return txtAddress!;
  }

  @override
  void dispose() {
    cartController.addOnIndex.value = null;
    super.dispose();
  }
}



