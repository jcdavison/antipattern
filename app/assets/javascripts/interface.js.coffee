class Interface
  constructor: () ->
    @configValidation()
    @showFaq()

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

new Interface
