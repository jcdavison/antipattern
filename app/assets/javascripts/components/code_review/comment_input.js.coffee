@commentInput = React.createClass

  getInitialState: () ->
    comment: '' 
    commitSha: @props.data.commitSha
    fileName: @props.data.fileName
    position: @props.data.position
    repo: @props.data.repo

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
                className: 'form-group'
                React.DOM.input
                  className: 'comment-anti-pattern form-control'
                  type: 'text'
                  placeholder: 'comment here'
                  value: @state.comment
                  onChange: @updateComment
              React.DOM.button
                type: 'submit'
                className: 'btn btn-default accept form-control comment-input'
                onClick: @clickSubmit
                'comment'
