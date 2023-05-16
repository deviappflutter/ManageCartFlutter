
// Top most widget of this page
class QuantityAndCustomizeOrderWidget extends StatelessWidget {
  final Data data;
  int index;
  num restaurantId;

  QuantityAndCustomizeOrderWidget(
    this.data,
    this.index,
    this.restaurantId, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cartController = Get.find<CartController>();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16.h,
            width: 16.w,
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
                border:
                    Border.all(width: 1, color: AbsColors.smallSelectBoxColor),
                borderRadius: BorderRadius.circular(6.r)),
            child: CircleAvatar(
                radius: 10.r, backgroundColor: AbsColors.smallSelectBoxColor),
          ),
          AddSpace.horizontal(12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.foodItemName.toString(),
                style: AbsTextStyle.boldLargeTitle.copyWith(fontSize: 16.sp),
              ),
              AddSpace.vertical(3.w),
              data.foodAddons!.isNotEmpty
                  ? RichText(
                      text: TextSpan(
                          style: AbsTextStyle.base.copyWith(
                              fontSize: 12.54.sp,
                              fontWeight: FontWeight.w400,
                              color: AbsColors.smallTextColor),
                          text: '',
                          children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('object ${ cartController.cartData?.data().data?[index].foodQuantity}');
                                    cartController.restaurantId.value =
                                        restaurantId.toInt();
                                    showBarModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.r),
                                          topRight: Radius.circular(10.r),
                                        )),
                                        topControl: Container(),
                                        barrierColor: const Color(0xff0A0A0A)
                                            .withOpacity(0.30),
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) =>
                                            CustomizeOrderPage(
                                                data.foodId.toString(),
                                                data.foodItemName.toString(),
                                                data.foodSubTotalPrice
                                                    .toString(),
                                             
                                                cartController.cartData!.data().data![index].foodQuantity.toString()
                                            ));
                                  },
                                style: AbsTextStyle.base.copyWith(
                                    fontSize: 12.54.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AbsColors.blackColor),
                                text: '${AppString.customize} '),
                            const WidgetSpan(
                                child: Icon(Icons.keyboard_arrow_down_sharp,
                                    size: 15)),
                          ]),
                    )
                  : AddSpace.vertical(7.h),
              AddSpace.vertical(9.w),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      addCart(data, restaurantId, context, cartController, 0);
                    },
                    child: Text(
                      AppString.delete,
                      style: AbsTextStyle.boldLargeTitle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AbsColors.selectColor),
                    ),
                  ),
                  SizedBox(width: 25.w),
                  Text(
                    AppString.price,
                    style: AbsTextStyle.boldLargeTitle.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AbsColors.mediumBoldTextColor),
                  ),

                ],
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              quantityWidget(
                  index, data, cartController, restaurantId, context),
             
              AddSpace.vertical(12.h),
              Text(
                '\$${data.foodSubTotalPrice.toString()}',
                style: AbsTextStyle.boldLargeTitle.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AbsColors.mediumBoldTextColor),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget quantityWidget(int index, Data data, CartController cartController,
      num restaurantId, BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 25.h,
        width: 80.w,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: AbsColors.selectColor),
            color: AbsColors.selectColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r)),
        child:
            addOnQuantity(cartController, index, data, restaurantId, context));
  }

  Widget addOnQuantity(CartController cartController, int index, Data data,
      num restaurantId, BuildContext context) {
    int quantity = data.foodQuantity!.toInt();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () {
              cartController.addOnIndex.value = index;
              if (quantity > 1) {
                quantity--;
                cartController.addOnQuantity.value = quantity;
                addCart(data, restaurantId, context, cartController, quantity);
              } else {
                addCart(data, restaurantId, context, cartController, 0);
              }
            },
            child: const Icon(Icons.remove,
                color: AbsColors.selectColor, size: 20)),
        AddSpace.horizontal(10.75.w),
       
        text(
            cartController.addOnIndex.value == index
                ? cartController.addOnQuantity.value.toString()
                : quantity.toString(),
            AbsTextStyle.boldBody.copyWith(fontSize: 14.sp)),
        AddSpace.horizontal(10.75.w),
        GestureDetector(
            onTap: () {
              if(quantity>=data.foodInventory!.toInt()){
                AbsIndicators.showErrorIndicator(context, 'No More Quantity');
              }else{
                cartController.addOnIndex.value = index;
                quantity++;
                cartController.addOnQuantity.value = quantity;
                addCart(data, restaurantId, context, cartController, quantity);
              }
            },
            child: const Icon(
              Icons.add,
              color: AbsColors.selectColor,
              size: 20,
            ))
      ],
    );
  }

  Text? txt;

  Widget text(text, style) {
    txt = Text(text, style: style);
    return txt!;
  }

  addCart(Data data, num restaurantId, BuildContext context,
      CartController cartController, int quantity) {
    var request = CartRequest(
        restaurantId: restaurantId.toString(),
        foodId: data.foodId.toString(),
        foodQuantity: quantity.toString(),
        foodAddonsIds: '',
        foodAddonsQuantities: '');
    cartController.addToCart(request).then((response) {
      if (response.isSuccess()) {
      
      } else {
        AbsIndicators.showErrorIndicator(context, response.error());
      }
    });
  }
}

