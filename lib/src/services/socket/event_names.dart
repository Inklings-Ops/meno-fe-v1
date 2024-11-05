// Naming convention for the event names
//
// s (socket) -> E (Event) -> (name of event)
//

const String sEConnect = 'connect';
const String sEConnectError = 'connect_error';
const String sEConnectTimeout = 'connect_timeout';
const String sEConnecting = 'connecting';
const String sEDisconnect = 'disconnect';
const String sEError = 'error';
const String sEReconnect = 'reconnect';
const String sEReconnectAttempt = 'reconnect_attempt';
const String sEReconnectFailed = 'reconnect_failed';
const String sEReconnectError = 'reconnect_error';
const String sEReconnecting = 'reconnecting';
const String sEPing = 'ping';
const String sEPong = 'pong';

const String sEStartedBroadcast = 'startedBroadcast';
const String sEEndBroadcast = 'endBroadcast';
const String sEEndedBroadcast = 'endedBroadcast';
const String sEJoinBroadcast = 'joinBroadcast';
const String sELeaveBroadcast = 'leaveBroadcast';
const String sEGetLiveBroadcast = 'getLiveBroadcast';
const String sEGetBroadcastListeners = 'getBroadcastListeners';
const String sEGetNumberOfBroadcastListeners = 'getNumberOfBroadcastListeners';
const String sENewBroadcast = 'newBroadcast';
const String sEGetLiveBroadcasts = 'getLiveBroadcasts';

const String sENotification = 'notification';

// deprecated
const String sENewBroadcastListener = 'newBroadcastListener';
const String sENumberOfLiveListeners = 'numberOfLiveListeners';
