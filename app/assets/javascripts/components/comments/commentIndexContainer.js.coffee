@commentIndexContainer = React.createClass

  getInitialState: () ->
    formId: 'comment-feed'
    codeReviewUrl: ''
    reposSelectId: 'comment-repo'
    branchSelectId: 'comment-branch'
    entitySelectId: 'comment-entity'
    entities: []
    repos: []
    entity: null

  initEmptySelect: () ->
    $('.init-empty').each( (i,e,c) ->
      $(e).select2( placeholder: '...')
    )

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  populateEntities: () ->
    $.get '/api/entities', {} 
    .success( (response) =>
      @setState entities: response.entities
      @enableSelect2("##{@state.entitySelectId}", response.entities)
      $("#select2-code-review-entity-container").text('select self or org')
    )
    .error( (response) =>
      console.log 'error', response
    )

  displayPrivacyNotice: () ->
    if @state.repo.private
      $('#repo-privacy-reminder').text("Important Reminder => Code Reviews from private repositories will only be viewable by people who have private access to that repo on github and will not appear in antipattern.io's public facing index.")

  populateBranches: (e) ->
    repo = @props.helpers.selectFrom(@state.repos, @selectedRepo(), 'id')
    @setState repo: repo
    $.get '/api/branches', {
        repo_id: repo.repoId, 
        private: repo.private
        entity: {value: @state.entity.text} 
      } 
    .success( (response) =>
      @enableSelect2("##{@state.branchSelectId}", response.branches)
      $("#select2-code-review-branch-container").text('select a branch')
    )
    .error( (response) =>
      console.log 'error', response
    )

  selectedEntity: () ->
    $("##{@state.entitySelectId}").val()

  selectedRepo: () ->
    $("##{@state.reposSelectId}").val()

  selectedBranch: () ->
    $("##{@state.branchSelectId}").val()

  populateRepos: () ->
    entity = @props.helpers.selectFrom(@state.entities, @selectedEntity(), 'text')
    @setState entity: entity
    $.get '/api/repositories', {entityType: entity.entityType, entityValue: entity.text} 
    .success( (response) =>
      @setState repos: response.repos
      @enableSelect2("##{@state.reposSelectId}", response.repos)
      $("#select2-code-review-repo-container").text('select a repo')
    )
    .error( (response) =>
      console.log 'error', response
    )

  initSelectListeners: () ->
    $("##{@state.entitySelectId}").on 'select2:select', (e) =>
      @populateRepos(e)
    $("##{@state.reposSelectId}").on 'select2:select', (e) =>
      @populateBranches(e)
      @displayPrivacyNotice()
    $("##{@state.branchSelectId}").on 'select2:select', (e) =>
      console.log('get comments from branch', e)

  enableSelect2: (element, data, template = null) ->
    $(element).empty()
    $(element).select2(data: data)
    $(element).val(null)

  componentDidMount: () ->
    @initEmptySelect()
    @props.helpers.validateForm("##{@state.formId}")
    if @props.data.currentUser
      @populateEntities()
      @initSelectListeners()
    else
      @enableSelect2("##{@state.entitySelectId}", [])
      $("#select2-code-review-entity-container").text('please sign in to continue')

  render: () ->
    React.DOM.div
      className: null
      React.DOM.div
        className:  'borders padded'
        React.DOM.form
          id: @state.formId 
          React.DOM.div
            className: 'row'
            React.DOM.div
              className: 'col-md-4 form-steps'
              'Organization '
              React.DOM.select
                className: 'init-empty'
                id: @state.entitySelectId
                required: 'required'
            React.DOM.div
              className: 'col-md-4 form-steps'
              'Repository '
              React.DOM.select
                className: 'init-empty'
                id: @state.reposSelectId
                required: 'required'
            React.DOM.div
              className: 'col-md-4 form-steps'
              'Branch '
              React.DOM.select
                id: @state.branchSelectId
                className: 'init-empty'
                required: 'required'
