DiabeticToolbox::Engine.routes.draw do
  devise_for :patients, class_name: "DiabeticToolbox::Patient"
end
