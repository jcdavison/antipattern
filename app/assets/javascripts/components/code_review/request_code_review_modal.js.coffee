@requestCodeReviewModal = React.createClass

  getInitialState: () ->
    formId: 'request-code-review'
    codeReviewUrl: ''

  getDefaultProps: () ->
    products: []
    helpers: window.ReactHelpers

  componentDidMount: () ->
    $("##{@state.formId}").h5Validate()

  submitCodeReview: () ->
    if $("##{@state.formId}").h5Validate('allValid')
      data = 
        codeReview: 
          url: $("#code-review-url").val()
          context: $("#code-review-context").val()
          topics: $("#topics-select").val()
      $.ajax(
        type: 'POST'
        url: '/api/reviews.json'
        data: data 
        success: (data) =>
          @props.helpers.hide('.request-code-review-form')
          @props.helpers.show('.request-code-review-success')
          console.log data.codeReview
          @setState codeReviewUrl: data.codeReview.antipatternUrl
      ) 
    else
      console.log 'invalid'

  codeReviewRequestForm: () ->
    React.DOM.div
      className: 'modal-body request-code-review-form'
      React.DOM.div
        className: 'row'
        React.DOM.div
          className: 'col-md-12'
          React.DOM.form
            id: @state.formId 
          # begin component row
            React.DOM.div
              className: 'row'
              React.DOM.div
                className: 'col-md-12 form-steps'
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-1'
                    React.DOM.div
                      className: 'medium blue centered'
                      '1.'
                  React.DOM.div
                    className: 'col-md-11'
                    React.DOM.div
                      className: 'row no-horizontal-margin'
                      React.DOM.div
                        className: 'col-sm-3'
                        React.DOM.span
                          className: 'medium'
                          'Url:' 
                      React.DOM.div
                        className: 'col-sm-9'
                        React.DOM.input
                          type: 'text'
                          id: 'code-review-url'
                          required: 'required'
                          className: 'fixed-line-45 full-bleed standard-form h5-url'
                          placeholder: 'gist (ok), pull request (better), commit (best)'
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-1'
                    React.DOM.div
                      className: 'medium blue centered'
                      '2.'
                  React.DOM.div
                    className: 'col-md-11'
                    React.DOM.div
                      className: 'row no-horizontal-margin'
                      React.DOM.div
                        className: 'col-sm-3'
                        React.DOM.span
                          className: 'medium'
                          'Context:' 
                      React.DOM.div
                        className: 'col-sm-9'
                        React.DOM.textarea
                          rows: '8'
                          cols: '56'
                          required: 'required'
                          className: 'standard-form'
                          id: 'code-review-context'
                          placeholder: 'Tell the community what you are looking for in your code review. (markdown friendly)'
                React.DOM.div
                  className: 'row top-margined'
                  React.DOM.div
                    className: 'col-md-1'
                    React.DOM.div
                      className: 'medium blue centered'
                      '3.'
                  React.DOM.div
                    className: 'col-md-11'
                    React.DOM.div
                      className: 'row no-horizontal-margin'
                      React.DOM.div
                        className: 'col-sm-3'
                        React.DOM.span
                          className: 'medium'
                          'Topics:' 
                      React.DOM.div
                        className: 'col-sm-9'
                        React.DOM.div
                          className: 'topic-select'
                          React.createElement topicSelect

  render: () ->
    React.DOM.div
      className: 'modal fade request-code-review'
      id: 'user-auth'
      React.DOM.div
        className: 'modal-dialog'
        React.DOM.div
          className: 'modal-content no-corners'
          React.DOM.div
            className: 'modal-header blue medium'
            'Post a link to your code.'
            React.DOM.button
              className: 'close'
              'data-dismiss': 'modal'
              React.DOM.span
                className: 'null'
                'aria-hidden': true
                'X'
          @codeReviewRequestForm()
          React.DOM.div
            className: 'modal-footer request-code-review-form'
            React.DOM.div
              className: 'centered'
              React.DOM.button
                className: 'btn btn-default summary' 
                onClick: @submitCodeReview
                'Submit'
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
