# frozen_string_literal: true
module Agris
  module Api
    module Support
      # NB: I feel like this module could be broken up into more appropriately
      #     named files, but I'm not sure what those would be at present.
      def build_response(output_hash, type)
        DocumentQueryResponse.new(output_hash, type)
      end

      def extract_documents(message, type)
        response = @request.process_message(
          Gyoku.xml(xml: context_hash),
          message.message_number,
          message.to_xml
        )

        build_response(response.output_hash, type)
      end

      # NB: We could refactor these into builder classes so that we can
      #     use Gyoku to convert to XML. I imagine some kind of composite
      #     builder that wraps child builders with the xml container tags.
      #     Classes like SpecificOrderExtract and NewOrder would be possible
      #     candidates to become builders, include the builder module or have
      #     companion builder classes. AgrisInput, AgrisOutput?
      def context_hash
        {
          login: {
            :@dataset => @context.dataset,
            :@databasetype => 'SQL',
            :@database => @context.database,
            :@userid => @context.userid,
            :@password => @context.password,
            :@datapath => @context.datapath,
            :@log => 'Y',
            :@loglevel => '9'
          }
        }
      end

      def post_input_hash
        {
          input: {
            :@endofprocessoption => 1,
            :@altnameidonfile => 'N',
            :@usecurdate4outofrange => 'N',
            :@reportoption => 1,
            :@usefile => false
          }
        }
      end

      def create_post_payload_xml(details)
        details_xml = details.map do |detail|
          Gyoku.xml(detail: detail)
        end.join

        '<xml>' \
        "#{Gyoku.xml(post_input_hash)}<details>#{details_xml}</details>" \
        '</xml>'
      end

      def import(model)
        import_message = Messages::Import.new(model)

        response = @request.process_message(
          Gyoku.xml(xml: context_hash),
          import_message.message_number,
          import_message.to_xml
        )

        PostResult.new(response)
      end
    end
  end
end
