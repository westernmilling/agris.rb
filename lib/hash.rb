# frozen_string_literal: true

require 'nokogiri'

class Hash
  class << self
    def from_xml(xml_io)
      result = Nokogiri::XML(xml_io)

      { key_value(result.root) => xml_node_to_hash(result.root) }
    end

    protected

    def xml_node_to_hash(node)
      # If we are at the root of the document, start the hash
      return node.content.to_s unless node.element?

      result_hash = {}
      if node.attributes != {}
        attributes = {}
        node.attributes.each_key do |key|
          attributes[
            key_value(node.attributes[key])
          ] = node.attributes[key].value
        end
      end

      return attributes if node.children.empty?

      node.children.each do |child|
        result = xml_node_to_hash(child)

        if child.name == 'text'
          unless child.next_sibling || child.previous_sibling
            return result unless attributes
            result_hash[key_value(child)] = result
          end
        elsif result_hash[key_value(child)]

          if result_hash[key_value(child)].is_a?(Object::Array)
            result_hash[key_value(child)] << result
          else
            result_hash[key_value(child)] = [
              result_hash[key_value(child)]
            ] << result
          end
        else
          result_hash[key_value(child)] = result
        end
      end
      if attributes
        # Add code to remove non-data attributes e.g. xml schema, namespace
        # here, if there is a collision then node content supersets
        # attributes
        result_hash = attributes.merge(result_hash)
      end
      result_hash
    end

    def key_value(node)
      node.name
    end
  end
end
