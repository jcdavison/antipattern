@commentDisplay = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    comment: @props.data.comment

  componentDidMount: () ->

  componentWillReceiveProps: (newProps) ->
    @setState comment: newProps.data.comment

  render: () ->
    React.DOM.tr
      className: null
      React.DOM.td
        className: 'no-right-borders'
      React.DOM.td
        className: 'no-right-borders'
      React.DOM.td
        className: null
        React.DOM.div
          className: 'row fixed-line-10'
          React.DOM.div
            className: 'col-sm-10'
            React.DOM.div
              className: 'comment-container rounded'
              React.DOM.div
                className: 'top-radius ultra-light-blue-background comment-element'
                "#{@state.comment.user.login} commented on #{@props.helpers.date(@state.comment.created_at)}"
              React.DOM.div
                className: 'bottom-radius comment-element'
                @state.comment.body
