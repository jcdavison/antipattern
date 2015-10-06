@lineDisplay = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

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

  renderIndex: (displayRow) ->
    if @state.lineType == 'deletion'
      if displayRow == 'delete'
        return @state.deleteIndex
      if displayRow == 'addition'
        return ''
    if @state.lineType == 'addition'
      if displayRow == 'delete'
        return ''
      if displayRow == 'addition'
        return @state.addIndex
    if @state.lineType == 'display'
      if displayRow == 'delete'
        return @state.deleteIndex
      if displayRow == 'addition'
        return @state.addIndex

  renderLine: () ->
    return React.DOM.tbody
      className: null
      React.DOM.tr
        className: "patch-line #{@lineColor()}"
        React.DOM.td
          className: 'line-index'
          @renderIndex('delete')
        React.DOM.td
          className: 'line-index'
          @renderIndex('addition')
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
          className: 'ultra-light-blue-background'
        React.DOM.th
          className: 'ultra-light-blue-background'
        React.DOM.th
          className: 'ultra-light-blue-background left-padd'
          @state.content
    else
      @renderLine()
