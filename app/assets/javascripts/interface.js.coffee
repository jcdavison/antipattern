class Interface

  validateForms: () ->
    $.h5Validate.addPatterns({
      email: /\S+@\S+\.\S+/ 
      alphabet: /[a-zA-Z]{1,}.+/
      date: /^(\d{2}-{1}){2}\d{4}/
      passcode:  /^\d{4}$/
      inviteCode: /[A-Za-z0-9]{10}/
      userpassword: /[a-zA-Z0-9]{1,}.+/
    });
    $('form').h5Validate();
