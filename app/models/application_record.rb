class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # http://www.freakular.co.uk/rails-except-scope/
  scope :exclude, ->(*values) { where("#{table_name}.id NOT IN (?)", values.compact.flatten.map { |e| e.is_a?(Integer) ? e : e.id } << 0) }
end
