@commentInput = React.createClass

  getInitialState: () ->
    formId: @props.data.formId
    justification: null 
    references: null
    antipattern: null
    commitSha: @props.data.commitSha
    fileName: @props.data.fileName
    position: @props.data.position
    repo: @props.data.repo
    repoOwner: @props.data.repoOwner
    owner: @props.data.owner
    currentUser: @props.data.currentUser

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  componentDidMount: () ->
    PubSub.subscribe 'enableCommentButton', @toggleButton
    $("##{@state.formId}").h5Validate()

  postableComment: () ->
    comment: 
      body: @buildCommentBody()
      sha: @state.commitSha
      path: @state.fileName
      position: @state.position
      repo: @state.repo
      repoOwner: @props.data.repoOwner

  buildCommentBody: () ->
    if @state.antipattern
      "#{@buildFragment('antipattern')}#{@buildFragment('justification')}#{@buildFragment('references')}#{@includeAttribution()}"
    else
      "#{@state.justification}#{@includeAttribution()}"

  toggleButton: () ->
    currentState = $('button.comment-input').prop('disabled')
    $('button.comment-input').prop('disabled', ! currentState)

  buildFragment: (stateName) ->
    if @state[stateName]
      "<span class='structured-feedback-element'>#{stateName}:</span> <br/>#{@state[stateName]}<br/><br/>"
    else
      ""

  includeAttribution: () ->
    "<a href='#{window.location.href}' class='antipattern-inline-hide' target='_blank'>created on antipattern.io</a>"

  postComment: (e) ->
    $.post(
      '/api/comments', 
      @postableComment()
    )
    .success( (obj) =>
      PubSub.publish 'updateCommit'
      @setState justification: ''
      @setState antipattern: null
    )
    .error( (response) =>
      @toggleButton()
    )

  renderComment: (comment) ->

  clickSubmit: (e) ->
    e.preventDefault()
    if $("##{@state.formId}").h5Validate('allValid')
      @toggleButton()
      @postComment(e)

  renderRelevantButton: () ->
    if @props.data.currentUser
      React.DOM.div
        className: 'text-right' 
        React.DOM.button
          type: 'submit'
          className: 'btn btn-default accept form-control comment-input'
          onClick: @clickSubmit
          dangerouslySetInnerHTML: {__html: "comment as #{@state.currentUser.githubUsername} <i class='fa fa-github'></i>"}
    else
      React.DOM.div
        className: 'text-right top-margined' 
        React.DOM.a
          className: 'btn btn-default accept comment-input'
          href: '/users/auth/github'
          dangerouslySetInnerHTML: {__html: "<i class='fa fa-github-alt'></i> authenticate to comment"}

  renderIdentifyAntipattern: () ->
    React.DOM.div
      className: 'row'
      React.DOM.div
        className: 'col-sm-10'
        React.DOM.div
          className: null
          React.DOM.form
            className: 'create-comment form-inline'
            id: @state.formId
            React.DOM.div
              className: 'top-margined' 
              React.DOM.div
                className: 'blue'
                "Identify the Antipattern"
              React.DOM.div
                className: null
                "i.e., 'unclear variable names' or 'n+1 query'"
              React.DOM.div
                className: null
                React.DOM.input
                  className: 'form-control full-bleed anti-pattern-identification'
                  value: @state.antipattern
                  'data-state-attribute': 'antipattern'
                  required: true
                  onChange: @props.helpers.updateSelf.bind(@)
            React.DOM.div
              className: 'top-margined' 
              React.DOM.div
                className: 'blue'
                "Justify the relevance of the Antipattern"
              React.DOM.div
                className: null
                "i.e., 'n+1 queries can cause a possibly infinite number of db calls'"
              React.DOM.textarea
                className: 'comment-anti-pattern form-control'
                cols: '75'
                rows: '3'
                value: @state.justification
                required: true
                'data-state-attribute': 'justification'
                onChange: @props.helpers.updateSelf.bind(@)
            React.DOM.div
              className: 'top-margined' 
              React.DOM.div
                className: 'blue'
                "Provide supporting links and references, if necessary."
              React.DOM.div
                className: null
                "i.e., http://stackoverflow.com/foo or http://someawesomblog.com/great_post"
              React.DOM.textarea
                className: 'references-anti-pattern form-control'
                cols: '75'
                rows: '3'
                value: @state.references
                'data-state-attribute': 'references'
                onChange: @props.helpers.updateSelf.bind(@)
            @renderRelevantButton()

  setIntention: (e) ->
     intention = e.currentTarget.dataset.intention
     @props.helpers.hide('#intentionSelect')
     @props.helpers.show("##{intention}Input")

  renderFeedbackIntentionChoices: () ->
    React.DOM.div
      className: 'row'
      React.DOM.div
        className: 'col-sm-10'
        @renderIdentifyAntipattern() 
        React.DOM.div
          className: null
          id: 'intentionSelect'
          'Please Choose Your Feedback Intention:'
          React.DOM.div
            className: 'top-margined'
            React.DOM.div
              className: 'blue pointer'
              onClick: @setIntention
              'data-intention': 'antipattern'
              "Identify a coding antipattern "
              React.DOM.i
                className: 'fa fa-space-shuttle hover-toggle'
            React.DOM.div
              className: 'blue pointer'
              onClick: @setIntention
              'data-intention': 'affirmation'
              "Give 'props' and point out something awesome "
              React.DOM.i
                className: 'fa fa-fighter-jet hover-toggle'
            React.DOM.div
              className: 'blue pointer'
              onClick: @setIntention
              'data-intention': 'unstructured'
              "Give general unstructured feedback "
              React.DOM.i
                className: 'fa fa-plane hover-toggle'

  render: () ->
    React.DOM.tr
      className: 'comment-input'
      React.DOM.td
        className: 'no-right-borders'
      React.DOM.td
        className: 'no-right-borders'
      React.DOM.td
        className: null
        React.DOM.div
          className: 'row'
          React.DOM.div
            className: 'col-sm-10'
            @renderIdentifyAntipattern()
