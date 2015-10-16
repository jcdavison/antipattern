@codeReviewIndex = React.createClass

  getDefaultProps: () ->
    products: []
    helpers: window.ReactHelpers

  getInitialState: ->
    codeReviews: @props.data.codeReviews

  fetchCodeReviews: () ->
    $.get '/api/reviews', {}
      .success( (response) =>
        @setState codeReviews: response.codeReviews
      ) 

  componentDidMount: () ->
    PubSub.subscribe 'refresh-code-review-index', @fetchCodeReviews

  render: () ->
    React.DOM.div
      className: 'code-review-index'
      for codeReview, index in @state.codeReviews
        React.createElement indexSummary, key: "#{index}-summary" , data: {codeReview: codeReview }
