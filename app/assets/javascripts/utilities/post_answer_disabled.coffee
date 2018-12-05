document.addEventListener 'turbolinks:load', ->
  button = document.querySelector('input[value="Post Your Answer"]')
  signUp = document.querySelector('a[href="/users/sign_up"]')
  text = document.querySelector('#needSignIn')

  if button && signUp
    button.addEventListener 'click', displayNotification

displayNotification = (event, text) ->
  text = document.querySelector('#needSignIn')

  event.preventDefault()
  text.style.display = 'block'