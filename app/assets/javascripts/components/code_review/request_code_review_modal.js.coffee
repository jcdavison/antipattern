@requestCodeReviewModal = React.createClass

  getInitialState: () ->
    formId: 'request-code-review'
    codeReviewUrl: ''
    reposSelectId: 'code-review-repo'
    branchSelectId: 'code-review-branch'
    commitSelectId: 'code-review-commit'
    repos: []

  getDefaultProps: () ->
    products: []
    helpers: window.ReactHelpers

  componentDidMount: () ->
    @initEmptySelect()
    @props.helpers.validateForm("##{@state.formId}")
    @initSelectListeners()
    @populateRepos()

  initEmptySelect: () ->
    $('.init-empty').each( (i,e,c) ->
      $(e).select2( placeholder: '...')
    )

  initSelectListeners: () ->
    $("##{@state.reposSelectId}").on 'select2:select', (e) =>
      @populateBranches(e)
    $("##{@state.branchSelectId}").on 'select2:select', (e) =>
      @populateCommits(e)

  enableSelect2: (element, data) ->
    $(element).select2(data: data)

  populateRepos: () ->
    $.get '/api/repositories', {} 
    .success( (response) =>
      @enableSelect2("##{@state.reposSelectId}", response.repos)
      $("#select2-code-review-repo-container").text('select a repo')
    )
    .error( (response) =>
      console.log 'error', response
    )

  populateBranches: (e) ->
    $.get '/api/branches', {repo: @selectedRepo()} 
    .success( (response) =>
      @enableSelect2("##{@state.branchSelectId}", response.branches)
      $("#select2-code-review-branch-container").text('select a branch')
    )
    .error( (response) =>
      console.log 'error', response
    )

  populateCommits: (e) ->
    $.get '/api/commits', {repo: @selectedRepo(), branch: @selectedBranch()} 
    .success( (response) =>
      @enableSelect2("##{@state.commitSelectId}", response.commits)
    )
    .error( (response) =>
      console.log 'error', response
    )

  selectedRepo: () ->
    $("##{@state.reposSelectId}").val()

  selectedBranch: () ->
    $("##{@state.branchSelectId}").val()

  selectedCommit: () ->
    $("##{@state.commitSelectId}").val()

  selectedTitle: () ->
    $("option[value='#{@selectedCommit()}']").text()


  submitCodeReview: () ->
    if @props.helpers.isValidForm("##{@state.formId}")
      data = 
        codeReview: 
          repo: @selectedRepo() 
          commit_sha: @selectedCommit()
          title: @selectedTitle()
          topics: $("#topics-select").val()
          context: $("#context").val() 
      $.ajax(
        type: 'POST'
        url: '/api/reviews.json'
        data: data 
        success: (data) =>
          @props.helpers.hide('.request-code-review-form')
          @props.helpers.show('.request-code-review-success')
          @setState codeReviewUrl: data.codeReview.antipatternUrl
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
                    'Repository Name'
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-10 col-md-offset-1 medium-small'
                    React.DOM.select
                      id: @state.reposSelectId
                      required: 'required'
                      className: 'full-bleed' 
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-1 col-md-offset-1 medium-small'
                    '2.'
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
                    '3.'
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
                    '4.'
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
                    '5.'
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
