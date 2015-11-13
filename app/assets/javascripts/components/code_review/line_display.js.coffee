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
    if @state.comments.length >= 1
      console.log 'line display comment', @state.comments

  componentWillReceiveProps: (newProps) ->
    @setState lineType: newProps.data.line.lineType
    @setState deleteIndex: newProps.data.line.deleteIndex
    @setState addIndex: newProps.data.line.addIndex
    @setState content: newProps.data.line.content
    @setState comments: newProps.data.line.comments
    @setState position: newProps.data.line.position
    PubSub.publish 'enableCommentButton'

  toggleCommentInput: () ->
    @setState showCommentInput: ! @state.showCommentInput

  lineColor: () ->
    if @props.data.line.lineType == 'addition'
      return 'green-row'
    if @props.data.line.lineType == 'deletion' 
      return 'red-row'

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
      React.DOM.tbody
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
          React.createElement commentInput, key: "#{@commentInputKey()}", toggleCommentInput: @toggleCommentInput, data: position: @state.position, commitSha: @props.data.commitInfo.commitSha, fileName: @props.data.commitInfo.fileName, repo: @props.data.commitInfo.repo, owner: @props.data.owner, currentUser: @props.data.currentUser
