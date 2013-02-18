# EventSpitter

A minimal but versatile JavaScript pubsub module, very similar to
Node's `EventEmitter`, but more flexible and working also in the
browser.

## EventSpitter vs. EventEmitter

Although their APIs are not exactly identical, `EventSpitter` and
Node's `EventEmitter` are very similar. While `EventEmitter` is the
standard in Node, `EventSpitter` has the following additional
features:

  - It works in the browser too

  - It supports matching events using a RegExp (e.g. `obj.on( /^f/,
    cbk )` attaches the callback to any event starting with "f")

  - It supports chainability, as most methods return `this`

Another difference is that `EventSpitter` always passes the event
name as the first argument to the event handlers.


## Methods

### on( matcher, cbk ), addListener( matcher, cbk )

Adds the callback `cbk` as a listener for any event matched by
`matcher`, which can be a `String` or a `RegExp`.

### once( matcher, cbk )

Works like `on`, except that it only subscribes for the event the
first time it is emitted, and then immediately unsubscribes.

### emit( event, [arg1], [arg2], [...] )

Executes each listener for the event, passing it the event name and
each additional argument (like `arg1`, `arg2`, etc.)

### listeners( event )

Returns an array of all the callbacks which are executed when `event`
is emitted.

### off( [matcher], [cbk] ), removeListener( [matcher], [cbk] ),
removeAllListeners( [matcher], [cbk] )

If called with no arguments, removes every event listener. If called
only with an event matcher (`String` or `RegExp`), it removes all
listeners listening to that matcher. If called passing a matcher and
a callback, it removes only that one callback from the listeners
listening to that matcher.
