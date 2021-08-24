module Web.View.Partials.Rooms (showRooms) where

import Web.View.Prelude

showRooms :: [Room] -> Html
showRooms rooms =
  [hsx|
    <h4 class="text-center">Rooms</h4>
    <h6 class="text-center text-secondary">Hover pointer on room name to view invite code </h6>
    <ul class="list-unstyled list-group list-group-flush" style="overflow-x: auto; height: 40vh;">
      {forEach rooms showRoom}
    </ul>
    {createRoom}
    {joinRoom}
  |]

showRoom :: Room -> Html
showRoom room =
  [hsx|
    <li class="list-group-item" style="font-size:20px;">
      <a href={roomPath room} title={get #link room}>{get #title room}</a>

    </li>
  |]
  where
    roomPath room =
      let id :: Id Room = get #id room
       in RoomDashboardAction {roomId = id}

createRoom :: Html
createRoom =
  [hsx|
    <form action={pathTo CreateRoomDashboardAction} method="POST">
      <table>
      <tr>
      <td>
      <input type="text" id="room_title" name="title" placeholder="Create Room">
      </td>
      <td>
      <input type="text" id="room_link" name="link" placeholder="Invite Code">
      </td>
      </tr>
      </table>
      <button type="submit">Create</button>
    </form>
  |]

joinRoom ::  Html
joinRoom =
  [hsx|
    <form action={joinRoomPath} method="POST">
      <input type="text" id="link" name="link" placeholder="Invite Code">
      <button type="submit">joinRoomPath</button>
    </form>
  |]
  where
      joinRoomPath = pathTo JoinRoomDashboardAction 