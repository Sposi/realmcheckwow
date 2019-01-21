local RealmCheckAddon = CreateFrame("Frame", "RealmCheckAddon", UIParent)
local matchFound = false
local holdApp = 0
local groupChk = 0
local sameRealm = true
local blackList = {"Ragnaros","Quel","Azralon","Goldrinn","Gallywix","TolBarad","Nemesis","Drakkari","Arthas"}

RealmCheck = {}

local RegisteredEvents = {}
RealmCheckAddon:SetScript("OnEvent", function (self, event, ...) if (RegisteredEvents[event]) then return RegisteredEvents[event](self, event, ...) end end)

function RegisteredEvents:PLAYER_LOGIN(event)
	local test = "RealmCheckv0.1 Loaded"
	print(test)
end

function RegisteredEvents:LFG_LIST_APPLICANT_LIST_UPDATED(event, hasNewPending, hasNewPendingWithData)
	if matchFound then
		C_LFGList.DeclineApplicant(holdApp)
	end
	print("LIST UPDATED")
end

function RegisteredEvents:LFG_LIST_APPLICANT_UPDATED(event, applicantID)
	matchFound = false
	holdApp = 0
	local id, status, pendingStatus, numMembers, isNew, comment = C_LFGList.GetApplicantInfo(applicantID)
	local name, class, localizedClass, level, itemLevel, tank, healer, damage, assignedRole, relationship = C_LFGList.GetApplicantMemberInfo(applicantID,1)
	for _, v in pairs(blackList) do
		if string.match(tostring(name), ('-' .. v)) or (sameRealm and string.match(tostring(name), ('-')) == nil) then
			matchFound = true
			holdApp = applicantID
		end
	end
	print(name)
	print("APPLICANT UPDATED")
end

for k, v in pairs(RegisteredEvents) do
	RealmCheckAddon:RegisterEvent(k)
end