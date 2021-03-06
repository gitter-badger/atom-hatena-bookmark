HatenaBookmarkList = require '../lib/hatena-bookmark-list'

describe 'HatenaBookmarkList', ->
  describe 'instance', ->
    list = null

    beforeEach ->
      downloader =
        fetch: ->
          Promise.resolve()
      list = new HatenaBookmarkList downloader

    it 'should be defined "destroy"', ->
      expect(list.destroy).toBeDefined()

    it 'should be defined "fetch"', ->
      expect(list.fetch).toBeDefined()

    it 'should be defined "insert"', ->
      expect(list.insert).toBeDefined()

    it 'should be defined "onDidDestroy"', ->
      expect(list.onDidDestroy).toBeDefined()

    it 'should be defined "onSetBookmarks"', ->
      expect(list.onSetBookmarks).toBeDefined()

    it 'should be defined "openCommentUrl"', ->
      expect(list.openCommentUrl).toBeDefined()

    it 'should be defined "openUrl"', ->
      expect(list.openUrl).toBeDefined()

    it 'should be defined "nextPage"', ->
      expect(list.nextPage).toBeDefined()

    it 'should be defined "previousPage"', ->
      expect(list.previousPage).toBeDefined()

  describe '::destroy and ::onDidDestroy', ->
    list = null

    beforeEach ->
      downloader =
        fetch: ->
          Promise.resolve()
      list = new HatenaBookmarkList downloader

    it 'should call onDidDestroy subscription', ->
      subscription = jasmine.createSpy 'destroyed'
      list.onDidDestroy subscription
      list.destroy()
      runs ->
        expect(subscription).toHaveBeenCalledWith list

  describe '::fetch and ::onSetBookmarks', ->
    [list, bookmarks] = []

    describe 'when resolved', ->
      beforeEach ->
        bookmarks = [1, 2, 3]
        repository =
          getPage: ->
            Promise.resolve bookmarks
        list = new HatenaBookmarkList repository

      it 'should call onSetBookmarks subscription', ->
        subscription = jasmine.createSpy 'set-bookmarks'
        waitsForPromise ->
          list.onSetBookmarks subscription
          list.fetch()
        runs ->
          expect(subscription).toHaveBeenCalled()

    describe 'when rejected', ->
      beforeEach ->
        repository =
          getPage: ->
            Promise.reject()
        list = new HatenaBookmarkList repository

      it 'should not call onSetBookmarks subscription', ->
        subscription = jasmine.createSpy 'set-bookmarks'
        reject = jasmine.createSpy 'reject'
        waitsForPromise ->
          list.onSetBookmarks subscription
          list.fetch()
          .catch reject
        runs ->
          expect(subscription).not.toHaveBeenCalled()
          expect(reject).toHaveBeenCalled()
