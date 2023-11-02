// ignore_for_file: file_names, unused_local_variable

import 'package:benji_vendor/src/common_widgets/image/my_image.dart';
import 'package:benji_vendor/src/model/product_model.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';

class VendorsProductContainer extends StatefulWidget {
  final Function() onTap;
  final ProductModel product;

  const VendorsProductContainer(
      {super.key, required this.onTap, required this.product});

  @override
  State<VendorsProductContainer> createState() =>
      _VendorsProductContainerState();
}

class _VendorsProductContainerState extends State<VendorsProductContainer> {
  //======================================= ALL VARIABLES ==========================================\\

  //======================================= FUNCTIONS ==========================================\\

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2.5),
        width: MediaQuery.of(context).size.width,
        decoration: ShapeDecoration(
          color: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 24,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 92,
              decoration: ShapeDecoration(
                color: kPageSkeletonColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              child: MyImage(url: widget.product.productImage),
            ),
            kHalfWidthSizedBox,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    color: kTextBlackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: mediaWidth / 2,
                  child: Text(
                    widget.product.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                kHalfSizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: mediaWidth / 4,
                      child: Text(
                        '₦${convertToCurrency(widget.product.price.toString())}',
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                          fontFamily: 'Sen',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: mediaWidth / 4,
                      height: 17,
                      child: Text(
                        'Qty: ${widget.product.quantityAvailable}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: kTextGreyColor,
                          fontSize: 13.60,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
