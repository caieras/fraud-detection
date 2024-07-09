# frozen_string_literal: true

threads_min = ENV.fetch('PUMA_THREADS_MIN') { 0 }.to_i
threads_max = ENV.fetch('PUMA_THREADS_MAX') { 12 }.to_i
threads threads_min, threads_max

# workers ENV.fetch('WEB_CONCURRENCY') { 2 }
environment ENV.fetch('RACK_ENV') { 'development' }
bind "tcp://localhost:#{ENV.fetch("PORT") { 9292 }}"

preload_app!
