describe 'form validation', ->
  hasErr = (elm) -> elm.hasClass VLDT_ERROR_CLS

  compile = null
  VLDT_ERROR_CLS = 'vldt-error'

  beforeEach module 'Site'
  beforeEach inject ($compile) ->
    compile = $compile

  it 'should not validate fields that are not yet modified', ->
    $elm = $(compile('<input vldt="req,mail,length:5">') {})
    expect(hasErr $elm).toBeFalsy() #should not have errors before modification

  it 'should validate required rule', ->
    $elm = $(compile('<input vldt="req">') {})
    expect(hasErr $elm).toBeFalsy() #should not have errors before modification
    $elm.val('foo').change()
    expect(hasErr $elm).toBeFalsy()
    $elm.val('').change()
    expect(hasErr $elm).toBeTruthy()
    $elm.val('bar').change()
    expect(hasErr $elm).toBeFalsy()

  it 'should validate mail rule', ->
    $elm = $(compile('<input vldt="mail">') {})
    $elm.val('foobar').change()
    expect(hasErr $elm).toBeTruthy()
    $elm.val('fake@emai.l').change()
    expect(hasErr $elm).toBeTruthy()
    $elm.val('real@email.com').change()
    expect(hasErr $elm).toBeFalsy()

  it 'should validate length rule', ->
    $elm = $(compile('<input vldt="length:5">') {})
    $elm.val('123').change()
    expect(hasErr $elm).toBeTruthy()
    $elm.val('12345').change()
    expect(hasErr $elm).toBeFalsy()

  it 'should validate digit rule', ->
    $elm = $(compile('<input vldt="digit">') {})
    $elm.val('foo123').change()
    expect(hasErr $elm).toBeTruthy()
    $elm.val('123bar').change()
    expect(hasErr $elm).toBeTruthy()
    $elm.val('12345').change()
    expect(hasErr $elm).toBeFalsy()

  it 'should validate match rule', ->
    dom = compile('<div><input id="inp1"/><input id="inp2" vldt="match:#inp1"/></div>') {}
    $elm1 = $(compile(dom.find "#inp1") {})
    $elm2 = $(compile(dom.find "#inp2") {})
    $elm1.val('foobar').change()
    expect(hasErr $elm2).toBeFalsy()
    $elm2.val('foo').change()
    expect(hasErr $elm2).toBeTruthy()
    $elm2.val('foobar').change()
    expect(hasErr $elm2).toBeTruthy()
    #TODO fix match test

  it 'should validate multiple rules', ->
    $elm = $(compile('<input vldt="digit,req, length:5">') {})
    $elm.val('foo123').change()
    expect(hasErr $elm).toBeTruthy()
    $elm.val('12345').change()
    expect(hasErr $elm).toBeFalsy()

  #jasmine apparently has scoping issues so wrap the callee in a closure
  it 'should break on unrecognized rules', ->
    $bad = $(compile('<input vldt="fake,rules">') {})
    expect(-> $bad.change()).toThrow message:"Unknown rule type 'fake'"

    $good = $(compile('<input vldt="req,digit">') {})
    expect(-> $good.change()).not.toThrow()
