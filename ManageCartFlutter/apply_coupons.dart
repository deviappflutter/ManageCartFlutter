// Offer and Benefits widgets
class ApplyCouponsWidget extends StatelessWidget {
  CartListModel cartListModel;
  CartController controller;
  ApplyCouponsWidget(this.cartListModel, this.controller, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        var data=await Get.toNamed('/applyCoupon',arguments: cartListModel);
        if(data!=null){
          controller.couponCode.value=data.toString();
          controller.getCartList();
        }
      },
      child: Container(
        height: 50.h,
      
        padding: EdgeInsets.symmetric(horizontal: 15.w),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppString.applyCoupon,
              style: AbsTextStyle.boldLargeTitle.copyWith(fontSize: 16.sp),
            ),
            const Icon(Icons.keyboard_arrow_right_sharp,
                size: 30, color: AbsColors.lightGreyColor),
           
          ],
        ),
      ),
    );
  }
}
