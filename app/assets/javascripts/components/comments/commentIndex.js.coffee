@commentIndex = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    commentThreads: []
    intervalId: null
    showPlaceholder: true

  componentDidMount: () ->
    if @props.data.commentThreads == 'in_progress'
      @setState intervalId: setInterval(@getCommentThreads, 3000)
    else
      @setState commentThreads: @props.data.commentThreads
      @setState showPlaceholder: false

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
      if @state.showPlaceholder == true
        React.DOM.div
          className: 'blue medium-small centered'
          React.DOM.span
            'Your comment feed is queueing ('
          React.DOM.i
            className: 'fa fa-spinner fa-spin'
          React.DOM.span
            ') and will display momentarily.'
      if @state.showPlaceholder == false && Object.keys(@state.commentThreads).length > 0
        React.DOM.div
          className: null
          React.DOM.a
            className: 'foo-small'
            href: '/comment-feedback?updateCache=true'
            'update comment feed'
          for commentThreadSha, comments of @state.commentThreads 
            React.createElement commentThread, key: "commentThread-#{commentThreadSha}", data: commentThreadSha: commentThreadSha, comments: comments
      if @state.showPlaceholder == false && Object.keys(@state.commentThreads).length == 0
        React.DOM.div
          className: 'null'
          React.DOM.div
            className: 'foo-small blue'
            'Yikes, seems like your repositories do not have reviewable comments in the last 45 days.'
          React.DOM.div
            className: 'null'
            React.DOM.span
              className: 'foo-small blue'
              'This is an excellent time to '
            React.DOM.a
              className: 'foo-small red' 
              href: '/code-reviews'
              ' request a code review'
            React.DOM.span
              className: 'foo-small blue'
              ' or '
            React.DOM.a
              className: 'foo-small red'
              href: '/comment-feedback?updateCache=true'
              'update your comment feed.'
