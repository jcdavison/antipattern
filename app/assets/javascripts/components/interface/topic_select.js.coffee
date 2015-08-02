@topicSelect = React.createClass

  getInitialState: () ->
    topicsElement: 'topics-select'

  componentDidMount: () ->
    @initSelect()
    @setTopics()

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  initSelect: () ->
    $("##{@state.topicsElement}").select2()

  setTopics: () ->
    $.get '/api/topics.json', {}, (data) =>
      $("##{@state.topicsElement}").select2(
        templateResult: @selectTemplate
        data: data.topics
      )

  selectTemplate: (data) ->
    $("<span>#{data.text}</span>")

  render: () ->
    React.DOM.select
      multiple: 'multiple'
      className: 'standard-form'
      name: 'codeReview[topics]'
      style: {width: "100%"}
      id: @state.topicsElement 

