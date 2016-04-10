@commentThread = React.createClass

  getInitialState: () ->
    comments: @props.data.comments
    repo: @props.data.comments[0].repo.name

  componentDidMount: () ->

  render: () ->
    React.DOM.div
      className: 'comment-thread-tile'
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-10 foo-small'
          React.DOM.span
            className: 'grey'
            "commit: " 
          React.DOM.span
            className: 'blue'
            " #{@props.data.commentThreadSha}"
          React.DOM.span
            className: 'grey'
            " repository:" 
          React.DOM.span
            className: 'blue'
            " #{@state.repo} " 
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-12 '
          for commentObj, index in @state.comments
            React.createElement commentFeedbackTile, key: "comment-feedback-#{index}-#{@props.data.commentThreadSha}", data: commentObj: commentObj
