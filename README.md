# EventSpitter

A minimal but versatile JavaScript pub/sub module, very similar to Node's
`EventEmitter`, but more flexible and working also in the browser. It can be
required with CommonJS, AMD and standard browser `<script>` tag. Coffeescript
version provided too.


## Usage

```javascript
var es = new EventSpitter;

// Attach a listener to an event 'foo'
es.on("foo", function( evt, arg1, arg2 ) {
  console.log( "I was triggered by event " + evt );
  console.log( "I was passed additional arguments " + arg1 + " and " + arg2 );
});

// Attach a listener using a regular expression
es.on(/^f/, function() {
  console.log("I am listening to any event starting with 'f'");
});

// Emit an event 'foo' passing additional arguments 123 and "xyz"
es.emit("foo", 123, "xyz");

// Most methods are chainable
es.on("bar", function() {
  console.log("bar!");
}).emit("foo").emit("bar");
```


## EventSpitter vs. EventEmitter

Altough `EventSpitter` and Node's `EventEmitter` are a lot similar,
`EventSpitter` is not meant as a drop-in replacement, as the API is not
identical. Some notable differences are that `EventSpitter`:

  - is meant to work also in the browser

  - lets you match events using regular expressions

  - passes the name of the event as the first argument to callbacks

  - returns `this` in most method, enabling chainability

  - does not treat the 'error' event in any special way

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

### off( [matcher], [cbk] ), removeListener( [matcher], [cbk] ), removeAllListeners( [matcher], [cbk] )

If called with no arguments, removes every event listener. If called
only with an event matcher (`String` or `RegExp`), it removes all
listeners listening to that matcher. If called passing a matcher and
a callback, it removes only that one callback from the listeners
listening to that matcher.


# Changelog

  * 0.0.3 - Fix bugs with RegExp listeners

  * 0.0.2 - Fix bug with `off` when there are no subscriptions

  * 0.0.1 - Fix bug with listeners method modifying the array of subscriptions

  * 0.0.0 - First alpha release
