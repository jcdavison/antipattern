@topicSelect = React.createClass

  componentDidMount: () ->
    console.log @props.data

  getDefaultProps: () ->
    topics: []
    helpers: window.ReactHelpers

  render: () ->
    React.DOM.div
      className: 'foo'
      'foo select'

