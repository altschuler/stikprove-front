describe 'manage controller', () ->
  $scope = null
  $browser = null
  ctrl = null

  beforeEach module 'Site'

  beforeEach inject ($rootScope, $controller) ->
    $scope = $rootScope.$new()
    ctrl = $controller 'ManageCtrl',
      $scope: $scope

  it 'should default to usage tab', () ->
    expect($scope.activePage).toBe 'usage'