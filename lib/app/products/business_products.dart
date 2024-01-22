import 'package:benji_vendor/src/components/card/empty.dart';
import 'package:benji_vendor/src/components/container/business_product_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';

import '../../src/controller/product_controller.dart';
import '../../src/model/business_model.dart';
import '../../src/model/product_model.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constants.dart';
import '../../theme/colors.dart';
import 'view_product.dart';

class BusinessProducts extends StatefulWidget {
  final BusinessModel business;

  const BusinessProducts({
    super.key,
    required this.business,
  });

  @override
  State<BusinessProducts> createState() => _BusinessProductsState();
}

class _BusinessProductsState extends State<BusinessProducts> {
  @override
  void initState() {
    super.initState();
  }

  late Future<Map<String, List<ProductModel>>> productAndSubCategoryName;

  // _getData() async {
  //   Map<String, List<Product>> productAndSubCategoryName =
  //       await getVendorProductsAndSubCategoryName(widget.vendor.id);
  //   try {
  //     activeCategory = productAndSubCategoryName.keys.toList()[0];
  //     // ignore: empty_catches
  //   } catch (e) {}

  //   setState(() {
  //     snapshot.data = productAndSubCategoryName;
  //   });
  // }

//=================================== Navigation =====================================\\
  viewProduct(ProductModel product) {
    Get.to(
      () => ViewProduct(product: product),
      routeName: 'ViewProduct',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }
//=================================== END =====================================\\

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<ProductController>(builder: (controller) {
            if (controller.isLoad.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: kAccentColor,
                ),
              );
            }
            if (controller.products.isEmpty) {
              return EmptyCard(
                buttonTitle: "Add a product",
                emptyCardMessage: "You don't have any products",
                onPressed: () {},
                showButton: true,
              );
            }
            return LayoutGrid(
              rowGap: kDefaultPadding / 2,
              columnGap: kDefaultPadding / 2,
              columnSizes: breakPointDynamic(media.width, [1.fr], [1.fr, 1.fr],
                  [1.fr, 1.fr, 1.fr], [1.fr, 1.fr, 1.fr, 1.fr]),
              rowSizes: controller.products.isEmpty
                  ? [auto]
                  : List.generate(controller.products.length, (index) => auto),
              children: (controller.products)
                  .map(
                    (item) => BusinessProductContainer(
                        onTap: () => _toProductDetailScreen(item),
                        product: item),
                  )
                  .toList(),
            );
          }),
          kSizedBox,
        ],
      ),
    );
  }
}
