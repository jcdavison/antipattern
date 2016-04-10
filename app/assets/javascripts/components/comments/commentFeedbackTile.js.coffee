@commentFeedbackTile = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    comment: @props.data.commentObj.comment
    repo: @props.data.commentObj.repo
    updated_at: moment(@props.data.commentObj.comment.updated_at).format("M/D/YY HH:MM:SS")
    displayFeedbackTools: false
    sentimentSummary: {}

  componentDidMount: () ->
    @getCommentSentimentSummary()

  getCommentSentimentSummary: () ->
    $.ajax(
      type: 'GET'
      url: "/api/comments/#{@props.data.commentObj.comment.id}/sentiments"
      success: (data) =>
        @setState sentimentSummary: data.sentiments_vote_summary
    ) 

  submitVote: (voteParams) ->
    $.ajax(
      type: 'POST'
      url: "/api/comments/#{@props.data.commentObj.comment.id}/sentiments"
      data: voteParams
      success: () =>
        @getCommentSentimentSummary()
    ) 

  render: () ->
    React.DOM.div
      className: 'comment-feedback-tile'
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-10'
          React.DOM.span
            className: 'blue'
            "#{@state.updated_at} "
          React.DOM.span
            className: 'green'
            React.DOM.a
              href: @props.data.commentObj.comment.html_url
              target: 'new'
              "original comment"
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-12'
          dangerouslySetInnerHTML: {__html: marked(@state.comment.body)}
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-sm-12 center-block no-float'
          React.DOM.div
            className: 'comment-feedback-interface'
            for sentiment, voteSummary of @state.sentimentSummary
              React.createElement commentFeedbackInterface, key: "comment-interface-#{sentiment}", data: voteSummary: voteSummary, sentiment: sentiment, commentId: @props.data.commentObj.comment.id, submitVote: @submitVote
