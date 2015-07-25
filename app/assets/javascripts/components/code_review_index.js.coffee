@codeReviewIndex = React.createClass

  getDefaultProps: () ->
    products: []
    helpers: window.ReactHelpers

  getInitialState: ->
    codeReviews: @props.data.codeReviews

  componentDidMount: () ->

  render: () ->
    React.DOM.div
      className: 'code-review-index'
      for codeReview, index in @props.data.codeReviews
        React.createElement indexSummary, key: "#{index}-summary" , data: {codeReview: codeReview }
