module Ruboty
  module ReviewerAssign
    module Actions
      class Tagging < Ruboty::Actions::Base
        def call
          message.reply(hige)
        rescue Ruboty::ReviewerAssign::Parsers::Base::ParseError => e
          message.reply(e.message)
        end

        private
        def hige
          # TODO: main logic
        end
      end
    end
  end
end
