# frozen_string_literal: true

# Base class for all ActiveRecord models in the application.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
