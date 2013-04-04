class EventSpitter

  # Private

  isRegExp = ( obj ) ->
    return ({}).toString.call( obj ) is "[object RegExp]"

  # Public

  on: ( matcher, cbk ) ->
    if isRegExp matcher
      @regexpSubscriptions ?= {}
      @regexpSubscriptions[ matcher ] ?=
        regexp:    matcher,
        callbacks: []
      @regexpSubscriptions[ matcher ].callbacks.push cbk
    else
      @subscriptions ?= {}
      @subscriptions[ matcher ] ?= []
      @subscriptions[ matcher ].push cbk
    return this

  listeners: ( evt ) ->
    @subscriptions ?= {}
    callbacks = @subscriptions[ evt ] or []
    for key, subscription of @regexpSubscriptions
      if subscription.regexp.exec( evt )?
        return callbacks.concat subscription.callbacks
    callbacks

  emit: ( evt, args... ) ->
    cbk.call( this, evt, args... ) for cbk in @listeners evt
    return this

  off: ( matcher, cbk ) ->
    unless matcher?
      @subscriptions = {}
      @regexpSubscriptions = {}
    else
      unless cbk?
        if isRegExp matcher
          delete @regexpSubscriptions?[ matcher ]
        else
          delete @subscriptions?[ matcher ]
      else
        cbks = []
        if isRegExp matcher
          subs = @regexpSubscriptions[ matcher ]
          cbks = subs.callbacks if subs?
        else
          cbks = @subscriptions[ matcher ] || []
        cbks.splice( i, 1 ) for c, i in cbks when c is cbk
    return this

  once: ( matcher, cbk ) ->
    wrappedCbk = ( args... ) =>
      cbk.call( this, args... )
      @off matcher, wrappedCbk
    @on matcher, wrappedCbk

  # Aliases
  addListener: @on
  removeListener: @off
  removeAllListeners: @off

# Export as:
# CommonJS module
if exports?
  if module? and module.exports?
    exports = module.exports = EventSpitter
  exports.EventSpitter = EventSpitter
# AMD module
else if typeof define is "function" and define.amd
  define ->
    EventSpitter
# Browser global
else
  @EventSpitter = EventSpitter
