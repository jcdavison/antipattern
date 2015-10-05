@commitDisplay = React.createClass

  getInitialState: () ->
    files: @props.data.commit.files
    info: @props.data.commit.info

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  componentDidMount: () ->

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
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-12 blue'
          React.DOM.a
            href: @state.info.tree.url
            className: 'blue'
            target: "_blank"
            @state.info.tree.sha
      for file, index in @state.files
        React.createElement fileDisplay, key: "patch-#{index}", data: file: file, info: @state.info
