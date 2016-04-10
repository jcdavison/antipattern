@commentIndex = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    commentThreads: @props.data.commentThreads
    hasComments: false

  componentDidMount: () ->

  render: () ->
    React.DOM.div
      className: null
      for commentThreadSha, comments of @state.commentThreads 
        React.createElement commentThread, key: "commentThread-#{commentThreadSha}", data: commentThreadSha: commentThreadSha, comments: comments

