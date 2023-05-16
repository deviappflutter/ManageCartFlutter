class TipYourDeliveryWidget extends StatelessWidget {
  TipYourDeliveryWidget({
    Key? key,
  }) : super(key: key);

  var controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        tipPrice('😔', '10'),
        tipPrice('😊', '20'),
        tipPrice('😁', '30', true),
        tipPrice('🥳', '50'),
      ],
    );
  }

  Widget tipPrice(String emoji, String price, [bool isMostTiped = false]) {
    return GestureDetector(onTap: () {
      if (controller.selectedTipPrice.value == int.parse(price)) {
        controller.selectedTipPrice.value = null;
      } else {
        controller.selectedTipPrice.value = int.parse(price);
      }
      controller.getCartList();
    }, child: Obx(() {
      return Container(
        // height: 60.h,
        width: 48.w,
        padding: isMostTiped
            ? EdgeInsets.only(top: 0.h, bottom: 5.h)
            : EdgeInsets.only(top: 7.h, bottom: 5.h),
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: controller.selectedTipPrice.value == int.parse(price)
                    ? AbsColors.selectColor
                    : AbsColors.smallTextColor.withOpacity(0.4),
                spreadRadius: 0.4,
                blurRadius: 3,
              )
            ],
            color: AbsColors.whiteColor,
            borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isMostTiped
                ? Container(
                    height: 9.h,
                    decoration: BoxDecoration(
                        color: AbsColors.selectColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.r),
                            topRight: Radius.circular(15.r))),
                    width: double.infinity,
                    child: Text(
                      AppString.mostTipped,
                      textAlign: TextAlign.center,
                      style: AbsTextStyle.boldBody.copyWith(
                          fontSize: 6.7.sp, color: AbsColors.whiteColor),
                    ),
                  )
                : const SizedBox(),
            AddSpace.vertical(2.h),
            Text(
              emoji,
              style: AbsTextStyle.boldLargeTitle.copyWith(fontSize: 24.sp),
            ),
            AddSpace.vertical(6.h),
            Text(
              '\$$price',
              style: AbsTextStyle.boldLargeTitle
                  .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }));
  }
}
