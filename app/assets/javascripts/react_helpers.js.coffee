window.ReactHelpers =

  hasProp: (attribute, props) ->
    if props[attribute]
      return props[attribute]
    else if props.data
      return props.data[attribute]

  contentOrComponent: (contentKey, data) ->
    if data[contentKey] && data[contentKey].createElement
      React.createElement eval(data[contentKey].createElement), data: data[contentKey].data 
    else if data[contentKey] 
      data[contentKey].content

  extractCss: (contentKey, cssKey, data) ->
    if data[contentKey]
      data[contentKey][cssKey]
    else
      data[cssKey]

  displayDate: (timeStamp) ->
    date = new Date(timeStamp)
    "#{date.getFullYear()}/#{date.getMonth()}/#{date.getDay()}"

  hide: (selector) ->
    $(selector).addClass('hide')

  show: (selector) ->
    $(selector).removeClass('hide')

  commitUrl: (opts) ->
    "https://github.com/#{opts.username}/#{opts.repo}/commit/#{opts.commitSha}"

  date: (timeStamp) ->
    moment(timeStamp).format("MMM D")

  highlightCode: (str) ->
    marked("`#{str}`")

  validateForm: (selector) ->
    $("#{selector}").h5Validate()

  isValidForm: (selector) ->
    $("#{selector}").h5Validate('allValid')

  pleaseLogin: () ->
    $("#please-login").modal()

  updateSelf: (e) ->
    updateObj = {}
    newValue = $(e.currentTarget).val()
    attribute = e.currentTarget.dataset.stateAttribute
    updateObj[attribute] = newValue
    @setState updateObj

  selectFrom: (collection, value, attribute) ->
    _.select(collection, (element) =>
      value == eval("element.#{attribute}")
    )[0]
