# frozen_string_literal: true

require 'rubygems'
require 'bundler'

# Set the environment
environment = ENV['RACK_ENV'] || 'development'
Bundler.require(:default, environment)

# Load environment variables
require 'dotenv'
Dotenv.load(".env.#{environment}", '.env')

# Load the application
require './config/application'

# Use Rack::Deflater for compression
use Rack::Deflater

# Use Rack::Attack for rate limiting and blocking
use Rack::Attack

# Run the application
run Application