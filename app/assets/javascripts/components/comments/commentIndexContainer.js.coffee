@commentIndexContainer = React.createClass

  getInitialState: () ->
    formId: 'comment-feed'
    codeReviewUrl: ''
    reposSelectId: 'comment-repo'
    branchSelectId: 'comment-branch'
    entitySelectId: 'comment-entity'
    statusMessage: null
    entities: []
    repos: []
    entity: null
    commentThreads: []

  initEmptySelect: () ->
    $('.init-empty').each( (i,e,c) ->
      $(e).select2( placeholder: '...')
    )

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  showSaveButton: () ->
    $('#saveCommentFeed').removeClass('hidden')

  hideSaveButton: () ->
    $('#saveCommentFeed').addClass('hidden')

  populateEntities: () ->
    $.get '/api/entities', {} 
    .success( (response) =>
      @setState entities: response.entities
      @enableSelect2("##{@state.entitySelectId}", response.entities)
      $("#select2-comment-entity-container").text('select self or org')
    )
    .error( (response) =>
      console.log 'error', response
    )

  populateBranches: (e) ->
    repo = @props.helpers.selectFrom(@state.repos, @selectedRepo(), 'id')
    @setState repo: repo
    $.get '/api/branches', {
        repo_id: repo.repoId, 
        private: repo.private
        entity: {value: @state.entity.text} 
      } 
    .success( (response) =>
      # @enableSelect2("##{@state.branchSelectId}", response.branches)
      # $("#select2-comment-branch-container").text('filter commits by branch')
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
      $("#select2-comment-repo-container").text('select a repo')
    )
    .error( (response) =>
      console.log 'error', response
    )

  hidePrompt: () ->
    $('#commentPrompt').addClass('hidden')

  hideStatus: () ->
    $('#commentStatus').addClass('hidden')

  initSelectListeners: () ->
    $("##{@state.entitySelectId}").on 'select2:select', (e) =>
      @setState commentThreads: []
      $("#select2-comment-repo-container").text('select a repo')
      @populateRepos(e)
    $("##{@state.reposSelectId}").on 'select2:select', (e) =>
      @hideStatus()
      @hidePrompt()
      @hideSaveButton()
      @setState commentThreads: []
      @loadComments()
      # @populateBranches(e)
    # $("##{@state.branchSelectId}").on 'select2:select', (e) =>
      # console.log('get comments from branch', e)

  loadComments: () ->
    $.get '/api/comments-index', {entity: @selectedEntity(), repo: @selectedRepo()} 
    .success( (response) =>
      @setState commentThreads: response.commentThreads
      @setStatus(Object.keys(response.commentThreads).length)
      @showSaveButton()
    )
    .error( (response) =>
      console.log 'error', response
    )

  setStatus: (commentCount) ->
    if commentCount == 0
      @setState statusMessage: 'this repository has no comments'
    if commentCount > 0
      @setState statusMessage: null

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
              className: 'col-md-2 form-steps centered padded'
              'user:'
            React.DOM.div
              className: 'col-md-3 form-steps centered'
              React.DOM.select
                className: 'init-empty'
                id: @state.entitySelectId
                required: 'required'
            React.DOM.div
              className: 'col-md-2 form-steps centered padded'
              'repository:'
            React.DOM.div
              className: 'col-md-3 form-steps centered'
              React.DOM.select
                className: 'init-empty'
                id: @state.reposSelectId
                required: 'required'
            React.DOM.div
              className: 'col-md-2 centered'
              React.DOM.button
                id: 'saveCommentFeed'
                className: 'btn btn-default accept no-margin hidden'
                'save'
      React.DOM.div
        id: '#commentStatus'
        className: 'light-red medium centered top-margined'
        @state.statusMessage
      React.DOM.div
        id: 'commentPrompt'
        className: 'light-red medium centered top-margined'
        'please select a repository with comments'
      React.DOM.div
        className: 'top-margined'
        React.createElement commentIndex, data: { commentThreads: @state.commentThreads }
