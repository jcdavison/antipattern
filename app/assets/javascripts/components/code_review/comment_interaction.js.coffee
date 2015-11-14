@commentInteraction = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  componentDidMount: () ->
    @getCommentStats()

  getCommentStats: () ->
    $.get(
      '/api/comments', 
      github_id: @state.comment.github_id
    )
    .success( 
      (response) =>
        @setState upVotes: response.comment.voteCount.upVotes
        @setState downVotes: response.comment.voteCount.downVotes
    )

  getInitialState: () ->
    comment: @props.data.comment
    upVotes: ''
    upVoteStatus: 'green'
    downVotes: ''
    downVoteStatus: 'green'

  render: () ->
    React.DOM.div
      className: 'pull-right green-bottom-border'
      React.DOM.span
        className: @state.upVoteStatus
        "upVotes: #{@state.upVotes}"
      React.DOM.span
        className: @state.downVoteStatus
        " downVotes: #{@state.downVotes}"
