@fileDisplay = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    patches: @calculateStartingPosition(@props.data.file.patches)
    comments: @props.data.file.comments
    fileName: @props.data.file.filename
    commitSha: @props.data.info.commitSha
    repo: @props.data.info.repo

  componentDidMount: () ->

  componentWillReceiveProps: (newProps) ->
    newPatches = newProps.data.file.patches
    @setState patches: @calculateStartingPosition(newPatches)
    @setState comments: newProps.data.file.comments

  commitInfo: () ->
    { commitSha: @state.commitSha, fileName: @state.fileName, repo: @state.repo }

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
        className: 'row top-margined no-horizontal-margin'
        React.DOM.div
          className: 'col-sm-12 patch-file-container no-horizontal-padding top-margined'
          React.DOM.div
            className: 'black top-radius light_grey_background top-left-pad'
            @state.fileName
          for patch, index in @state.patches
            React.createElement patchDisplay, key: "patch-#{index}", data: patch: patch, comments: @state.comments, commitInfo: @commitInfo(), owner: @props.data.owner, currentUser: @props.data.currentUser
