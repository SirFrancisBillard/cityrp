
-- entirely client-handled quiz system
-- its mostly just memes so it doesnt need to touch the server

local correct = 0
local blip = Sound("hl1/fvox/blip.wav")

function DermaQuiz(title, qs, func, recurse)
	if recurse == nil then
		recurse = 1
		correct = 0
	elseif recurse > #qs then
		return func(correct, #qs)
	end

	local unpackme = {}
	for j = 1, #(qs[recurse].answers) do
		table.insert(unpackme, qs[recurse].answers[j])

		if j == qs[recurse].correct then
			table.insert(unpackme, function()
				correct = correct + 1
				surface.PlaySound(blip)
				DermaQuiz(title, qs, func, recurse + 1)
			end)
		else
			table.insert(unpackme, function()
				surface.PlaySound(blip)
				DermaQuiz(title, qs, func, recurse + 1)
			end)
		end
	end

	Derma_Query(qs[recurse].question, title, unpack(unpackme))
end
