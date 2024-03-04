import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:open_ai_bot/features/Home/home_bloc.dart';
import 'package:open_ai_bot/features/Home/home_events.dart';
import 'package:open_ai_bot/features/Home/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController controller;  

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);

    Widget getAnimationWidget(HomeBloc bloc, HomeState state) {
      if (state.waiting) {
        return Lottie.asset('assets/waiting.json', width: 300, height: 300);
      } else if (state.recording) {
        return Lottie.asset('assets/recording.json', width: 300, height: 300);
      } else if (state.thinking) {
        controller.reverse();
        return Lottie.asset('assets/thinking.json', width: 300, height: 300);
      } else if (state.speaking) {
        return Lottie.asset('assets/speaking.json', width: 300, height: 300);
      } else {
        return Lottie.asset('assets/waiting.json', width: 300, height: 300);
      }
    }

    void getRecordingWidget(HomeBloc bloc, HomeState state) {
      if (state.waiting) {
        homeBloc.add(StartRecordingEvent());
        controller.forward();
      }
    }

    return BlocBuilder<HomeBloc, HomeState>(bloc: homeBloc, builder: (context, state) {return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: getAnimationWidget(homeBloc, state)
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                getRecordingWidget(homeBloc, state);
              },
              child: Lottie.asset('assets/startrecording.json', 
                controller: controller,
                width: 80, 
                height: 80,
                fit: BoxFit.fill, 
                repeat: false, 
                animate: false,
                onLoaded: (composition) {
                  controller.duration = composition.duration;
                }
              ),
            )
          ])
        );
       }
    );
  }
}