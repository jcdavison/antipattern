@commentFeedbackTile = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    comment: @props.data.commentObj.comment
    repo: @props.data.commentObj.repo
    updated_at: moment(@props.data.commentObj.comment.updated_at).format("M/D/YY HH:MM:SS")
    displayFeedbackTools: false

  componentDidMount: () ->

  render: () ->
    React.DOM.div
      className: 'pointer comment-feedback-tile'
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-10 blue'
          "#{@state.updated_at}"
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-12'
          dangerouslySetInnerHTML: {__html: marked(@state.comment.body)}
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-12'
          React.createElement commentFeedbackInterface, data: commentObj: @props.data.commentObj
