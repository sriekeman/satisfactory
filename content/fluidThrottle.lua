panel = null
powerSwitch = null

storageTanks = {}
tankCountLabel = null
tankCount = null
capacityLabel = null
capacity = null
maxCapacityLabel = null
maxCapacity = null
capacityPctLabel = null
capacityPct = null
local _containerTypes = {"BigStorage_C"}

--	Tanks		#
--	Current		#
--	Max			#
--	Pct			%

-- Round numbers with spaces infront or amount of decimal places
function Round(num, numPlaces, numDecimalPlaces)
	return string.format("%" .. (numPlaces or 0) .. "." .. (numDecimalPlaces or 0) .. "f", num)
end

function GetPanelModule(x, y, text)
	local display = panel:getModule(x, y)
	display.text = text
    display.size = 80
    display.monospace = true
	return display
end

--##### Initialize storage containers #####--
function FetchContainers()
	for _, containerType in pairs(_containerTypes) do
		local containers = component.proxy(component.findComponent(findClass(containerType)))

		if not containers then
			error("ERROR: No containers connected.")
		end

		for _, container in pairs(containers) do
			table.insert(storageTanks, container)
		end
	end
end

function Initialise()
  -- Get the console panel
  panel = component.proxy("0A31490445A7E08A154E7994C4FE9D4E") -- Main Console
	powerSwitch = component.proxy("887966684324EF71145799B32759F3C5")
	powerSwitch.isSwitchOn = false

  -- Get and Initialise displays
  tankCountLabel = GetPanelModule(0, 10, "Tank #:")
  tankCount = GetPanelModule(5, 10, "")
  capacityLabel = GetPanelModule(0, 8, "Current:")
  capacity = GetPanelModule(5, 8, "")
  maxCapacityLabel = GetPanelModule(0, 6, "Maximum:")
  maxCapacity = GetPanelModule(5, 6, "")
  capacityPctLabel = GetPanelModule(0, 4, "Percent:")
  capacityPct = GetPanelModule(5, 4, "")
end

function Update()
  -- Runs periodically
	local current = 0
	local max = 0

	for _, v in ipairs(storageTanks) do
		current = current + v.fluidContent
		max = max + v.maxFluidContent
	end
	local pct = (current * 100)/ max

	if (pct < 20) then
		powerSwitch.isSwitchOn = true
	else
		powerSwitch.isSwitchOn = false
	end

	tankCount.text = tostring(#storageTanks)
	capacity.text = Round(current, 0, 2)
	maxCapacity.text = Round(max, 0, 0)
	capacityPct.text = Round(pct, 0, 2)
end

FetchContainers()
Initialise()
while true do
	Update()
	event.pull(15)
end