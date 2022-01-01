if Rails.env === 'production'
    Rails.application.config.session_store :cookie_store, key: '_math-sns-api', domain: 'mualphatheta.herokuapp.com'
else
    Rails.application.config.session_store :cookie_store, key: '_math-sns-api'
end