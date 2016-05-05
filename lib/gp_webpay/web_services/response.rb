module GpWebpay
  module WebServices
    class Response
      attr_accessor :plain

      def initialize(data)
        @plain = data

        return unless data.respond_to?(:keys)
        data.keys.each do |key|
          define_singleton_method key.underscore do
            data[key]
          end
        end
      end
    end
  end
end
