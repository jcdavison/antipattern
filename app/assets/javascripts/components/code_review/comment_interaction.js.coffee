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
        @setVoteableCss(response.currentUserVote)
        @setState upVoteCount: response.comment.voteCount.upVotes
        @setState downVoteCount: response.comment.voteCount.downVotes
    )

  setVoteableCss: (currentUserVote) ->
    if currentUserVote == null
      @setState upVoteableCss: 'upvoteable'
      @setState downVoteableCss: 'downvoteable'
      return
    if currentUserVote.value == 1
      @setState upVoteableCss: 'upvoted'
      @setState downVoteableCss: 'downvoteable'
    if currentUserVote.value == -1
      @setState upVoteableCss: 'upvoteable'
      @setState downVoteableCss: 'downvoted'

  refreshSelf: (voteData) ->
    @getCommentStats()

  getInitialState: () ->
    comment: @props.data.comment
    currentUser: @props.data.currentUser
    upVoteableCss: ''
    downVoteableCss: ''
    upVoteCount: 0
    downVoteCount: 0
    voteableType: 'Comment'
    voteableId: @props.data.comment.id

  vote: (e) ->
    if @state.currentUser == null
      @props.helpers.pleaseLogin()
    else
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
          @refreshSelf(response)
      )


  render: () ->
    React.DOM.div
      className: 'pull-right vote-interface foo-small'
      React.DOM.span
        className: null 
        "{ "
        React.DOM.div
          className: "#{@state.upVoteableCss} inline voteable"
          onClick: @vote
          'data-vote-value': 1
          React.DOM.i
            className: "fa fa-thumbs-up light-blue inline upvote"
          React.DOM.span
            className: null
            ": #{@state.upVoteCount}"
      React.DOM.span
        className: null 
        " , "
      React.DOM.div
        className: "#{@state.downVoteableCss} inline voteable"
        'data-vote-value': -1
        onClick: @vote
        React.DOM.span
          React.DOM.i
            className: "fa fa-thumbs-down light-red downvote"
        React.DOM.span
            className: null
          ": #{@state.downVoteCount}"
      React.DOM.span
        className: null 
        " }"
