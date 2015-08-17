Rails.application.routes.draw do
  mount DiabeticToolbox::Engine => '/', as: :toolbox
end
