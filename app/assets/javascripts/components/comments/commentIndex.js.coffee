@commentIndex = React.createClass

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  getInitialState: () ->
    comments: null
    hasComments: false

  componentDidMount: () ->
    console.log @props.data

  # getCommentsIndex: () ->
    # while @state.comments == null
    #   $.get '/api/comments-index'
    #     .success( (response) =>
    #       console.log(response)
    #       @setState: comments: true
    #       @setState: hasComments: true
    #     )
    #       .failure( () => console.log 'failure' )

  render: () ->
    React.DOM.div
      className: 'somestuff'
