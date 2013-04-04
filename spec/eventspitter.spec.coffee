buster.spec.expose()

describe "EventSpitter", ->

  before ->
    @es = new EventSpitter

  after ->
    delete @es

  describe "on", ->

    it "returns this", ->
      expect( @es.on "foo", -> ).toBe @es

    it "adds a callback to the list of subscriptions for the specified event matcher", ->
      cbk1 = ->
      cbk2 = ->
      @es.on "foo", cbk1
      @es.on "foo", cbk2
      expect( @es.subscriptions.foo ).toEqual [ cbk1, cbk2 ]

    describe "when first argument is a RegExp", ->

      it "adds an item to the list of regexp subscriptions", ->
        cbk1 = ->
        cbk2 = ->
        @es.on /foo/, cbk1
        @es.on /foo/, cbk2
        expect( @es.regexpSubscriptions["/foo/"] ).toEqual
          regexp:    /foo/,
          callbacks: [ cbk1, cbk2 ]

  describe "listeners", ->

    it "returns all callbacks matching the given event", ->
      cbk1 = ->
      cbk2 = ->
      cbk3 = ->
      @es.on "foo", cbk1
      @es.on /^f/,  cbk2
      @es.on /^fo/, cbk3
      expect( @es.listeners "foo" ).toEqual [ cbk1, cbk2, cbk3 ]

    it "does not return callbacks not matching the given event", ->
      cbk1 = ->
      cbk2 = ->
      @es.on "bar", cbk1
      @es.on /^b/,  cbk2
      expect( @es.listeners "foo" ).toEqual []

    it "does not modify the subscription array for an event", ->
      @es.on "foo", ->
      @es.on /foo/, ->
      orig_sub = @es.subscriptions.foo[..]
      @es.listeners "foo"
      expect( @es.subscriptions.foo ).toEqual orig_sub

  describe "emit", ->

    it "returns this", ->
      expect( @es.emit "foo" ).toBe @es

    it "executes all the callbacks for the event passing the event name and the additional arguments", ->
      cbk1 = @spy()
      cbk2 = @spy()
      @stub( @es, "listeners", -> [ cbk1, cbk2 ] )
      @es.emit "foo", 123, 321
      expect( cbk1 ).toHaveBeenCalledOnceWith "foo", 123, 321
      expect( cbk2 ).toHaveBeenCalledOnceWith "foo", 123, 321

    it "executes callbacks in the scope of the EventSpitter instance", ->
      probe = null
      cbk = ->
        probe = this
      @stub( @es, "listeners", -> [ cbk ] )
      @es.emit "foo"
      expect( probe ).toBe @es

  describe "off", ->

    before ->
      @cbk1 = ->
      @cbk2 = ->
      @es.subscriptions =
        foo: [ @cbk1, @cbk2 ],
        bar: [ @cbk1, @cbk2 ]
      @es.regexpSubscriptions =
        "/foo/":
          regexp:    /foo/,
          callbacks: [ @cbk1, @cbk2 ],
        "/bar/":
          regexp:    /bar/,
          callbacks: [ @cbk1, @cbk2 ]

    after ->
      delete @cbk1
      delete @cbk2

    it "returns this", ->
      expect( @es.off() ).toBe( @es )

    describe "when called with no arguments", ->

      it "removes all subscriptions", ->
        @es.off()
        expect( @es.subscriptions ).toEqual {}
        expect( @es.regexpSubscriptions ).toEqual {}
    
    describe "when called with one argument", ->

      it "removes all subscriptions for the given string event matcher", ->
        @es.off "foo"
        expect( @es.subscriptions.foo? ).toBeFalse()

      it "removes all subscriptions for the given regexp event matcher", ->
        @es.off /foo/
        expect( @es.regexpSubscriptions["/foo/"]? ).toBeFalse()

      it "does not remove subscriptions for other string event matchers", ->
        @es.off "foo"
        expect( @es.subscriptions.bar ).toEqual [ @cbk1, @cbk2 ]

      it "does not remove subscriptions for other regexp event matchers", ->
        @es.off /foo/
        expect( @es.regexpSubscriptions["/bar/"]? ).toBeTrue()

      it "does not crash if there are no subscriptions", ->
        delete @es.subscriptions
        delete @es.regexpSubscriptions
        refute.exception( => @es.off "foo" )

    describe "when called with two arguments", ->

      it "removes the given callback from subscriptions to the given string event matcher", ->
        @es.off "foo", @cbk1
        expect( @es.subscriptions.foo ).toEqual [ @cbk2 ]

      it "removes all subscriptions for the given regexp event matcher", ->
        @es.off /foo/, @cbk1
        expect( @es.regexpSubscriptions["/foo/"].callbacks ).toEqual [ @cbk2 ]

      it "does not remove the callback from subscriptions to other string event matchers", ->
        @es.off "foo", @cbk1
        expect( @es.subscriptions.bar ).toEqual [ @cbk1, @cbk2 ]

      it "does not remove the callback from subscriptions to other regexp event matchers", ->
        @es.off /foo/
        expect( @es.regexpSubscriptions["/bar/"].callbacks ).toEqual [ @cbk1, @cbk2 ]

  describe "once", ->

    it "returns this", ->
      expect( @es.once "foo", -> ).toBe( @es )

    it "subscribes only once", ->
      cbk = @spy()
      @es.once "foo", cbk
      @es.emit "foo"
      @es.emit "foo"
      expect( cbk ).toHaveBeenCalledOnce()
