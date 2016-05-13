@commentFeedsIndex = React.createClass

  getInitialState: () ->
    commentFeeds: []

  componentDidMount: () ->
    @getCommentFeeds()
    PubSub.subscribe('refreshCommentFeeds', @getCommentFeeds)

  getCommentFeeds: () ->
    $.get '/api/comment-feeds'
    .success( (response) =>
      @setState commentFeeds: response.commentFeeds
    )
    .error( (response) =>
      console.log 'error', response
    )

  destroyFeed: (urlSlug, e) ->
    thisElement = e.currentTarget
    $.ajax (
      type: 'DELETE'
      url: '/api/comment-feeds'
      data: 
        url_slug: urlSlug
      success: () =>
        $(thisElement).parents('.commentFeedElement').remove()
      error: (error) ->
        console.log 'error', error
    )

  render: () ->
    React.DOM.div
      className: 'row'
      React.DOM.div
        className: 'commentFeeds top-margined col-sm-11 col-sm-offset-1 no-horizontal-padding'
        React.DOM.div
          className: 'no-horizontal-margin'
          'saved comment feeds'
        for feed, index in @state.commentFeeds
          React.DOM.div
            className: 'no-horizontal-margin commentFeedElement'
            key: "comment-feed-#{index}"
            React.DOM.a
              key: "comment-feed-link-#{index}"
              href: feed.url
              target: 'new'
              "{ repo: #{feed.repository}, permalink: #{feed.url} }"
            React.DOM.span
              className: 'light-red pointer medium-small'
              key: "comment-feed-destroy-#{index}"
              onClick: @destroyFeed.bind(this, feed.urlSlug)
              " X"
