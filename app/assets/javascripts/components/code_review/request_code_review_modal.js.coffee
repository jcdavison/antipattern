@requestCodeReviewModal = React.createClass

  getInitialState: () ->
    formId: 'request-code-review'
    codeReviewUrl: ''
    reposSelectId: 'code-review-repo'
    branchSelectId: 'code-review-branch'
    commitSelectId: 'code-review-commit'
    entitySelectId: 'code-review-entity'
    entities: []
    repos: []
    entity: null

  getDefaultProps: () ->
    products: []
    helpers: window.ReactHelpers

  componentDidMount: () ->
    @initEmptySelect()
    @props.helpers.validateForm("##{@state.formId}")
    if @props.data.currentUser
      @populateEntities()
      @initSelectListeners()
    else
      @enableSelect2("##{@state.entitySelectId}", [])
      $("#select2-code-review-entity-container").text('please sign in to continue')

  initEmptySelect: () ->
    $('.init-empty').each( (i,e,c) ->
      $(e).select2( placeholder: '...')
    )

  displayPrivacyNotice: () ->
    if @state.repo.private
      $('#repo-privacy-reminder').text("Important Reminder => Code Reviews from private repositories will only be viewable by people who have private access to that repo on github and will not appear in antipattern.io's public facing index.")

  initSelectListeners: () ->
    $("##{@state.entitySelectId}").on 'select2:select', (e) =>
      @populateRepos(e)
    $("##{@state.reposSelectId}").on 'select2:select', (e) =>
      @populateBranches(e)
      @displayPrivacyNotice()
    $("##{@state.branchSelectId}").on 'select2:select', (e) =>
      @populateCommits(e)

  enableSelect2: (element, data, template = null) ->
    $(element).empty()
    $(element).select2(data: data)
    $(element).val(null)

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

  populateCommits: (e) ->
    $.get '/api/commits', {
        repo_id: @state.repo.repoId, 
        branch: @selectedBranch(), 
        entity: {value: @state.entity.text}
      } 
    .success( (response) =>
      @enableSelect2("##{@state.commitSelectId}", response.commits)
      $("#select2-code-review-commit-container").text('select a commit')
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

  selectedCommit: () ->
    $("##{@state.commitSelectId}").val()

  selectedTitle: () ->
    $("option[value='#{@selectedCommit()}']").text()

  elementVal: (selector) ->
    $(selector).val()

  submitCodeReview: () ->
    if @props.helpers.isValidForm("##{@state.formId}")
      data = 
        codeReview: 
          repo: @selectedRepo() 
          repo_id: @state.repo.repoId
          repo_owner: @elementVal("##{@state.entitySelectId}")
          branch: @elementVal("##{@state.branchSelectId}")
          commit_sha: @selectedCommit()
          title: @selectedTitle()
          topics: $("#topics-select").val()
          context: $("#context").val() 
          is_private: @state.repo.private
      $.ajax(
        type: 'POST'
        url: '/api/reviews.json'
        data: data 
        success: (data) =>
          @props.helpers.hide('.request-code-review-form')
          @props.helpers.show('.request-code-review-success')
          @setState codeReviewUrl: data.codeReview.antipatternUrl
          PubSub.publish 'refresh-code-review-index'
      ) 
    else
      'invalid'

  codeReviewRequestForm: () ->
    React.DOM.div
      className: 'modal-body request-code-review-form'
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-md-12'
          React.DOM.form
            id: @state.formId 
            React.DOM.div
              className: 'row'
              React.DOM.div
                className: 'col-md-12 form-steps'
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-1 col-md-offset-1 medium-small'
                    '1.'
                  React.DOM.div
                    className: 'col-md-8 medium-small'
                    'User or Organization'
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-10 col-md-offset-1 medium-small'
                    React.DOM.select
                      id: @state.entitySelectId
                      required: 'required'
                      className: 'full-bleed' 
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-1 col-md-offset-1 medium-small'
                    '2.'
                  React.DOM.div
                    className: 'col-md-8 medium-small'
                    'Repository Name'
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-10 col-md-offset-1 medium-small'
                    React.DOM.select
                      id: @state.reposSelectId
                      required: 'required'
                      className: 'full-bleed init-empty' 
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-1 col-md-offset-1 medium-small'
                    '3.'
                  React.DOM.div
                    className: 'col-md-8 medium-small'
                    'Branch Name'
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-10 col-md-offset-1 medium-small'
                    React.DOM.select
                      id: @state.branchSelectId
                      required: 'required'
                      className: 'full-bleed init-empty' 
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-1 col-md-offset-1 medium-small'
                    '4.'
                  React.DOM.div
                    className: 'col-md-8 medium-small'
                    'Commit Name'
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-10 col-md-offset-1 medium-small'
                    React.DOM.select
                      id: @state.commitSelectId
                      required: 'required'
                      className: 'full-bleed init-empty' 
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-1 col-md-offset-1 medium-small'
                    '5.'
                  React.DOM.div
                    className: 'col-md-8 medium-small'
                    'Commit Topic(s)'
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-10 col-md-offset-1 medium-small'
                    React.DOM.div
                      className: 'topic-select'
                      React.createElement topicSelect
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-1 col-md-offset-1 medium-small'
                    '6.'
                  React.DOM.div
                    className: 'col-md-8 medium-small'
                    'Context'
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-10 col-md-offset-1 medium-small'
                    React.DOM.div
                      className: 'topic-select'
                      React.DOM.textarea
                        id: 'context'
                        cols: 34
                        rows: 3
                    React.DOM.div
                      id: 'repo-privacy-reminder'
                      className: 'red'
                      ''
  render: () ->
    React.DOM.div
      className: 'modal fade request-code-review'
      id: 'user-auth'
      React.DOM.div
        className: 'modal-dialog'
        React.DOM.div
          className: 'modal-content no-corners'
          React.DOM.div
            className: 'modal-header blue medium'
            "Please Choose a Commit."
            React.DOM.button
              className: 'close'
              'data-dismiss': 'modal'
              React.DOM.span
                className: 'null'
                'aria-hidden': true
                'X'
          @codeReviewRequestForm()
          React.DOM.div
            className: 'modal-footer request-code-review-form'
            React.DOM.div
              className: 'centered'
              React.DOM.button
                className: 'btn btn-default summary' 
                onClick: @submitCodeReview
                'Submit'
          React.DOM.div
            className: 'modal-footer request-code-review-success hide'
            React.DOM.div
              className: 'centered medium blue'
              'Congrats!'
            React.DOM.div
              className: 'centered medium blue'
              React.DOM.span
                className: null
                "It's a Code Review! "
              React.DOM.i
                className: 'fa fa-retweet'
            React.DOM.div
              className: 'centered medium-small blue'
              React.DOM.a
                href: @state.codeReviewUrl
                @state.codeReviewUrl
