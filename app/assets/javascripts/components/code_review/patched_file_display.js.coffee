@patchedFileDisplay = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    file: @props.data.file
    patch: @props.data.file.patch
    lineIndexStats: @extractPatchStats(@props.data.file)
    index: @props.data.index
    patchLinesWithIndeces: []

  componentDidMount: () ->
    @computePatchIndeces()

  computePatchIndeces: () ->
    objects = []
    for line, patchLineIndex in @state.patch
      lineType = @setLineType(line)
      lineIndeces = @calculateLineIndeces(line, lineType, patchLineIndex, objects)
      obj = $.extend { content: line, lineType: lineType }, (lineIndeces)
      objects.push obj
    @setState patchLinesWithIndeces: objects

  calculateLineIndeces: (line, lineType, patchLineIndex, patchLinesWithIndeces) ->
    if lineType == 'patchInfo'
      deletionIndex: @state.lineIndexStats.baseDeletionIndex,
      additionIndex: @state.lineIndexStats.baseAdditionIndex 
    else 
      precedingDeleteIndex = patchLinesWithIndeces[patchLineIndex - 1].deletionIndex
      precedingAdditionIndex = patchLinesWithIndeces[patchLineIndex - 1].additionIndex
      if lineType == 'addition'
        return {additionIndex: precedingAdditionIndex + 1, deletionIndex: precedingDeleteIndex}
      if lineType == 'deletion'
        return  { deletionIndex: precedingDeleteIndex + 1, additionIndex: precedingAdditionIndex }
      if lineType == 'display'
        return { deletionIndex: precedingDeleteIndex + 1, additionIndex: precedingAdditionIndex  + 1}

  setLineType: (line) ->
    return 'patchInfo' if line.match(/@@.+@@/) 
    return 'addition' if line[0] == '+'
    return 'deletion' if line[0] == '-'
    return 'display'

  extractPatchStats: (file) ->
    baseStatsBlob = file.patch[0].split("@@")[1].split(' ')
    baseDeletionStats = baseStatsBlob[1].split(',')
    baseAdditionStats = baseStatsBlob[2].split(',')
    { 
      baseDeletionIndex: Number(baseDeletionStats[0].slice(1)),
      baseDeletionCount: Number(baseDeletionStats[1]),
      baseAdditionIndex: Number(baseAdditionStats[0].slice(1)),
      baseAdditionCount: Number(baseAdditionStats[1])
    }

  render: () ->
    React.DOM.div
      className: null
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-10 center-block no-float'
          React.DOM.table
            className: 'patch-display'
            for lineObj, index in @state.patchLinesWithIndeces
              React.createElement patchLineDisplay, key: "patch-line-#{index}", data: line: lineObj
