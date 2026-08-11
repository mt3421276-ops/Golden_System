# Golden System - Social & Battle Update

Added:
- Friends screen with friend requests, friends list, and friend ID entry.
- Private chat UI with persistent local messages.
- Group creation with selected friends and group chat UI.
- Battle-by-code flow with 6-digit room code creation/join.
- Battle screen with attack/strong attack/defense and result handling.
- Main navigation now includes Home, Friends/Chat, Shop, Licenses, and Profile.
- Existing language preference remains stored through SharedPreferences.

Important:
The current social and battle data are local to the device because this project does not yet contain a server/backend or Firebase configuration. A code generated on one phone cannot automatically connect to another phone yet. The UI/data models are structured so a realtime backend can be connected later without redesigning the screens.
