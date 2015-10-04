@fileDisplay = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    patches: @calculateStartingPosition(@props.data.file.patches)
    comments: @props.data.file.comments
    fileName: @props.data.file.filename

  componentDidMount: () ->

  calculateStartingPosition: (patches) ->
    for patch, index in patches
      if index == 0
        patch.initialPosition = 0
      else
        patch.initialPosition = (patches[index - 1].length + patches[index - 1].initialPosition)
    patches

  render: () ->
    React.DOM.div
      className: null
      React.DOM.div
        className: 'row top-margined'
        React.DOM.div
          className: 'col-sm-10 center-block no-float'
          React.DOM.h4
            className: 'blue'
            @state.fileName
          React.DOM.table
            className: 'patch-display borders'
            @state.fileName
            for patch, index in @state.patches
              React.createElement patchDisplay, key: "patch-#{index}", data: patch: patch, comments: @state.comments
