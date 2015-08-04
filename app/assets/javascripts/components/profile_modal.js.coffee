@profileModal = React.createClass

  getInitialState: () ->
    formId: 'user-profile'
    subscribeTo: true
    email: @props.data.currentUser.email

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  componentDidMount: () ->
    $("##{@state.formId}").h5Validate()
    @showIfQueryParam()
    @getUserSubscription()
    @handleShowClick()

  showIfQueryParam: () ->
    if window.location.search.match(/show_profile=true/)
      $('.user-profile-modal').modal(
        backdrop: 'static'
      )

  getUserSubscription: () ->
    $.get '/api/subscriptions.json', {} , (data) =>
      @setState subscribeTo: data.subscribedTo

  handleShowClick: () ->
    $(".show-user-profile-modal").click () ->
      $('.user-profile-modal').modal(
        backdrop: 'static'
      )

  updateProfile: () ->
    if $("##{@state.formId}").h5Validate('allvalid')
      data = 
        user: 
          email: @state.email
          subscribeTo: @state.subscribeTo
      $.ajax(
        type: 'POST'
        url: '/api/update_profile.json'
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
                className: 'col-sm-9 fixed-line-45'
                React.DOM.span
                  className: 'medium-small'
                  'Get Notified About New Code Reviews:' 
              React.DOM.div
                className: 'col-sm-3 fixed-line-45'
                React.DOM.input
                  type: 'checkbox'
                  className: 'double-wide'
                  id: 'user-profile-notifications'
                  checked: @state.subscribeTo 
                  onChange: @updateSubscribeTo

            React.DOM.div
              className: 'row top-margined'
              React.DOM.div
                className: 'col-sm-2 fixed-line-45'
                React.DOM.span
                  className: 'medium-small'
                  'Email:' 
              React.DOM.div
                className: 'col-sm-10 fixed-line-45'
                React.DOM.input
                  type: 'text'
                  id: 'user-profile-email'
                  required: 'required'
                  className: ' full-bleed standard-form h5-email'
                  onChange: @updateEmail
                  value: @state.email
  render: () ->
    React.DOM.div
      className: 'modal fade user-profile-modal'
      id: 'user-profile-modal'
      React.DOM.div
        className: 'modal-dialog'
        React.DOM.div
          className: 'modal-content no-corners'
          React.DOM.div
            className: 'modal-header blue medium'
            "Confirm Thy Self"
            React.DOM.button
              className: 'close'
              'data-dismiss': 'modal'
              React.DOM.span
                'aria-hidden': true
                'X'
          @userProfileForm()
          React.DOM.div
            className: 'modal-footer request-code-review-form'
            React.DOM.div
              className: 'centered'
              React.DOM.button
                className: 'btn btn-default summary' 
                onClick: @updateProfile
                'CONFIRM & UPDATE'
          React.DOM.div
            className: 'modal-footer request-code-review-success hide'
            React.DOM.div
              className: 'centered medium blue'
              'Congrats!!!! It is a Code Review'
            React.DOM.div
              className: 'centered medium blue'
              React.DOM.a
                href: @state.codeReviewUrl
                @state.codeReviewUrl
