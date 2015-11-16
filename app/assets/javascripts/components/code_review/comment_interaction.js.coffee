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
    currentUser: @props.data.currentUser || {}
    upVotes: ''
    upVoteStatus: ''
    downVotes: ''
    downVoteStatus: ''
    voteableType: 'Comment'
    voteableId: @props.data.comment.id

  insertIfCan: (str) ->
    if @state.comment.user.login == @state.currentUser.githubUsername
      return ''
    else
      return str

  vote: (e) ->
    value = e.currentTarget.dataset.voteValue
    $.post(
      '/api/votes', 
      vote: 
        value: value
        voteableType: @state.voteableType
        voteableId: @state.voteableId
    )
    .success( 
      (response) =>
        console.log response
    )


  render: () ->
    React.DOM.div
      className: 'pull-right vote-interface foo-small'
      React.DOM.span
        className: null 
        "{ "
        React.DOM.div
          className: "#{@insertIfCan('upvote pointer')} inline"
          onClick: @vote
          'data-vote-value': 1
          React.DOM.i
            className: "fa fa-thumbs-up light-blue inline upvote"
          React.DOM.span
            className: @state.upVoteStatus
            ": #{@state.upVotes}"
      React.DOM.span
        className: null 
        " , "
      React.DOM.div
        className: "#{@insertIfCan('downvote pointer')} inline"
        React.DOM.span
          React.DOM.i
            className: "fa fa-thumbs-down light-red downvote"
            'data-vote-value': -1
            onClick: @vote
        React.DOM.span
          className: @state.downVoteStatus
          ": #{@state.downVotes}"
      React.DOM.span
        className: null 
        " }"
