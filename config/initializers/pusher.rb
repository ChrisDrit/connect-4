require 'pusher'
Pusher.app_id = '683461'
Pusher.key = '8fc2bf8750edcb87bd34'
Pusher.secret = Rails.application.credentials.pusher[:secret]
Pusher.cluster = 'us2'
Pusher.logger = Rails.logger
Pusher.encrypted = true
