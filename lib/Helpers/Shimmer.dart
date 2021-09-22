import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';

class ShimmerHelper{
  var colors = [kPrimaryColor, kAlertError, kAlertWarning];

  Widget showPageLoadingShimmer(bool shimmerEnabled){
    return Container(
      width: double.maxFinite, height: double.maxFinite,
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Container(width: 50, height: 50,
              child: LoadingIndicator(indicatorType: Indicator.lineScaleParty, colors: colors,)),),
          SizedBox(height: 20,),
          Shimmer.fromColors(
            baseColor: Colors.black,
            highlightColor: kGrayScale1,
            enabled: shimmerEnabled,
            child: Text("Please wait...", style: TextStyle(fontSize: 22),)
          ),
        ],
      ),
    );
  }

}