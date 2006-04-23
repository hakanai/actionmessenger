class SimpleMessenger < ActionMessenger::Base

  # Wakes up the given user.
  def wakeup(user)
    message.to = user
    message.body = 'Wake up!'
  end
end
