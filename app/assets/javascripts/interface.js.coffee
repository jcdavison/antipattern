class Interface
  constructor: () ->
    @configValidation()
    @showFaq()
    @togglePanel()

  configValidation: () ->
    $.h5Validate.addPatterns({
      email: /\S+@\S+\.\S+/ 
      alphabet: /[a-zA-Z]{1,}.+/
      date: /^(\d{2}-{1}){2}\d{4}/
      userpassword: /[a-zA-Z0-9]{1,}.+/
      url: /http\:\/\/.+/
    });

  showFaq: () ->
    $("#show-faq").click( () ->
      $("#faq-modal").modal()
    )

  togglePanel: () ->
    $('.toggle-panel').click(
      (e) ->
        $($(e.target).data('toggle-target')).toggleClass('hidden')
    )

new Interface
