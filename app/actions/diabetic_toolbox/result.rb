module DiabeticToolbox
  module Result
    class Base
      attr_reader :messages

      def initialize(messages)
        @messages = messages
      end
    end

    class Success < Base
      def initialize(messages)
        super(messages)
      end
    end

    class Failure < Base
      def initialize(messages)
        super(messages)
      end
    end
  end
end