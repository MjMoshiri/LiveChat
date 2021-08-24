module Web.Controller.Users where

import Web.Controller.Prelude
import Web.View.Users.New
import Web.View.Users.Edit


instance Controller UsersController where


    action NewUserAction = do
        let user = newRecord
        render NewView { .. }


    action EditUserAction { userId } = do
        ensureIsUser
        user <- fetch userId
        render EditView { .. }

    action UpdateUserAction { userId } = do
        user <- fetch userId
        user
            |> fill @["userName" ,"email"]
            |> validateField #userName nonEmpty
            |> validateField #email isEmail 
            |> validateIsUniqueCaseInsensitive #userName
            >>= ifValid \case
                Left user -> render EditView { .. }
                Right user -> do
                    user <- user |> updateRecord
                    setSuccessMessage "User updated"
                    redirectTo EditUserAction { .. }

    action CreateUserAction = do
        let user = newRecord @User
        user
            |> buildUser
            >>=ifValid \case
                Left user -> render NewView { .. }
                Right user -> do
                    hashed <- hashPassword (get #passwordHash user)
                    user <- user
                        |> set #passwordHash hashed
                        |> createRecord
                    setSuccessMessage "You have registered successfully Please Log In"
                    redirectToPath "/NewSession"



buildUser user = user
            |> fill @["userName" ,"email", "passwordHash"]
            |> validateField #userName nonEmpty
            |> validateField #email isEmail 
            |> validateField #passwordHash nonEmpty
            |> validateIsUniqueCaseInsensitive #userName
