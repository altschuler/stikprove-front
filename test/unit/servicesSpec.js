// Generated by CoffeeScript 1.4.0
(function() {

  describe('utils', function() {
    var utils;
    utils = null;
    beforeEach(module('Site'));
    beforeEach(inject(function(Utils) {
      return utils = Utils;
    }));
    return describe('array utils', function() {
      it('should move simple elements between arrays', function() {
        var arr1, arr2, _ref;
        arr1 = ['foo1', 'bar1'];
        arr2 = ['foo2'];
        _ref = utils.moveElement('foo1', arr1, arr2), arr1 = _ref[0], arr2 = _ref[1];
        expect(arr1).not.toContain('foo1');
        expect(arr1).toContain('bar1');
        expect(arr2).toContain('foo1');
        return expect(arr2).toContain('foo2');
      });
      return it('should move use matcher when provided', function() {
        var arr1, arr2, elm1, elm2, _ref;
        elm1 = {
          id: 1,
          name: 'foo'
        };
        elm2 = {
          id: 2,
          name: 'bar'
        };
        arr1 = [elm1, elm2];
        arr2 = [];
        _ref = utils.moveElement({
          id: 1
        }, arr1, arr2), arr1 = _ref[0], arr2 = _ref[1];
        expect(arr1).not.toContain(elm1);
        expect(arr1).toContain(elm2);
        expect(arr2).toContain(elm1);
        return expect(arr2).not.toContain(elm2);
      });
    });
  });

}).call(this);
