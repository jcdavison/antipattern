@indexSummary = React.createClass

  getDefaultProps: () ->
    products: []
    helpers: window.ReactHelpers

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
                className: 'col-sm-10'
                React.DOM.span
                  className: 'medium-small'
                  React.DOM.a
                    href: "/code-reviews/#{@props.data.codeReview.id}"
                    @props.data.codeReview.title
                React.DOM.div
                  className: null
                  React.DOM.span
                    className: null
                    "topics: " 
                  React.DOM.span
                    className: 'blue'
                    @props.data.codeReview.topics
        React.DOM.div
          className: 'row'
          React.DOM.div
            className: 'col-sm-12 text-left left-bump'
