class MovementFayeController < FayeRails::Controller
  observe Movement, :after_create do |movement|
    if movement.user.nil?
      MovementFayeController.publish('/movements',  {action: 'new-game'})
    end
  end
end