essentialDarkRPF4Menu = essentialDarkRPF4Menu or {}

local white = Color(255, 255, 255)
local black = Color(0, 0, 0)

local defaultBlur = Color(10, 10, 10, 160)
local defaultBlurOutline = Color(20, 20, 20, 210)

local function buttonClickSound()
	surface.PlaySound('ui/buttonclick.wav')
end

-- Draw normal outlined (non-blurred) rectangle in paint hook
local function drawRectOutlined(xpos, ypos, width, height, color)
	surface.SetDrawColor(color)
	surface.DrawRect(xpos + 1, ypos + 1, width - 2, height - 2)

	surface.SetDrawColor(defaultBlurOutline)
	surface.DrawOutlinedRect(xpos, ypos, width, height)
end

local function openПредметы()
	if IsValid(essentialDarkRPF4Menu.ПредметыPanel) then return end

	local midPanel = essentialDarkRPF4Menu.returnMidPanel()

	-- Panel to parent all tab content to
	essentialDarkRPF4Menu.ПредметыPanel = midPanel:Add('DPanel')
	essentialDarkRPF4Menu.ПредметыPanel:SetSize(midPanel:GetWide(), midPanel:GetTall())
	essentialDarkRPF4Menu.ПредметыPanel:Dock(FILL)
	essentialDarkRPF4Menu.ПредметыPanel:DockMargin(0, 0, 0, 0)

	function essentialDarkRPF4Menu.ПредметыPanel:Paint() return end

	-- Right panel
	local rightPanel = essentialDarkRPF4Menu.ПредметыPanel:Add('DPanel')
	rightPanel:SetSize(270, essentialDarkRPF4Menu.ПредметыPanel:GetTall())
	rightPanel:Dock(RIGHT)
	rightPanel:DockMargin(0, 0, 0, 0)

	function rightPanel:Paint(w, h)
		surface.SetDrawColor(defaultBlurOutline)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetDrawColor(essentialDarkRPF4Menu.BGColor1)
		surface.DrawRect(1, 1, w - 2, h - 2)
	end

	-- Right panel entity name
	local nameLabel = rightPanel:Add('DLabel')
	nameLabel:SetTall(30)
	nameLabel:Dock(TOP)
	nameLabel:DockMargin(5, 4, 5, 0)
	nameLabel:SetFont('edf_Roboto20')
	nameLabel:SetTextColor(white)
	nameLabel:SetContentAlignment(5)
	nameLabel:SetText('')

	local function addEntityName()
		nameLabel:SetText(essentialDarkRPF4Menu.selectedEntity.name)
	end

	-- Right panel model panel
	local modelPanel = rightPanel:Add('DModelPanel')
	modelPanel:SetSize(0, 150)
	modelPanel:Dock(TOP)
	modelPanel:DockMargin(5, 4, 5, 4)
	modelPanel:SetSize(200, 200)
	modelPanel:SetFOV(27)
	modelPanel:SetCamPos(Vector(100, 90, 65))
	modelPanel:SetLookAt(Vector(9, 9, 13))

	local function addEntityModel()
		modelPanel:SetModel(essentialDarkRPF4Menu.selectedEntity.model)
	end

	-- Right panel price panel
	local descriptionPricePanel = rightPanel:Add('DPanel')
	descriptionPricePanel:SetWide(rightPanel:GetWide())
	descriptionPricePanel:Dock(TOP)
	descriptionPricePanel:DockMargin(5, 20, 5, 10)

	function descriptionPricePanel:Paint() return end

	descriptionPrice = descriptionPricePanel:Add('DLabel')
	descriptionPrice:Dock(TOP)
	descriptionPrice:DockMargin(0, 0, 0, 0)
	descriptionPrice:SetFont('edf_Roboto20')
	descriptionPrice:SetTextColor(white)
	descriptionPrice:SetText('')
	descriptionPrice:SetContentAlignment(5)

	local function addEntityPrice()
		if essentialDarkRPF4Menu.selectedEntity.price < 1 then
			descriptionPrice:SetText('Free')
		else
			descriptionPrice:SetText('Cost: ' .. DarkRP.formatMoney(essentialDarkRPF4Menu.selectedEntity.price))
		end
	end

	-- Purchase entity button
	local purchaseEntityButton = rightPanel:Add('DButton')
	purchaseEntityButton:SetTall(45)
	purchaseEntityButton:Dock(BOTTOM)
	purchaseEntityButton:DockMargin(5, 4, 5, 5)
	purchaseEntityButton:SetFont('edf_Roboto20')
	purchaseEntityButton:SetText('Purchase')
	purchaseEntityButton:SetTextColor(white)

	function purchaseEntityButton:Paint(w, h)
		drawRectOutlined(0, 0, w, h, defaultBlur)

		if purchaseEntityButton:IsHovered() then
			purchaseEntityButton:SetTextColor(Color(255, 128, 0))
		else
			purchaseEntityButton:SetTextColor(white)
		end
	end

	-- Forget selected entity on creation
	essentialDarkRPF4Menu.selectedEntity = nil

	function purchaseEntityButton.DoClick()
		RunConsoleCommand('darkrp', essentialDarkRPF4Menu.selectedEntity.cmd)
	end

	-- Entities list panel
	local entitiesListPanel = essentialDarkRPF4Menu.ПредметыPanel:Add('DScrollPanel')
	entitiesListPanel:SetSize(essentialDarkRPF4Menu.ПредметыPanel:GetWide(), essentialDarkRPF4Menu.ПредметыPanel:GetTall())
	entitiesListPanel:Dock(TOP)
	entitiesListPanel:DockMargin(0, 0, 5, 0)

	local scrollBar = entitiesListPanel:GetVBar()
	scrollBar:DockMargin(0, 0, 0, 0)

	function scrollBar:Paint() return end

	function scrollBar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, defaultBlur)
	end

	function scrollBar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, defaultBlur)
	end

	function scrollBar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, defaultBlur)
	end

	local validItems = {}

	for _, entity in ipairs(DarkRPEntities) do
		essentialDarkRPF4Menu.displayItem = true

		-- Hide job and group restricted entities
		-- if essentialDarkRPF4Menu.hideRestrictedEntities then
			if istable(entity.allowed) and not table.HasValue(entity.allowed, LocalPlayer():Team()) then
				essentialDarkRPF4Menu.displayItem = false
			end

			if entity.customCheck and not entity.customCheck(LocalPlayer()) then
				essentialDarkRPF4Menu.displayItem = false
			end
		-- end

		if essentialDarkRPF4Menu.displayItem then
			table.insert(validItems, entity)

			essentialDarkRPF4Menu.selectedEntity = entity

			local entityCat = entity.category

			-- Add non-existing categories
			if not IsValid(entitiesListPanel[entityCat]) then
				entitiesListPanel[entityCat] = entitiesListPanel:Add('DCollapsibleCategory')

				local entityCatPanel = entitiesListPanel[entityCat]

				entityCatPanel:Dock(TOP)
				entityCatPanel:DockMargin(0, 0, 5, 3)
				entityCatPanel:SetLabel(entity.category)
				entityCatPanel:SetAnimTime(0.1)
				entityCatPanel:GetChildren()[1]:SetTall(35)

				function entityCatPanel:Paint() return end

				entityCatPanel.Header:SetTextColor(white)
				entityCatPanel.Header:SetFont('edf_Roboto20')

				function entityCatPanel.Header:Paint(w, h)
					local categoryColor = self.color or essentialDarkRPF4Menu.defaultCategoryColor

					surface.SetDrawColor(defaultBlurOutline)
					surface.DrawOutlinedRect(0, 0, w, h)

					surface.SetDrawColor(categoryColor)
					surface.DrawRect(1, 1, w - 2, h - 2)
				end

				-- Add panel containing the entity contents to category
				entityCatPanel.catContentsPanel = vgui.Create('DPanel')
				entityCatPanel.catContentsPanel:SizeToContents()

				function entityCatPanel.catContentsPanel:Paint() return end

				entityCatPanel:SetContents(entityCatPanel.catContentsPanel)
			end

			local entityCatPanel = entitiesListPanel[entityCat]

			local entityCategories = DarkRP.getCategories().entities

			for _, category in ipairs(entityCategories) do
				if entityCat == category.name then
					entityCatPanel.Header.color = Color(category.color['r'], category.color['g'], category.color['b'], 150)
				end
			end

			-- Add entities to category contents panel
			local entityButton = entityCatPanel.catContentsPanel:Add('DButton')
			entityButton:SetText('')
			entityButton:SetSize(0, 66)
			entityButton:Dock(TOP)
			entityButton:DockMargin(0, 3, 0, 0)

			function entityButton:Paint()
				drawRectOutlined(0, 0, self:GetWide(), self:GetTall(), defaultBlur)
			end

			function entityButton.DoClick()
				essentialDarkRPF4Menu.selectedEntity = entity

				-- Add stuff to right panel
				addEntityName()
				addEntityModel()
				addEntityPrice()

				buttonClickSound()
			end

			function entityButton.DoDoubleClick()
				if IsValid(purchaseEntityButton) then
					purchaseEntityButton:DoClick()
				end
			end

			local entityModel = entityButton:Add('SpawnIcon')
			entityModel:SetSize(64, 0)
			entityModel:Dock(LEFT)
			entityModel:DockMargin(1, 1, 1, 1)
			entityModel:SetModel(entity.model)

			function entityModel.DoClick()
				entityButton:DoClick()
			end

			local entityName = entityButton:Add('DLabel')
			entityName:Dock(LEFT)
			entityName:DockMargin(6, 0, 0, 0)
			entityName:SetText(entity.name)
			entityName:SetFont('edf_Roboto20')
			entityName:SetTextColor(white)
			entityName:SizeToContentsX()

			local pricePanel = entityButton:Add('DPanel')
			pricePanel:Dock(RIGHT)
			pricePanel:DockMargin(0, 0, 5, 0)
			pricePanel:SizeToContentsX()

			function pricePanel.Paint(w, h)
				draw.RoundedBox(28.49, 5, 5, pricePanel:GetTall() - 8, pricePanel:GetWide() - 8, Color(10, 10, 10, 120))
			end

			function pricePanel:OnMousePressed()
				entityButton:DoClick()
			end

			-- Entity price
			local entityPrice = pricePanel:Add('DLabel')
			entityPrice:Dock(FILL)
			entityPrice:DockMargin(0, 0, 0, 0)

			if entity.price < 1 then
				entityPrice:DockMargin(4, 0, 0, 0)
				entityPrice:SetText('Free')
			else
				entityPrice:DockMargin(0, 0, 0, 0)
				entityPrice:SetText('$' .. entity.price)
			end

			if entity.price < 1000 then
				entityPrice:SetFont('edf_Roboto20')
			elseif entity.price < 100000 then
				entityPrice:SetFont('edf_Roboto18')
			else
				entityPrice:SetFont('edf_Roboto16')
			end

			entityPrice:SetContentAlignment(5)
			entityPrice:SetTextColor(white)

			-- Add initial stuff to right panel
			addEntityName()
			addEntityModel()
			addEntityPrice()
		end
	end

	if #validItems < 1 then
		rightPanel:SetVisible(false)

		local unavailableLabel = essentialDarkRPF4Menu.ПредметыPanel:Add('DLabel')
		unavailableLabel:SetPos(0, 0)
		unavailableLabel:SetFont('edf_Roboto20')
		unavailableLabel:SetTextColor(white)
		unavailableLabel:SetText('The contents of this tab are not available for your job.')
		unavailableLabel:SizeToContents()
	end
end

function essentialDarkRPF4Menu.openПредметыTab()
	openПредметы()
end
