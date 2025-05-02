import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/slide_model.dart';

class PageViewSlide extends StatelessWidget {
  final Slide? slide;
  const PageViewSlide({Key? key, this.slide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (slide == null) {
      return Center(child: Text("Slide not available"));
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (slide!.svgUrl != null)
            SvgPicture.asset(
              slide!.svgUrl!,
              height: 200,
            ),
          if (slide!.title != null) ...[
            SizedBox(height: 20.0),
            Text(
              slide!.title!,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
          if (slide!.subTitle != null) ...[
            SizedBox(height: 10.0),
            Text(
              slide!.subTitle!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
