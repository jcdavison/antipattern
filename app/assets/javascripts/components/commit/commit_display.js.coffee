@commitDisplay = React.createClass

  getInitialState: () ->
    includedFiles: @props.data.commit.files
    info: @props.data.commit.info

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  render: () ->
    React.DOM.div
      className: null
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-3'
          'committ by ' + @state.info.committer.name
        React.DOM.div
          className: 'col-sm-9'
          'commit message ' + "'#{@state.info.message}'"
      for file, index in @state.includedFiles
        React.createElement patchedFileDisplay, key: "patch-#{index}", data: file: file, index: index
