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
          className: 'col-sm-6'
          "commit: #{@props.data.commentThreadSha}"
        React.DOM.div
          className: 'col-sm-6'
          "repo: #{@state.repo}"
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-11 col-sm-offset-1 small-top-margined'
          for commentObj, index in @state.comments
            React.createElement commentFeedbackTile, key: "comment-feedback-#{index}-#{@props.data.commentThreadSha}", data: commentObj: commentObj
