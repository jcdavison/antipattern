@commentDisplay = React.createClass

  getInitialState: () ->
    comment: @props.data.comment

  componentDidMount: () ->

  render: () ->
    React.DOM.tr
      className: null
      React.DOM.td
        className: 'code-review comment borders'
        colSpan: '3'
        React.DOM.div
          className: 'row fixed-line-14'
          React.DOM.div
            className: 'col-sm-10 center-block no-float'
            @state.comment.body
