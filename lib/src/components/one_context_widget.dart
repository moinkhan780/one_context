import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:one_context/src/controllers/one_context.dart';

class OneContextWidget extends StatefulWidget {
  final Widget? child;
  OneContextWidget({Key? key, this.child}) : super(key: key);
  _OneContextWidgetState createState() => _OneContextWidgetState();
}

class _OneContextWidgetState extends State<OneContextWidget> {
  @override
  void initState() {
    super.initState();
    OneContext().registerDialogCallback(
        showDialog: _showDialog, showSnackBar: _showSnackBar, showModalBottomSheet: _showModalBottomSheet, showBottomSheet: _showBottomSheet);
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (OneContext().hasDialogVisible) {
      OneContext().popDialog();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (innerContext) {
          OneContext().context = innerContext;
          return widget.child!;
        },
      ),
    );
  }

  Future<T?> _showDialog<T>({
    required Widget Function(BuildContext) builder,
    bool? barrierDismissible = true,
    bool useRootNavigator = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) =>
      showDialog<T?>(
        context: context,
        builder: (context) => builder(context),
        barrierDismissible: barrierDismissible!,
        useRootNavigator: useRootNavigator,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
      );

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(SnackBar Function(BuildContext?) builder) =>
      ScaffoldMessenger.of(OneContext().context!).showSnackBar(builder(OneContext().context));

  Future<T?> _showModalBottomSheet<T>({
    required Widget Function(BuildContext) builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    bool? isScrollControlled = false,
    bool? useRootNavigator = false,
    bool? isDismissible = true,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool? enableDrag,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      backgroundColor: backgroundColor,
      clipBehavior: clipBehavior,
      elevation: elevation,
      isDismissible: isDismissible!,
      isScrollControlled: isScrollControlled!,
      shape: shape,
      useRootNavigator: useRootNavigator!,
      constraints: constraints,
      barrierColor: barrierColor,
      enableDrag: enableDrag ?? true,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
    );
  }

  PersistentBottomSheetController _showBottomSheet<T>({
    Widget Function(BuildContext)? builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    bool? enableDrag,
    AnimationController? transitionAnimationController,
  }) {
    return showBottomSheet(
      context: OneContext().context!,
      builder: builder!,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      enableDrag: enableDrag ?? true,
      transitionAnimationController: transitionAnimationController,
    );
  }
}
