module Ruboty
  module ReviewerAssign
    module Actions
      class Add < Ruboty::Actions::Base
        def call
          message.reply(hige)
        rescue => e
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

