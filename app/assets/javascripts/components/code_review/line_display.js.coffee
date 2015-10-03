@lineDisplay = React.createClass

  getInitialState: () ->
    lineType: @props.data.line.lineType
    deleteIndex: @props.data.line.deleteIndex
    addIndex: @props.data.line.addIndex
    content: @props.data.line.content

  componentDidMount: () ->

  displayLineIndeces: () ->

  setRowColor: () ->
    if @props.data.line.lineType == 'addition'
      return 'green-row'
    if @props.data.line.lineType == 'deletion' 
      return 'red-row'

  render: () ->
    if @state.lineType == 'patchInfo' 
      React.DOM.thead
        className: null
        React.DOM.tr
          className: null
          React.DOM.th
            className: null
            colSpan: '3'
            @state.content
    else
      React.DOM.tbody
        className: null
        if @state.lineType == 'deletion'
          React.DOM.tr
            className: @setRowColor()
            React.DOM.td
              className: 'delete-line-num'
              @state.deleteIndex
            React.DOM.td
              className: 'addition-line-num'
              ''
            React.DOM.td
              className: 'code line'
              @state.content
        if @state.lineType == 'addition'
          React.DOM.tr
            className: @setRowColor()
            React.DOM.td
              className: 'delete-line-num'
              ''
            React.DOM.td
              className: 'addition-line-num'
              @state.addIndex
            React.DOM.td
              className: 'code line'
              @state.content
        if @state.lineType == 'display'
          React.DOM.tr
            className: @setRowColor()
            React.DOM.td
              className: 'display-deletion-line-num'
              @state.deleteIndex
            React.DOM.td
              className: 'display-addition-line-num'
              @state.addIndex
            React.DOM.td
              className: 'code line'
              @state.content
