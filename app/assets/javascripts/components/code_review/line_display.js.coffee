@lineDisplay = React.createClass

  getInitialState: () ->
    lineType: @props.data.line.lineType
    deleteIndex: @props.data.line.deleteIndex
    addIndex: @props.data.line.addIndex
    content: @props.data.line.content
    comments: @props.data.line.comments
    position: @props.data.line.position
    showCommentInput: false

  componentDidMount: () ->

  lineColor: () ->
    if @props.data.line.lineType == 'addition'
      return 'green-row'
    if @props.data.line.lineType == 'deletion' 
      return 'red-row'

  renderComments: () ->
    for comment, index in @state.comments
      React.createElement commentDisplay, key: "comment-#{index}", data: comment: comment

  renderCommentInput: (e) ->
    @setState showCommentInput: ! @state.showCommentInput

  commentInputKey: () ->
    "comment-input-#{@props.data.commitInfo.commitSha}-#{@position}"

  renderFoo: () ->
      if @state.lineType == 'deletion'
        return React.DOM.tbody
          className: null
          React.DOM.tr
            className: "patch-line #{@lineColor()}"
            React.DOM.td
              className: 'delete-line-num'
              @state.deleteIndex
            React.DOM.td
              className: 'addition-line-num'
              ''
            React.DOM.td
              className: 'code line'
              React.DOM.span
                className: null
                React.DOM.i
                  className: 'fa fa-plus-square blue add-comment'
                  onClick: @renderCommentInput
              @state.content
          for comment, commentIndex in @state.comments
            React.createElement commentDisplay, key: "comment-#{commentIndex}", data: comment: comment
          if @state.showCommentInput
            React.createElement commentInput, key: "#{@commentInputKey()}", data: position: @state.position, commitSha: @props.data.commitInfo.commitSha, fileName: @props.data.commitInfo.fileName, repo: @props.data.commitInfo.repo
      if @state.lineType == 'addition'
        return React.DOM.tbody
          className: null
          React.DOM.tr
            className: "patch-line #{@lineColor()}"
            React.DOM.td
              className: 'delete-line-num'
              ''
            React.DOM.td
              className: 'addition-line-num'
              @state.addIndex
            React.DOM.td
              className: 'code line'
              React.DOM.span
                className: null
                React.DOM.i
                  className: 'fa fa-plus-square blue add-comment'
                  onClick: @renderCommentInput
              @state.content
          for comment, commentIndex in @state.comments
            React.createElement commentDisplay, key: "comment-#{commentIndex}", data: comment: comment
          if @state.showCommentInput
            React.createElement commentInput, key: "#{@commentInputKey()}", data: position: @state.position, commitSha: @props.data.commitInfo.commitSha, fileName: @props.data.commitInfo.fileName, repo: @props.data.commitInfo.repo
      if @state.lineType == 'display'
        return React.DOM.tbody
          className: null
          React.DOM.tr
            className: "patch-line #{@lineColor()}"
            React.DOM.td
              className: 'display-deletion-line-num'
              @state.deleteIndex
            React.DOM.td
              className: 'display-addition-line-num'
              @state.addIndex
            React.DOM.td
              className: 'code line'
              React.DOM.span
                className: null
                React.DOM.i
                  className: 'fa fa-plus-square blue add-comment'
                  onClick: @renderCommentInput
              @state.content
          for comment, commentIndex in @state.comments
            React.createElement commentDisplay, key: "comment-#{commentIndex}", data: comment: comment
          if @state.showCommentInput
            React.createElement commentInput, key: "#{@commentInputKey()}", data: position: @state.position, commitSha: @props.data.commitInfo.commitSha, fileName: @props.data.commitInfo.fileName, repo: @props.data.commitInfo.repo

  render: () ->
    if @state.lineType == 'patchInfo' 
      React.DOM.tr
        className: null
        React.DOM.th
          className: null
          colSpan: '3'
          @state.content
    else
      @renderFoo()
