@commentThread = React.createClass

  getInitialState: () ->
    comments: @props.data.comments
    repo: @props.data.comments[0].repo

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
            "commit sha: " 
          React.DOM.span
            className: 'blue'
            " #{@props.data.commentThreadSha}"
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-12 '
          for commentObj, index in @state.comments
            React.createElement commentFeedbackTile, key: "comment-feedback-#{index}-#{@props.data.commentThreadSha}", data: commentObj: commentObj
