# frozen_string_literal: true

# module which allows to count class instances
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include(InstanceMethods)
  end

  module ClassMethods
    attr_accessor :instances
  end

  module InstanceMethods
    protected

    def register_instances
      self.class.instances += 1
    end
  end
end