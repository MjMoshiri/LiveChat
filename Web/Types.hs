module Web.Types where
import IHP.LoginSupport.Types
import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
    newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User

data SessionsController
    = NewSessionAction
    | CreateSessionAction
    | DeleteSessionAction
    deriving (Eq, Show, Data)
data UsersController
    = UsersAction
    | NewUserAction
    | ShowUserAction { userId :: !(Id User) }
    | CreateUserAction
    | EditUserAction { userId :: !(Id User) }
    | UpdateUserAction { userId :: !(Id User) }
    | DeleteUserAction { userId :: !(Id User) }
    deriving (Eq, Show, Data)


data DashboardController
    = DashboardsAction 
    | CreateMessageDashboardAction {roomId :: Id Room}
    | RoomDashboardAction {roomId :: Id Room}
    | CreateRoomDashboardAction
    | RemoveRoomDashboardAction {roomId :: Id Room}
    | JoinRoomDashboardAction
    deriving (Eq, Show, Data)
