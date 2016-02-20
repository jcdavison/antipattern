@commentFeedbackInterface = React.createClass

  componentDidMount: () ->


  render: () ->
    React.DOM.div
      className: 'comment-feedback-interface'
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-2 centered'
          'informative'
        React.DOM.div
          className: 'col-sm-2 centered'
          'succint'
        React.DOM.div
          className: 'col-sm-2 centered'
          'ambiguous'
        React.DOM.div
          className: 'col-sm-2 centered'
          'kind'
        React.DOM.div
          className: 'col-sm-2 centered'
          'motivating'
        React.DOM.div
          className: 'col-sm-2 centered'
          'harsh'
