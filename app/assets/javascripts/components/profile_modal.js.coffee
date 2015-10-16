@profileModal = React.createClass

  getInitialState: () ->
    formId: 'user-profile'
    subscribeTo: true
    email: @props.data.currentUser.email
    notificationsSelectId: 'user-notifications-select'
    channels: []

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  componentDidMount: () ->
    $("##{@state.notificationsSelectId}").select2()
    @getUserSubscriptions()
    # @initChannelSelect()
    $("##{@state.formId}").h5Validate()
    @showIfQueryParam()
    @getUserSubscription()
    @handleShowClick()

  getUserSubscriptions: () ->
    $.get '/api/subscriptions', {}
      .success( (response) => 
        subscriptionValues = _.map(response.subscriptions, (obj) -> "#{obj.id}")
        @initChannelSelect(subscriptionValues)
      )


  initChannelSelect: (currentUserSubscriptions) ->
    $.get '/api/channels', {}
      .success( (response) => 
        $("##{@state.notificationsSelectId}").select2(data: response.channels)
        $("##{@state.notificationsSelectId}").val(currentUserSubscriptions).trigger('change')
      )

  showIfQueryParam: () ->
    if window.location.search.match(/show_profile=true/)
      $('.user-profile-modal').modal(
        backdrop: 'static'
      )

  getUserSubscription: () ->
    # $.get '/api/subscriptions.json', {} , (data) =>
    #   @setState subscribeTo: data.subscribedTo

  handleShowClick: () ->
    $(".show-user-profile-modal").click () ->
      $('.user-profile-modal').modal()

  updateNotifications: () ->
    if $("##{@state.formId}").h5Validate('allvalid')
      data = 
        channelIds: $("##{@state.notificationsSelectId}").val()
      $.ajax(
        type: 'PATCH'
        url: '/api/subscriptions'
        data: data 
        success: (data) =>
          $('.user-profile-modal').modal('hide')
        ) 

  updateSubscribeTo: (e) ->
    @setState subscribeTo: ! @state.subscribeTo

  updateEmail: (e) ->
    @setState email: e.target.value

  userProfileForm: () ->
    React.DOM.div
      className: 'modal-body user-profile-form'
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-md-12'
          React.DOM.form
            id: @state.formId 

            React.DOM.div
              className: 'row top-margined'
              React.DOM.div
                className: 'col-sm-10'
                React.DOM.span
                  className: 'medium-small'
                  'Select Channels' 
            React.DOM.div
              className: 'row top-margined'
              React.DOM.div
                className: 'col-md-12 medium-small'
                React.DOM.select
                  id: @state.notificationsSelectId
                  multiple: 'true'
                  required: 'required'
                  className: 'full-bleed'

            # React.DOM.div
            #   className: 'row top-margined'
            #   React.DOM.div
            #     className: 'col-sm-2 fixed-line-45'
            #     React.DOM.span
            #       className: 'medium-small'
            #       'Email:' 
            #   React.DOM.div
            #     className: 'col-sm-10 fixed-line-45'
            #     React.DOM.input
            #       type: 'text'
            #       id: 'user-profile-email'
            #       required: 'required'
            #       className: ' full-bleed standard-form h5-email'
            #       onChange: @updateEmail
            #       value: @state.email
  render: () ->
    React.DOM.div
      className: 'modal fade user-profile-modal'
      id: 'user-profile-modal'
      React.DOM.div
        className: 'modal-dialog'
        React.DOM.div
          className: 'modal-content no-corners'
          React.DOM.div
            className: 'modal-header blue medium-small'
            "New Code Review Email Notifications"
            React.DOM.button
              className: 'close'
              'data-dismiss': 'modal'
              React.DOM.span
                'aria-hidden': true
                'X'
          @userProfileForm()
          React.DOM.div
            className: 'modal-footer'
            React.DOM.div
              className: 'centered'
              React.DOM.button
                className: 'btn btn-default summary' 
                onClick: @updateNotifications
                'SAVE PREFERENCES'
