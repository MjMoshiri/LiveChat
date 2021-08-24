{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PostfixOperators #-}
{-# LANGUAGE DeriveAnyClass #-}
module Web.Controller.Dashboard where
import Text.Parsec.String
import Web.Controller.Prelude
import Web.View.Dashboard.Index
import System.Random
import Control.Monad
import Data.Typeable
import Control.Exception


instance Controller DashboardController where
  
  action JoinRoomDashboardAction = do
        room <- query @Room |> filterWhere (#link, param @Text "link") |> fetchOneOrNothing
        let user = get #id currentUser
        case room of
          Just dmg -> do
            let roomUsers =newRecord @RoomUser
            roomUsers
                  |> set #roomId (get #id dmg)
                  |> set #userId user
                  |> createRecord
            clearSuccessMessage
          Nothing ->
            setErrorMessage "Invite Code Not Valid"
        redirectTo DashboardsAction

  action RemoveRoomDashboardAction {roomId}= do
        ensureIsUser
        room <- fetch roomId
        deleteRecord room
        redirectTo DashboardsAction

  action DashboardsAction = autoRefresh do
        ensureIsUser 
        rooms <- query @Room 
              |> distinct
              |> innerJoin @RoomUser (#id, #roomId) 
              |> filterWhereJoinedTable @RoomUser (#userId,(get #id currentUser))
              |> fetch
        let selectedRoom = Nothing
        render IndexView {..}

  action CreateMessageDashboardAction {roomId} = do
    ensureIsUser
    room <- fetch roomId
    let user = get #id currentUser
    let messageBody :: Text = param "body"
    message <-
      newRecord @Message
        |> set #roomId roomId
        |> set #body messageBody
        |> set #userId user
        |> set #userName (get #userName currentUser)
        |> createRecord
    redirectTo RoomDashboardAction {..}

  action RoomDashboardAction {roomId} = autoRefresh do
    rooms <- query @Room 
              |> distinct
              |> innerJoin @RoomUser (#id, #roomId) 
              |> filterWhereJoinedTable @RoomUser (#userId,(get #id currentUser))
              |> fetch
    room <-
      fetch roomId
        >>= fetchRelated #messages

    let selectedRoom = Just room

    render IndexView {..}
  

  action CreateRoomDashboardAction = do
    let room = newRecord @Room
    let user = get #id currentUser
    room
      |> set #adminId user
      |> fill @'["title","link"]
      |> validateField #title nonEmpty
      |> validateIsUnique #link
      >>= ifValid \case
        Left _ -> do
          setErrorMessage "Invite Code Already In Use"
          redirectTo DashboardsAction
        Right room -> do
          room |> createRecord
          result <- sqlQueryScalar "SELECT id FROM rooms WHERE link = ?" (Only (param @Text "link"))
          let roomUsers =newRecord @RoomUser
          roomUsers
                |> set #roomId result
                |> set #userId user
                |> createRecord
          clearSuccessMessage
          redirectTo DashboardsAction
          
buildDashboard dashboard = dashboard
    |> fill @'[]
