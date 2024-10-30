import 'package:get_time_ago/get_time_ago.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

class BroadcastChatTab extends HookWidget {
  const BroadcastChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    useEffect(
      () {
        GetTimeAgo.setCustomLocaleMessages('en', CustomMessages());
        return null;
      },
      [],
    );

    return BlocBuilder<BroadcastBloc, BroadcastState>(
      builder: (context, state) => state.status.maybeWhen(
        orElse: () => const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [MText('Waiting for broadcast to start')],
        ),
        started: (_) => LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ChatList(controller: scrollController),
                ),
              ),
              SafeArea(
                child: SizedBox(
                  height: 52,
                  width: constraints.maxWidth,
                  child: ChatInputContainer(scrollController: scrollController),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => 'ago';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'just now';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds seconds';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'a minute';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes minutes';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'an hour';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours hours';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'a day';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days days';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
