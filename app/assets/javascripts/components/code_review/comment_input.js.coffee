@commentInput = React.createClass

  getInitialState: () ->
    comment: '' 
    commitSha: @props.data.commitSha
    fileName: @props.data.fileName
    position: @props.data.position
    repo: @props.data.repo

  componentDidMount: () ->

  updateComment: (e) ->
    @setState comment: e.target.value

  postableComment: () ->
    comment: 
      body: @state.comment
      sha: @state.commitSha
      path: @state.fileName
      position: @state.position
      repo: @state.repo

  postComment: () ->
    $.post(
      '/api/comments', 
      @postableComment()
    ).success( 
      (obj) =>
        @setState comment: ''
    ).error(
      (response) ->
    )

  renderComment: (comment) ->

  clickSubmit: (e) ->
    e.preventDefault()
    @postComment()

  render: () ->
    React.DOM.tr
      className: 'comment-input'
      React.DOM.td
        colSpan: 3
        className: null
        React.DOM.div
          className: 'row'
          React.DOM.div
            className: 'col-sm-10 center-block no-float'
            React.DOM.form
              className: 'create-comment'
              React.DOM.input
                className: 'comment-anti-pattern'
                type: 'text'
                placeholder: 'comment here'
                value: @state.comment
                onChange: @updateComment
              React.DOM.button
                type: 'submit'
                className: 'btn btn-continue'
                onClick: @clickSubmit
                'comment'
