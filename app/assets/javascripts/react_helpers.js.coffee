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
