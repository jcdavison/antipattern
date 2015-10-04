@lineDisplay = React.createClass

  getInitialState: () ->
    lineType: @props.data.line.lineType
    deleteIndex: @props.data.line.deleteIndex
    addIndex: @props.data.line.addIndex
    content: @props.data.line.content
    comments: @props.data.line.comments

  componentDidMount: () ->

  setRowColor: () ->
    if @props.data.line.lineType == 'addition'
      return 'green-row'
    if @props.data.line.lineType == 'deletion' 
      return 'red-row'

  renderComments: () ->
    for comment, index in @state.comments
      React.createElement commentDisplay, key: "comment-#{index}", data: comment: comment

  renderFoo: () ->
      if @state.lineType == 'deletion'
        return React.DOM.tbody
          className: null
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
          for comment, commentIndex in @state.comments
            React.createElement commentDisplay, key: "comment-#{commentIndex}", data: comment: comment
      if @state.lineType == 'addition'
        return React.DOM.tbody
          className: null
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
          for comment, commentIndex in @state.comments
            React.createElement commentDisplay, key: "comment-#{commentIndex}", data: comment: comment
      if @state.lineType == 'display'
        return React.DOM.tbody
          className: null
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
            for comment, commentIndex in @state.comments
              React.createElement commentDisplay, key: "comment-#{commentIndex}", data: comment: comment

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
