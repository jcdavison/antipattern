@commentFeedbackInterface = React.createClass

  componentDidMount: () ->
    # console.log @props.data

  getInitialState: () ->
    upVotes: @props.data.voteSummary.up_votes
    downVotes: @props.data.voteSummary.down_votes

  componentWillReceiveProps: (newProps) ->
    @setState upVotes: newProps.data.voteSummary.up_votes
    @setState downVotes: newProps.data.voteSummary.down_votes

  voteParams: (voteType) ->
    value = 1 if voteType == 'upVote'
    value = -1 if voteType == 'downVote'
    { value: value , sentiment: @props.data.sentiment, commentId: @props.data.commentId }

  submitVote: (params) ->
    @props.data.submitVote(params)

  render: () ->
    React.DOM.span
      className: 'comment-feedback-button'
      React.DOM.span
        className: 'comment-sentiment-downvote'
        onClick: @submitVote.bind(@, @voteParams('downVote'))
        "#{@state.downVotes} - | "
      React.DOM.span
        className: null
        @props.data.sentiment
      React.DOM.span
        className: 'comment-sentiment-upvote'
        onClick: @submitVote.bind(@, @voteParams('upVote'))
        " | + #{@state.upVotes}"
