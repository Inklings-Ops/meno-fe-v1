import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/chat/model/_model.dart';
import 'package:meno/features/chat/services/_services.dart';

/// 80 ms — coalesces bursts of socket messages into a single list rebuild
/// while still feeling instant to the user.
const _kChatDebounceDuration = Duration(milliseconds: 80);

final class ChatFeedSource extends PagedFeedDataSource<MessageProxy> {
  ChatFeedSource({
    required ChatHttpService http,
    required ChatSocketService socket,
    required ChatDataRepository repository,
    required Id broadcastId,
    super.initialItems,
  }) : _http = http,
       _socket = socket,
       _repository = repository,
       _broadcastId = broadcastId,
       // Pass the debounce duration — socket bursts are coalesced,
       // page loads always flush immediately via flushItemCount().
       super(debounceDuration: _kChatDebounceDuration);

  final ChatHttpService _http;
  final ChatSocketService _socket;
  final ChatDataRepository _repository;
  final Id _broadcastId;

  @override
  bool itemsAreEqual(MessageProxy item1, MessageProxy item2) {
    return item1.idStr == item2.idStr;
  }

  @override
  Future<void> requestNextPage() async {
    if (!hasNextPage) return;

    final response = await _http.getMessages(
      _broadcastId.getOrCrash(),
      pagination: PaginationParams(page: nextPageIndex, size: 100),
    );

    items.addAll(response.items.map(_repository.acquire));

    updatePaginationState(
      currentPage: nextPageIndex,
      totalPages: response.totalPages,
    );

    flushItemCount(); // Flush immediately — appended page must appear at once.
  }

  @override
  Future<void> updateFeedData() async {
    final result = await _socket.emitGetChatMessages(_broadcastId.getOrCrash());

    final currentIds = items.map((i) => i.idStr).toSet();

    // Identify new messages that aren't in the list yet
    final newMessages = result.items
        .where((m) => !currentIds.contains(m.id.getOrCrash()))
        .toList();

    if (newMessages.isNotEmpty) {
      // Prepend new messages in reverse order (server returns newest first)
      // We do this manually to avoid repeated O(N) shifts and refresh calls
      final newProxies = newMessages.reversed.map((m) {
        final proxy = _repository.acquire(m);
        proxy.referenceCount++; // Feed reference
        _repository.release(proxy); // Release acquire reference
        return proxy;
      }).toList();

      items.insertAll(0, newProxies);
    }

    // Update existing messages in case they were edited
    for (final message in result.items) {
      if (currentIds.contains(message.id.getOrCrash())) {
        updateMessage(message);
      }
    }

    updatePaginationState(currentPage: 1, totalPages: result.totalPages);

    flushItemCount(); // the full first page must appear without delay.
  }

  void addMessageAtStart(Message message) {
    final proxy = _repository.acquire(message);
    addItemAtStart(proxy);
    // Release the reference from 'acquire' as the feed now owns it via
    // 'addItemAtStart'
    _repository.release(proxy);
  }

  void updateMessage(Message message) {
    final index = items.indexWhere((i) => i.id == message.id);
    if (index == -1) return;
    // This updates the message proxy in place
    _repository.acquire(message);
    // Immediately release the extra reference count
    _repository.release(items[index]);
  }

  void removeMessage(String messageIdStr) {
    final index = items.indexWhere((i) => i.id.getOrCrash() == messageIdStr);
    if (index == -1) return;
    final proxy = items[index];
    removeObject(proxy);
    _repository.release(proxy);
  }

  /// Increments ref count before inserting so the repository knows this feed
  /// holds a reference to the proxy.
  @override
  void addItemAtStart(MessageProxy item) {
    item.referenceCount++;
    super.addItemAtStart(item);
  }

  bool get hasReachedEnd => !hasNextPage && updateWasCalled;

  @override
  void onDispose() {
    // Release all proxies the feed currently holds before tearing down.
    _repository.releaseAll(List<MessageProxy>.from(items));
    items.clear();
    super.onDispose();
  }
}
