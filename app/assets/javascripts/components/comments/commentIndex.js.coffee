@commentIndex = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    comments: @props.data.commentObjects

  componentDidMount: () ->
    console.log @state.comments

  render: () ->
    React.DOM.div
      className: 'comment-index'
