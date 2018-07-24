# frozen_string_literal: true
require 'globalid'

module Agris
  module XmlModel
    include GlobalID::Identification

    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
      attr_reader :hash

      def id
        @id = SecureRandom.uuid
      end

      def attributes
        (instance_variables - [:@hash]).each_with_object({}) do |ivar, new_hash|
          new_hash[ivar.to_s.delete('@')] = instance_variable_get(ivar)
          new_hash
        end
      end

      def initialize(hash = {})
        @hash = hash
        @hash.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def to_xml_hash
        ignore_attributes = (xml_ignore_attributes + [:hash]).map(&:to_s)
        match_attributes = attributes.keys - ignore_attributes
        attributes
          .select { |key, _value| match_attributes.include?(key) }
          .each_with_object({}) do |(name, value), new_hash|
          new_hash["@#{name.delete('_')}".to_sym] = value
          new_hash
        end
      end

      def xml_ignore_attributes
        []
      end
    end

    module ClassMethods
      def xml_class
        Object.const_get(name)
      end

      def find(id) end

      def from_xml_hash(hash)
        klass = Object.const_get(name)

        attribute_map =
          klass::ATTRIBUTE_NAMES
          .each_with_object({}) do |name, new_hash|
            new_hash[name.delete('_').to_s] = name
          end

        translated_hash = hash.each_with_object({}) do |(key, value), new_hash|
          attribute_name = attribute_map[key]

          new_hash[attribute_name] = value if attribute_name
          new_hash
        end

        klass.new(translated_hash)
      end

      def pluralized_name
        "#{name.split('::').last.downcase}s"
      end
    end
  end
end
