@indexSummary = React.createClass

  getDefaultProps: () ->
    products: []
    helpers: window.ReactHelpers

  getInitialState: ->
    showDelete: @showDelete()

  showDelete: () ->
    if @props.data.currentUser
      @props.data.currentUser.id == @props.data.codeReview.userId

  trimContext: (str) ->
    if str
      return str.slice(0,45) + "..."
    
  componentDidMount: () ->

  sendDelete: () ->
    $.ajax(
      type: 'DELETE'
      url: "/api/reviews/#{@props.data.codeReview.id}"
      success: () =>
        PubSub.publish 'refresh-code-review-index'
        @setState showDelete: @showDelete()
    ) 

  render: () ->
    React.DOM.div
      className: 'code-review'
      React.DOM.div
        className: 'request-summary'
        React.DOM.div
          className: 'row'
          React.DOM.div
            className: 'col-sm-12'
            React.DOM.div
              className: 'row'
              React.DOM.div
                className: 'col-sm-1'
                React.DOM.a
                  href: @props.data.codeReview.user.githubProfile
                  target: 'new'
                  React.DOM.img
                    src: @props.data.codeReview.user.profilePic
                    className: 'profile'
              React.DOM.div
                className: 'col-sm-7'
                React.DOM.div
                  React.DOM.span
                    className: 'medium-small'
                    React.DOM.a
                      className: 'code-review-show'
                      href: "/code-reviews/#{@props.data.codeReview.id}"
                      @props.data.codeReview.title
                  React.DOM.div
                    className: null
                    React.DOM.span
                      className: 'blue'
                      "repo: " 
                    React.DOM.span
                      className: 'grey'
                      @props.data.codeReview.repo
                  if @props.data.codeReview.context
                    React.DOM.div
                      className: null
                      React.DOM.span
                        className: 'blue'
                        "context: " 
                      React.DOM.span
                        className: 'grey code-review-context'
                        @trimContext @props.data.codeReview.context
                  React.DOM.div
                    className: null
                    React.DOM.span
                      className: 'blue'
                      "topics: " 
                    React.DOM.span
                      className: 'grey'
                      @props.data.codeReview.topics
                  if @state.showDelete
                    React.DOM.span
                      className: 'pointer light-red inline small-top-margined' 
                      onClick: @sendDelete
                      id: "delete-#{@props.data.codeReview.context}"
                      'delete'
              React.DOM.div
                className: 'col-sm-4 fixed-line-45 text-right'
                React.DOM.a
                  className: 'continue review inline small-top-margined' 
                  href: "/code-reviews/#{@props.data.codeReview.id}"
                  target: 'new'
                  'Review This Code!'
        React.DOM.div
          className: 'row'
          React.DOM.div
            className: 'col-sm-12 text-left left-bump'
