import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:tw_business_app/shared/animation_ripple/circle_painter.dart';
import 'package:tw_business_app/shared/animation_ripple/curve_wave.dart';
import 'package:tw_business_app/shared/constants.dart';

class RipplesAnimation extends StatefulWidget {
  const RipplesAnimation({
    Key key,
    this.size = 100.0,
    this.color = colBlue,
    this.onPressed,
    this.child,
  }) : super(key: key);
  final double size;
  final Color color;
  final Widget child;
  final VoidCallback onPressed;
  @override
  _RipplesAnimationState createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation>
    with TickerProviderStateMixin {
  final TextStyle _helptext =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.black);
  AnimationController _controller;
  bool _ripple = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..reset();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _logoButton() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                widget.color,
                Color.lerp(widget.color, Colors.black, .05)
              ],
            ),
          ),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: const CurveWave(),
              ),
            ),
            child: IconButton(
              iconSize: widget.size * 2,
              icon: Image.asset(
                'assets/images/logo_square.png',
              ),
              onPressed: () {
                setState(() => _ripple = !_ripple);
                _ripple ? _controller.repeat() : _controller.reset();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CustomPaint(
            painter: CirclePainter(
              _controller,
              color: widget.color,
            ),
            child: Stack(children: [
              SizedBox(
                  width: widget.size * 5,
                  height: widget.size * 4,
                  child: _logoButton()),
              // Image.asset(
              //   'assets/images/logo_square.png',
              //   alignment: Alignment.center,
              //   height: widget.size * 2.25,
              // ),
            ]),
          )
        ],
      ),
    );
  }
}
