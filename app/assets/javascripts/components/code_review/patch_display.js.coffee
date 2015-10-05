@patchDisplay = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    patch: @props.data.patch
    baseLineIndeces: @extractBaseIndeces(@props.data.patch)
    comments: @extractComments(@props.data.comments)
    lines: []

  componentDidMount: () ->
    @setState lines: @evaluateLines(@props.data.patch)

  extractBaseIndeces: (patch) ->
    patchInfo = patch[0].split("@@")[1].split(' ')
    baseAddInfo = patchInfo[2].split(',')
    baseDeleteInfo = patchInfo[1].split(',')
    { 
      addIndex: Number(baseAddInfo[0].slice(1))
      addCount: Number(baseAddInfo[1])
      deleteIndex: Number(baseDeleteInfo[0].slice(1))
      deleteCount: Number(baseDeleteInfo[1])
    }

  extractComments: (comments) ->
    positions = {}
    for comment in comments
      if positions["#{comment.position}"]
        positions["#{comment.position}"].push comment
      else
        positions["#{comment.position}"] = [comment]
    positions

  evaluateLines: (patch) ->
    lines = []
    for line, lineIndex in patch
      lineType = @setLineType(line)
      lineIndeces = @calculateLineIndeces(line, lineType, lineIndex, lines)
      comments = @grabComments(lineIndex)
      lineObj = $.extend { content: line, lineType: lineType }, lineIndeces, comments
      lines.push lineObj
    lines

  grabComments: (lineIndex) ->
    position = lineIndex + @state.patch.initialPosition
    comments = []
    if @state.comments[position]
      comments = @state.comments[position]
    {comments: comments, position: position}

  calculateLineIndeces: (line, lineType, lineIndex, linesWithIndeces) ->
    if lineType == 'patchInfo'
      deleteIndex: @state.baseLineIndeces.deleteIndex - 1
      addIndex: @state.baseLineIndeces.addIndex - 1
    else 
      precedingDeleteIndex = linesWithIndeces[lineIndex - 1].deleteIndex
      precedingAddIndex = linesWithIndeces[lineIndex - 1].addIndex
      if lineType == 'addition'
        return { addIndex: precedingAddIndex + 1, deleteIndex: precedingDeleteIndex }
      if lineType == 'deletion'
        return { addIndex: precedingAddIndex , deleteIndex: precedingDeleteIndex + 1 }
      if lineType == 'display'
        return { addIndex: precedingAddIndex  + 1, deleteIndex: precedingDeleteIndex + 1 }

  setLineType: (line) ->
    return 'patchInfo' if line.match(/@@.+@@/) 
    return 'addition' if line[0] == '+'
    return 'deletion' if line[0] == '-'
    return 'display'

  render: () ->
    React.DOM.table
      className: 'patch-display borders'
      for line, index in @state.lines
        React.createElement lineDisplay, key: "line-#{index}", data: line: line, commitInfo: @props.data.commitInfo
