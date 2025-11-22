-- Shared constants for the Star Wars tablet system
local SWT = {}

SWT.Version = "1.0.0"
SWT.Net = {
    OpenRequest = "swt_tablet_request_data",
    Payload = "swt_tablet_payload",
    Action = "swt_tablet_action",
    Push = "swt_tablet_push"
}

SWT.DataFile = "starwars_tablet_data.json"

return SWT
