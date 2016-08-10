Rails.application.config.middleware.use OmniAuth::Builder do
  provider :stripe_connect,
           ENV['STRIPE_APP_ID'],
           ENV['STRIPE_SECRET_KEY'],
           scope: 'read_only',
           client_options: { ssl: { ca_file: '/usr/lib/ssl/certs/ca-certificates.crt' } },
           callback_path: '/users/auth/stripe_connect/callback'
end

OmniAuth.config.on_failure = Proc.new do |env|
  [302, {'Location' => "/auth/failure", 'Content-Type' => 'text/html'}, []]
end
