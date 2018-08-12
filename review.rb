module Ruboty
	module Handlers
		class Review < Base
			on(/review/i, name: "review", description: "assign review")

			def review(message)
				message.reply("Hello!!")
			end
		end
	end
end

