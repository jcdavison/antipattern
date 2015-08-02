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
            React.DOM.span
              className: 'medium'
              React.DOM.a
                href: "/code-reviews/#{@props.data.codeReview.id}"
                @props.data.codeReview.url
        React.DOM.div
          className: 'row'
          React.DOM.div
            className: 'col-sm-12 text-left left-bump'
            React.DOM.div
              className: 'inline'
              'by: ' 
              React.DOM.a
                href: @props.data.codeReview.user.githubProfile
                target: 'new'
                React.DOM.img
                  src: @props.data.codeReview.user.profilePic
                  className: 'profile'
              "on: #{@props.helpers.displayDate @props.data.codeReview.createdAt } "
            React.DOM.div
              className: 'inline'
              React.DOM.span
                className: null
                "topics: " 
              React.DOM.span
                className: 'blue'
                @props.data.codeReview.topics
