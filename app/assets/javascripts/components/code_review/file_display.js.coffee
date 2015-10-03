@fileDisplay = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    patch: @props.data.file.patch
    baseLineIndeces: @extractBaseIndeces(@props.data.file)
    comments: @extractComments(@props.data.file)
    lines: []

  componentDidMount: () ->
    @extractComments(@props.data.file)
    @setState lines: @evaluateLines(@props.data.file.patch)

  extractComments: (file) ->
    ids = {}
    for comment in file.comments
      if ids["#{comment.line}"]
        ids["#{comment.line}"].push comment
      else
        ids["#{comment.line}"] = [comment]
    ids

  evaluateLines: (patch) ->
    lines = []
    for line, lineIndex in patch
      lineType = @setLineType(line)
      lineIndeces = @calculateLineIndeces(line, lineType, lineIndex, lines)
      comments = @grabComments(lineIndeces, lineType)
      lineObj = $.extend { content: line, lineType: lineType }, lineIndeces, comments
      lines.push lineObj
    lines

  grabComments: (lineIndeces, lineType) ->
    comments = null
    if lineType == 'addition' && @state.comments[lineIndeces.addIndex]
      comments = @state.comments[lineIndeces.addIndex]
      delete @state.comments[lineIndeces.deleteIndex]
    if lineType == 'deletion' && @state.comments[lineIndeces.deleteIndex]
      comments = @state.comments[lineIndeces.deleteIndex]
      delete @state.comments[lineIndeces.deleteIndex]
    {comments: comments || []}

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

  extractBaseIndeces: (file) ->
    patchInfo = file.patch[0].split("@@")[1].split(' ')
    baseAddInfo = patchInfo[2].split(',')
    baseDeleteInfo = patchInfo[1].split(',')
    { 
      addIndex: Number(baseAddInfo[0].slice(1))
      addCount: Number(baseAddInfo[1])
      deleteIndex: Number(baseDeleteInfo[0].slice(1))
      deleteCount: Number(baseDeleteInfo[1])
    }

  render: () ->
    React.DOM.div
      className: null
      React.DOM.div
        className: 'row top-margined'
        React.DOM.div
          className: 'col-sm-10 center-block no-float'
          React.DOM.table
            className: 'patch-display borders'
            for line, index in @state.lines
              React.createElement lineDisplay, key: "patch-line-#{index}", data: line: line
