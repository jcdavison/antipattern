@commentIndex = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    commentThreads: []
    intervalId: null
    showPlaceholder: true

  componentDidMount: () ->

  componentWillReceiveProps: (newProps) ->
    @setState commentThreads: newProps.data.commentThreads

  getCommentThreads: () ->
    $.ajax(
      type: 'GET'
      url: "/api/comments-index"
      success: (data) =>
        if data.commentThreads != 'in_progress'
          @setState showPlaceholder: false
          @setState commentThreads: data.commentThreads
          clearInterval(@state.intervalId)
      ) 

  render: () ->
    React.DOM.div
      className: null
      if Object.keys(@state.commentThreads).length > 0
        React.DOM.div
          className: null
          for commentThreadSha, comments of @state.commentThreads 
            React.createElement commentThread, key: "commentThread-#{commentThreadSha}", data: commentThreadSha: commentThreadSha, comments: comments
