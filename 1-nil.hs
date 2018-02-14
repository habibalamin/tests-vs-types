module Main where

-- 1. Setup library code

data Time = Time Year Month Day deriving Show

type Year = Integer
type Month = Integer
type Day = Integer

data TimeRelativiser = Ago | FromNow

week :: Integer -> TimeRelativiser -> IO Time
week count rel = pure $ Time 2018 01 01

data Enquiry = Enquiry

type IncompleteQuery = String

type QueryParam = String

toParam :: Show a => a -> String
toParam = show

fetchExperienceBookingEnquiriesWhere
  :: IncompleteQuery
  -> [QueryParam]
  -> IO [Enquiry]
fetchExperienceBookingEnquiriesWhere
  _ _ = pure [Enquiry]

data User
  = User
      { name :: String
      , email :: String
      }

customerName :: Enquiry -> String
customerName _ = "John Smith"

creator :: Enquiry -> Maybe User
creator _ = Nothing

data Email
  = Email
      { to :: String
      , subject :: String
      , body :: String
      }

deliver :: Email -> IO ()
deliver _ = pure ()

forgottenEnquiryReminder :: Enquiry -> Email
forgottenEnquiryReminder enquiry =
  Email
    { to = email (creator enquiry)
    , subject = "Reminder: " ++ customerName enquiry ++ "is waiting \
                \for a booking"
    , body = "Hey " ++ name (creator enquiry) ++ ",\n\n\
             \We just wanted to quickly remind you that " ++
             customerName enquiry ++ "is still waiting for a booking.\n\

             \It's been a week since they received a response now; \
             \don't let them slip through the net :).\n\n\

             \Cheers,\n\
             \SalesMaster"
    }

sendForgottenEnquiryReminder :: Enquiry -> IO ()
sendForgottenEnquiryReminder =
  deliver . forgottenEnquiryReminder

-- 2. Setup application code

sendForgottenEnquiryReminders :: [Enquiry] -> IO ()
sendForgottenEnquiryReminders enquiries =
  mapM_ sendForgottenEnquiryReminder enquiries

-- 3. Execute application code

main :: IO ()
main = do
  oneWeekAgo <- 1 `week` Ago
  enquiries <- fetchExperienceBookingEnquiriesWhere
               "workflow_state = ? AND updated_at < ?"
               ["new", toParam oneWeekAgo]
  sendForgottenEnquiryReminders enquiries
