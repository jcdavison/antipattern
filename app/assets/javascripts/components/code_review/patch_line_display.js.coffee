@patchLineDisplay = React.createClass

  getInitialState: () ->
    line: @props.data.line

  componentDidMount: () ->
    # console.log @state.line

  displayLineIndeces: () ->

  setRowColor: () ->
    if @props.data.line.lineType == 'addition'
      return 'green-row'
    if @props.data.line.lineType == 'deletion' 
      return 'red-row'

  render: () ->
    if @state.line.lineType == 'patchInfo' 
      React.DOM.thead
        className: null
        React.DOM.tr
          className: null
          React.DOM.th
            className: null
            colSpan: '3'
            @state.line.content
    else
      React.DOM.tbody
        className: null
        if @state.line.lineType == 'deletion'
          React.DOM.tr
            className: @setRowColor()
            React.DOM.td
              className: 'delete-line-num'
              @state.line.deletionIndex
            React.DOM.td
              className: 'addition-line-num'
              ''
            React.DOM.td
              className: 'code line'
              @state.line.content
        if @state.line.lineType == 'addition'
          React.DOM.tr
            className: @setRowColor()
            React.DOM.td
              className: 'delete-line-num'
              ''
            React.DOM.td
              className: 'addition-line-num'
              @state.line.additionIndex
            React.DOM.td
              className: 'code line'
              @state.line.content
        if @state.line.lineType == 'display'
          React.DOM.tr
            className: @setRowColor()
            React.DOM.td
              className: 'display-deletion-line-num'
              @state.line.deletionIndex
            React.DOM.td
              className: 'display-addition-line-num'
              @state.line.additionIndex
            React.DOM.td
              className: 'code line'
              @state.line.content
