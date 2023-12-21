import 'package:video_app/index.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;

  const ImageSlider({super.key, required this.images});

  @override
  State<ImageSlider> createState() => _ImageSlider();
}

class _ImageSlider extends State<ImageSlider> {
  late CarouselSliderController _sliderController;
  late int _pageIndicator = 1;

  @override
  void initState() {
    super.initState();
    _sliderController = CarouselSliderController();
    _pageIndicator = 1;
  }

  void _onSlideChange(int index) {
    setState(() {
      _pageIndicator = index % widget.images.length + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 220,
      child: widget.images.length > 1
          ? Stack(
              children: [
                CarouselSlider.builder(
                  unlimitedMode: true,
                  controller: _sliderController,
                  onSlideChanged: _onSlideChange,
                  slideBuilder: (index) {
                    return CachedNetworkImage(
                      progressIndicatorBuilder: (_, __, ___) =>
                          const CustomProgressIndicator(),
                      imageUrl: widget.images[index],
                      fit: BoxFit.fill,
                    );
                  },
                  slideIndicator: CircularSlideIndicator(
                    padding: const EdgeInsets.only(bottom: 12),
                    indicatorBorderColor: const Color(0xFFFFFFFF),
                    currentIndicatorColor: const Color(0xFF007AFF),
                    indicatorBackgroundColor: const Color(0xFFFFFFFF),
                    indicatorBorderWidth: 0,
                    indicatorRadius: 3,
                    itemSpacing: 10,
                  ),
                  itemCount: widget.images.length,
                  initialPage: 0,
                  enableAutoSlider: true,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Color.fromRGBO(0, 0, 0, 0.7),
                    ),
                    child: Center(
                      child: Text(
                        '$_pageIndicator/${widget.images.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : CachedNetworkImage(
              progressIndicatorBuilder: (_, __, ___) =>
                const CustomProgressIndicator(),
              imageUrl: widget.images[0],
            ),
    );
  }
}
