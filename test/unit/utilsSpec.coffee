describe 'utils', ->
  utils = null
  beforeEach module 'Site'
  beforeEach inject (Utils) ->
    utils = Utils

  describe 'array utils', ->
    it 'should move simple elements between arrays', ->
      arr1 = ['foo1', 'bar1']
      arr2 = ['foo2']
      [arr1, arr2] = utils.moveElement 'foo1', arr1, arr2

      expect(arr1).not.toContain 'foo1'
      expect(arr1).toContain 'bar1'

      expect(arr2).toContain 'foo1'
      expect(arr2).toContain 'foo2'

    it 'should move use matcher when provided', ->
      elm1 = id:1, name:'foo'
      elm2 = id:2, name:'bar'
      arr1 = [elm1, elm2]
      arr2 = []

      [arr1, arr2] = utils.moveElement id:1, arr1, arr2

      expect(arr1).not.toContain elm1
      expect(arr1).toContain elm2

      expect(arr2).toContain elm1
      expect(arr2).not.toContain elm2