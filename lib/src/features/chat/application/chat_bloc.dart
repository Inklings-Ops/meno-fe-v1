// import 'dart:async';

// import 'package:meno_fe_v1/meno.dart';
// import 'package:meno_fe_v1/src/features/features.dart';
// import 'package:rxdart/rxdart.dart';

// part 'chat_bloc.freezed.dart';
// part 'chat_event.dart';
// part 'chat_state.dart';

// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   ChatBloc() : super(ChatState(chats: [], broadcast: Broadcast.empty())) {
//     on<InitializeChat>(_onInitializeChat);
//     on<NewChatReceived>(_onNewChatReceived);
//     on<ChatDeletePressed>(_onChatDeletePressed);
//     on<ChatEditPressed>(_onChatEditPressed);
//     on<ChatReset>(_onChatReset);
//     on<LoadChatMessages>(_onLoadChatMessages);
//     on<ClearChatContent>(_onClearChatContent);
//     on<ToggleShowReactions>(_onToggleReactions);
//     on<HideChatWelcomeNote>(_onHideWelcomeNote);
//     on<ContentChanged>(
//       _onContentChanged,
//       transformer: debounce(const Duration(milliseconds: 300)),
//     );
//   }

//   final _initialState = ChatState(chats: [], broadcast: Broadcast.empty());

//   Future<void> _onInitializeChat(
//     InitializeChat event,
//     Emitter<ChatState> emit,
//   ) async {
//     emit(state.copyWith(broadcast: event.broadcast));
//   }

//   void _onNewChatReceived(NewChatReceived event, Emitter<ChatState> emit) {
//     final oldMessages = List<Chat?>.from(state.chats);
//     emit(state.copyWith(chats: [event.chat, ...oldMessages]));
//   }

//   void _onLoadChatMessages(LoadChatMessages event, Emitter<ChatState> emit) {
//     emit(state.copyWith(chats: event.chats));
//   }

//   void _onChatDeletePressed(ChatDeletePressed event, Emitter<ChatState> emit) {}

//   void _onChatEditPressed(ChatEditPressed event, Emitter<ChatState> emit) {}

//   Future<void> _onChatReset(ChatReset event, Emitter<ChatState> emit) async {
//     emit(_initialState);
//   }

//   void _onContentChanged(ContentChanged event, Emitter<ChatState> emit) {
//     final hasContent = event.content.isNotEmpty;
//     emit(state.copyWith(content: event.content, hasContent: hasContent));
//   }

//   void _onClearChatContent(ClearChatContent event, Emitter<ChatState> emit) {
//     emit(state.copyWith(content: null, hasContent: false));
//   }

//   void _onToggleReactions(ToggleShowReactions event, Emitter<ChatState> emit) {
//     emit(state.copyWith(showReactions: !state.showReactions));
//   }

//   void _onHideWelcomeNote(HideChatWelcomeNote event, Emitter<ChatState> emit) {
//     emit(state.copyWith(hideWelcomeNote: true));
//   }

//   EventTransformer<E> debounce<E>(Duration duration) {
//     return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
//   }
// }
