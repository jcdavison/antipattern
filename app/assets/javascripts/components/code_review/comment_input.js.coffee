@commentInput = React.createClass

  getInitialState: () ->
    comment: '' 
    commitSha: @props.data.commitSha
    fileName: @props.data.fileName
    position: @props.data.position
    repo: @props.data.repo
    owner: @props.data.owner
    currentUser: @props.data.currentUser

  componentDidMount: () ->
    PubSub.subscribe 'enableCommentButton', @toggleButton

  updateComment: (e) ->
    @setState comment: e.target.value

  postableComment: () ->
    comment: 
      body: @state.comment
      sha: @state.commitSha
      path: @state.fileName
      position: @state.position
      repo: @state.repo
      commitOwner: @state.owner.githubUsername

  toggleButton: () ->
    currentState = $('button.comment-input').prop('disabled')
    $('button.comment-input').prop('disabled', ! currentState)

  postComment: (e) ->
    $.post(
      '/api/comments', 
      @postableComment()
    )
    .success( (obj) =>
      PubSub.publish 'updateCommit'
      @setState comment: ''
    )
    .error( (response) =>
      @toggleButton()
    )

  renderComment: (comment) ->

  clickSubmit: (e) ->
    e.preventDefault()
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
            React.DOM.form
              className: 'create-comment form-inline pull-right'
              React.DOM.div
                className: null 
                React.DOM.textarea
                  className: 'comment-anti-pattern form-control'
                  cols: '90'
                  rows: '5'
                  placeholder: 'Enter some valuable feedback here.'
                  value: @state.comment
                  onChange: @updateComment
              @renderRelevantButton()
