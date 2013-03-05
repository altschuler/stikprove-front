describe 'session', ->
  session = null
  user = null
  cookieStore = null
  httpMock = null
  http = null

  beforeEach module 'Site'
  beforeEach inject ($cookieStore, $httpBackend, $http, Session) ->
    cookieStore = $cookieStore
    http = $http
    httpMock = $httpBackend
    httpMock.when('GET', 'views/home/login.html').respond(200)
    session = Session
    user =
      Id:1
      Email:'foo@bar.com'
      FirstName:'Foo'
      LastName:'Bar'
      AccessToken:'1a2b3c'

  it 'should base64 encode tokens', ->
    expect(session.generateToken 'foo', 'bar').toEqual 'Zm9vOmJhcg=='
    expect(session.generateToken 1, 'bar').toEqual 'MTpiYXI='

  it 'should remember the user who logged in', ->
    session.login user
    expect(session.user).toEqual user

  it 'should be logged in after logging in and vice versa', ->
    expect(session.isLoggedIn()).toBeFalsy()
    session.login user
    expect(session.isLoggedIn()).toBeTruthy()
    session.logout()
    expect(session.isLoggedIn()).toBeFalsy()

  it 'should save a cookie with user data when logging in and vice versa', ->
    session.login user
    userCookie = cookieStore.get 'session-user'
    expect(userCookie).toEqual user

    session.logout()
    userCookie = cookieStore.get 'session-user'
    expect(userCookie).not.toBeDefined()

  it 'should set headers when logging in and vice versa', ->
    session.login user
    expect(http.defaults.headers.common['Authorization']).toEqual 'token MToxYTJiM2M='

    session.logout()
    expect(http.defaults.headers.common['Authorization']).not.toBeDefined()

  it 'should ping server and login user when trying to login with cookie data', ->
    # mock the cookie
    cookieStore.put 'session-user', user
    expect(session.isLoggedIn()).toBeFalsy()

    httpMock.expectPOST('/api/ping').respond 200
    session.tryCookie()
    httpMock.flush()

    expect(session.isLoggedIn()).toBeTruthy()
    expect(session.user).toEqual user

  it 'should fail logging in an invalid user', ->
    cookieStore.put 'session-user', user

    httpMock.expectPOST('/api/ping').respond 401
    session.tryCookie()
    httpMock.flush()

    expect(session.isLoggedIn()).toBeFalsy()
    expect(session.user).not.toBeDefined()



