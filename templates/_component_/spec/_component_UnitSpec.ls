describe 'component: _component_', (...) !->

  beforeEach module 'app.components'

  beforeEach inject (($rootScope, _$componentController_) !->
    scope = $rootScope.$new!
    $componentController = _$componentController_
  )

  it 'should be tested', !->
    expect(true).toBe(true)
