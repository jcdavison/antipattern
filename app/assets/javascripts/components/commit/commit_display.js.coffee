@commitDisplay = React.createClass

  getInitialState: () ->
    files: @props.data.commit.files
    info: @props.data.commit.info
    owner: @props.data.codeReviewOwner
    id: @props.data.codeReviewId

  getDefaultProps: () ->
    helpers: window.ReactHelpers

  componentDidMount: () ->
    PubSub.subscribe 'updateCommit', @updateCommit

  updateCommit: () ->
    $.get(
      '/api/review', 
      id: @state.id
    )
    .success( 
      (response) =>
        @setState files: response.commit.files
    )

  render: () ->
    React.DOM.div
      className: null
      React.DOM.div
        className: 'commit-container'
        React.DOM.div
          className: 'row'
          React.DOM.div
            className: 'col-sm-12 no-horizontal-margin'
            React.DOM.a
              className: null
              href: @state.owner.githubProfile
              target: '_blank'
              React.DOM.img
                className: 'profile'
                src: @state.owner.profilePic
              React.DOM.span
                className: 'medium blue bottom'
                "#{@state.owner.githubUsername}/"
            React.DOM.a
              className: 'medium blue bottom'
              href: @props.helpers.commitUrl(username: @state.owner.githubUsername, repo: @state.info.repo, commitSha: @state.info.commitSha)
              target: '_blank'
              @state.info.repo
        React.DOM.div
          className: 'row no-horizontal-margin'
          React.DOM.div
            className: 'col-sm-12 pale_blue_background bottom-radius'
            React.DOM.div
              className: 'black medium-small '
              @state.info.message
            React.DOM.div
              className: null
              "authored on #{@props.helpers.date(@state.info.committer.date)}, sha: #{@state.info.commitSha}"
      for file, index in @state.files
        React.createElement fileDisplay, key: "patch-#{index}", data: file: file, info: @state.info, owner: @state.owner
