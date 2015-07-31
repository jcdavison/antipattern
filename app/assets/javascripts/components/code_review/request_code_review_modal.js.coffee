@requestCodeReviewModal = React.createClass

  getDefaultProps: () ->
    products: []
    helpers: window.ReactHelpers

  componentDidMount: () ->

  render: () ->
    React.DOM.div
      className: 'modal fade request-code-review'
      id: 'user-auth'
      React.DOM.div
        className: 'modal-dialog modal-lg'
        React.DOM.div
          className: 'modal-content no-corners'
          React.DOM.div
            className: 'modal-header'
            React.DOM.button
              className: 'close'
              'data-dismiss': 'modal'
              React.DOM.span
                className: 'null'
                'aria-hidden': true
                'X'
          React.DOM.div
            className: 'modal-body'
            React.DOM.div
              className: 'row'
              React.DOM.div
                className: 'col-md-12'
                React.DOM.div
                  className: 'row'
                  React.DOM.div
                    className: 'col-md-6'
                    React.DOM.form
                      noValidate: true
                      name: 'request-code-review'
                      id: 'request-code-review'
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
                                  'Link:' 
                              React.DOM.div
                                className: 'col-sm-9'
                                React.DOM.input
                                  name: 'codeReview[url]'
                                  type: 'text'
                                  className: 'fixed-line-45 full-bleed'
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
                                  name: 'codeReview[context]'
                                  rows: '8'
                                  cols: '59'
                                  className: null
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
                                  React.createElement topicSelect, data: { tags: @props.data.tags }
